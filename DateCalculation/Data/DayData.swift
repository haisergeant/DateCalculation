//
//  DayManager.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 4/30/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import Foundation

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
