//
//  Date+Extension.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 5/4/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

extension Date {
    static func date(from string: String, dateFormat: String = "dd/MM/yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
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
