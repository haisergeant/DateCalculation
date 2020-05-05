import UIKit

extension Date {
    static func date(from string: String, dateFormat: String = "dd/MM/yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.date(from: string)
    }

    static func dateFromDDMMYYYYString(_ string: String) -> Date? {
        return date(from: string, dateFormat: "dd/MM/yyyy")
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = calendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
    
    func dayOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    var isWeekend: Bool {
        guard let dayOfWeek = dayOfWeek() else { return false }
        return dayOfWeek == 1 || dayOfWeek == 7
    }
}

// Format holiday data from file
enum DayDataType: String, Decodable {
    case exactDay
    case dayOfMonth
}

struct DayData: Decodable {
    let name: String
    let type: DayDataType
    let day: String?
    let moveToNearWeekDayIfWeekend: Bool?
    
    let order: Int?
    let dayOfWeek: Int?
    let month: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case day
        case moveToNearWeekDayIfWeekend
        case order
        case dayOfWeek
        case month
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container?.decode(String.self, forKey: .name)) ?? ""
        self.type = (try? container?.decode(DayDataType.self, forKey: .type)) ?? DayDataType.exactDay
        self.day = try? container?.decode(String.self, forKey: .day)
        self.moveToNearWeekDayIfWeekend = try? container?.decode(Bool.self, forKey: .moveToNearWeekDayIfWeekend)
        self.order = try? container?.decode(Int.self, forKey: .order)
        self.dayOfWeek = try? container?.decode(Int.self, forKey: .dayOfWeek)
        self.month = try? container?.decode(Int.self, forKey: .month)
    }
}

struct Holiday {
    let name: String
    let originalDay: Date
    let day: Date
}

class DayManager {
    static let shared = DayManager()
    
    private let decoder = JSONDecoder()
    private var dayDataList: [DayData]
    
    // TODO: For test - Remove timezone
    private let timeZone = TimeZone(abbreviation: "GMT+0:00")
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    init() {
        var list: [DayData] = []
        if let resourceURL = Bundle.main.url(forResource: "days", withExtension: "json"),
            let data = try? Data(contentsOf: resourceURL),
            let dayDataList = try? decoder.decode([DayData].self, from: data) {
            list = dayDataList
        }
        dayDataList = list
        
        // TODO: For test - Remove
        /*
        let date = Date()
        for i in 2020...2025 {
            let holidays = configureHolidays(for: i)
            holidays.forEach {
                print("name: \($0.name), day: \($0.day)")
            }
            print("==========================\n\n")
        }
        let next = Date()
        print("time: \(next.timeIntervalSince(date))")
         */
    }
    
    
    
    private func configureHolidays(for year: Int) -> [Holiday] {
        let exactDays = dayDataList.compactMap { dayData -> Date? in
            switch dayData.type {
            case .exactDay:
                guard let dayStr = dayData.day else { return nil }
                let dayString = dayStr + "/" + String(year)
                guard let day = dateFormatter.date(from: dayString) else { return nil }
                return day
            case .dayOfMonth:
                return nil
            }
        }
        var storedHolidays = [Date]()
        var holidays = dayDataList.compactMap { dayData -> Holiday? in
            switch dayData.type {
            case .exactDay:
                guard let holiday = makeHoliday(from: dayData,
                                                year: year,
                                                originalDays: exactDays,
                                                storedHolidays: storedHolidays) else { return nil }
                storedHolidays.append(holiday.day)
                return holiday
            case .dayOfMonth:
                return findDayOfMonth(for: dayData, year: year)
            }
        }
        
        // Calculate Easter holidays
        holidays.append(contentsOf: findEasterDays(for: year))
        return holidays
    }
    
    private func makeHoliday(from dayData: DayData, year: Int, originalDays: [Date], storedHolidays: [Date]) -> Holiday? {
        guard let dayStr = dayData.day,
            let moveToNearWeekday = dayData.moveToNearWeekDayIfWeekend else { return nil }
        let dayString = dayStr + "/" + String(year)
        guard let day = dateFormatter.date(from: dayString) else { return nil }
        if day.isWeekend {
            if moveToNearWeekday {
                return findNearWeekday(for: day, name: dayData.name, originalDates: originalDays, with: storedHolidays)
            } else {
                return nil
            }
        } else {
            return Holiday(name: dayData.name, originalDay: day, day: day)
        }
    }
    
    private func findNearWeekday(for weekendDate: Date,
                                 name: String = "",
                                 forward: Bool = true,
                                 originalDates: [Date] = [],
                                 with storedHolidays: [Date] = []) -> Holiday? {
        var date = weekendDate
        while date.isWeekend || storedHolidays.contains(date) || originalDates.contains(date) {
            if let nextDate = Calendar.current.date(byAdding: .day, value: forward ? 1 : -1, to: date) {
                date = nextDate
            }
        }
        return Holiday(name: name, originalDay: weekendDate, day: date)
    }
    
    private func findDayOfMonth(for dayData: DayData, year: Int) -> Holiday? {
        guard let order = dayData.order, let dayOfWeek = dayData.dayOfWeek,
            let month = dayData.month else { return nil }
        let dateComponents = DateComponents(timeZone: timeZone,
                                            year: year,
                                            month: month,
                                            weekday: dayOfWeek,
                                            weekdayOrdinal: order)
        guard let day = Calendar.current.date(from: dateComponents) else { return nil }
        return Holiday(name: dayData.name, originalDay: day, day: day)
    }
    
    private func findEasterDays(for year: Int) -> [Holiday] {
        guard let easterSunday = easterSunday(year: year),
            let easterFriday = Calendar.current.date(byAdding: .day, value: -2, to: easterSunday),
            let easterMonday = Calendar.current.date(byAdding: .day, value: 1, to: easterSunday) else { return [] }
        let fridayHoliday = Holiday(name: "Good Friday", originalDay: easterFriday, day: easterFriday)
        let mondayHoliday = Holiday(name: "Easter Monday", originalDay: easterMonday, day: easterMonday)
        return [fridayHoliday, mondayHoliday]
    }
    
    private func easterSunday(year: Int) -> Date? {
        let a = year % 19
        let b = Int(floor(Double(year) / 100))
        let c = year % 100
        let d = Int(floor(Double(b) / 4))
        let e = b % 4
        let f = Int(floor(Double(b + 8) / 25))
        let g = Int(floor(Double(b - f + 1) / 3))
        let h = (19 * a + b - d - g + 15) % 30
        let i = Int(floor(Double(c) / 4))
        let k = c % 4
        let L = (32 + 2 * e + 2 * i - h - k) % 7
        let m = Int(floor(Double(a + 11 * h + 22 * L) / 451))
        let components = DateComponents(timeZone: timeZone,
                                        year: year,
                                        month: Int(floor(Double(h + L - 7 * m + 114) / 31)),
                                        day: ((h + L - 7 * m + 114) % 31) + 1)
        return Calendar.current.date(from: components)
    }
    
    func numberOfWeekdaysBetween(date1: Date, date2: Date) -> (days: Int, holiday: [Holiday]) {
        guard date1 != date2 else { return (0, []) }
        var start = date1
        var end = date2
        if date1 > date2 {
            start = date2
            end = date1
        }
        let calendar = Calendar.current
        
        // Find next weekday for start, and prev weekday for end if it is in weekend
        var alreadyExcludeStartDate = false
        if start.isWeekend, let nextNearWeekday = findNearWeekday(for: start) {
            start = nextNearWeekday.day
            alreadyExcludeStartDate = true
        }
        var alreadyExcludeEndDate = false
        if end.isWeekend, let prevNearWeekday = findNearWeekday(for: end, forward: false) {
            end = prevNearWeekday.day
            alreadyExcludeEndDate = true
        }
        
        guard let startWeek = calendar.ordinality(of: .weekday, in: .era, for: start),
            let endWeek = calendar.ordinality(of: .weekday, in: .era, for: end),
            let startDay = calendar.ordinality(of: .day, in: .era, for: start),
            let endDay = calendar.ordinality(of: .day, in: .era, for: end) else { return (0, []) }
        
        let startYear = calendar.component(.year, from: start)
        let endYear = calendar.component(.year, from: end)
        
        // Find holiday for each year from startYear to endYear
        var holidayList = [Holiday]()
        
        for i in startYear...endYear {
            holidayList.append(contentsOf: configureHolidays(for: i))
        }
        
        // Subtract holiday falls on weekday from start to end date
        let filteredHolidayList = holidayList.filter { $0.day >= start && $0.day <= end }
        var result = endDay - startDay - (endWeek - startWeek) * 2 - filteredHolidayList.count
        if alreadyExcludeStartDate {
            result += 1
        }
        if !alreadyExcludeEndDate {
            result -= 1
        }
        return (result, filteredHolidayList)
    }
}

let fromDate = Date.date(from: "29/12/2019")!
let toDate = Date.date(from: "31/5/2020")!

let result = DayManager.shared.numberOfWeekdaysBetween(date1: fromDate, date2: toDate)
print("day: \(result.days)")
print("holiday: \(result.holiday.count)")
print("holiday: \(result.holiday.map { $0.day })")
