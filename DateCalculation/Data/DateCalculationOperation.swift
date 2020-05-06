//
//  DateCalculationOperation.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 5/6/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

class DateCalculationOperation: BaseOperation<(Int, [Holiday])> {
    private let decoder = JSONDecoder()
    private var dayDataList: [DayData] = []
    
    // TODO: For test - Remove timezone
    private let timeZone = TimeZone(abbreviation: "GMT+0:00")
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private let state: String
    private let date1: Date
    private let date2: Date
    
    init(state: String, date1: Date, date2: Date) {
        self.state = state
        self.date1 = date1
        self.date2 = date2
    }
    
    override func main() {
        var list: [DayData] = []
        if let resourceURL = Bundle.main.url(forResource: state, withExtension: "json"),
            let data = try? Data(contentsOf: resourceURL),
            let dayDataList = try? decoder.decode([DayData].self, from: data) {
            list = dayDataList
        }
        dayDataList = list
        
        guard date1 != date2 else {
            complete(result: .success((0, [])))
            return
        }
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
        
        guard let startWeek = calendar.ordinality(of: .weekOfYear, in: .era, for: start),
            let endWeek = calendar.ordinality(of: .weekOfYear, in: .era, for: end),
            let startDay = calendar.ordinality(of: .day, in: .era, for: start),
            let endDay = calendar.ordinality(of: .day, in: .era, for: end) else {
                complete(result: .success((0, [])))
                return
        }
        
        let startYear = calendar.component(.year, from: start)
        let endYear = calendar.component(.year, from: end)
        
        // Find holiday for each year from startYear to endYear
        var holidayList = [Holiday]()
        
        for i in startYear...endYear {
            holidayList.append(contentsOf: configureHolidays(for: i))
        }
        
        // Subtract holiday falls on weekday from start to end date
        let filteredHolidayList = holidayList.filter {
            var startCheck = $0.day > start
            if alreadyExcludeStartDate {
                startCheck = $0.day >= start
            }
            var endCheck = $0.day < end
            if alreadyExcludeEndDate {
                endCheck =  $0.day <= end
            }
            return startCheck && endCheck
        }
        var result = endDay - startDay - (endWeek - startWeek) * 2 - filteredHolidayList.count
        if alreadyExcludeStartDate {
            result += 1
        }
        if !alreadyExcludeEndDate {
            result -= 1
        }
        complete(result: .success((result, filteredHolidayList)))
    }
}

private extension DateCalculationOperation {
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
        
        return holidays.sorted(by: { $0.day < $1.day } )
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
}
