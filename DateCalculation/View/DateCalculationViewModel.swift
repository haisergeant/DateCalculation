//
//  DateCalculationViewModel.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 5/5/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

protocol DateCalculationViewModelProtocol {
    func bind(to view: DateCalculationViewProtocol)
    func updateStartDate(_ date: Date)
    func updateEndDate(_ date: Date)
    
    var dayDifference: Int? { get }
    var start: Date? { get }
    var end: Date? { get }
}

class DateCalculationViewModel {
    weak var view: DateCalculationViewProtocol?
    private let state: String
    private let manager: DayManagerProtocol
    private var startDate: Date?
    private var endDate: Date?
    
    private var numberOfDays: Int?
    
    init(state: String = "nsw",
         manager: DayManagerProtocol = DayManager.shared) {
        self.state = state
        self.manager = manager
    }
    
    func calculateWeekdaysWithGivenDates() {
        guard let start = startDate, let end = endDate else { return }
        numberOfDays = manager.numberOfWeekdaysBetween(date1: start, date2: end)
        view?.configure(with: self)
    }
}

extension DateCalculationViewModel: DateCalculationViewModelProtocol {
    func bind(to view: DateCalculationViewProtocol) {
        self.view = view
    }
    
    func updateStartDate(_ date: Date) {
        startDate = date
        calculateWeekdaysWithGivenDates()
    }
    
    func updateEndDate(_ date: Date) {
        endDate = date
        calculateWeekdaysWithGivenDates()
    }
    
    var dayDifference: Int? {
        return numberOfDays
    }
    
    var start: Date? {
        return startDate
    }
    var end: Date? {
        return endDate
    }
}
