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
    var numberOfCells: Int { get }
    func cellModel(at index: Int) -> BaseViewModel
}

class DateCalculationViewModel {
    weak var view: DateCalculationViewProtocol?
    private let state: String
    private let manager: QueueManager
    private var startDate: Date?
    private var endDate: Date?
    
    private var numberOfDays: Int?
    private var holidays: [Holiday] = []
    private var holidayCellModels: [HolidayTableViewModel] = []
    
    private lazy var weekDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private lazy var colors: [HolidayTableViewModel.Color] = [
        HolidayTableViewModel.Color(indicatorColor: .appDarkPurple,
                                    backgroundColor: .appLightPurple,
                                    textColor: .appDarkPurple),
        HolidayTableViewModel.Color(indicatorColor: .appDarkRed,
                                    backgroundColor: .appLightRed,
                                    textColor: .appDarkPurple),
        HolidayTableViewModel.Color(indicatorColor: .appDarkGreen,
                                    backgroundColor: .appLightGreen,
                                    textColor: .appDarkPurple),
        HolidayTableViewModel.Color(indicatorColor: .appDarkOrange,
                                    backgroundColor: .appLightOrange,
                                    textColor: .appDarkPurple),
    ]
    
    init(state: String,
         manager: QueueManager = QueueManager.shared) {
        self.state = state
        self.manager = manager
    }
    
    func calculateWeekdaysWithGivenDates() {
        guard let start = startDate, let end = endDate else { return }
        
        let operation = DateCalculationOperation(state: state, date1: start, date2: end)
        operation.completionHandler = { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let numberOfDays, let holidays):
                    self.numberOfDays = numberOfDays
                    self.holidays = holidays
                    
                    self.holidayCellModels.removeAll()
                    for (index, holiday) in self.holidays.enumerated() {
                        let color = self.colors[index % self.colors.count]
                        self.holidayCellModels.append(HolidayTableViewModel(name: holiday.name,
                                                                       weekDay: self.weekDayFormatter.string(from: holiday.day),
                                                                       day: self.dayFormatter.string(from: holiday.day),
                                                                       colors: color))
                    }
                    self.view?.configure(with: self)
                case .failure(let error):
                    self.view?.handleError(error)
                    break
                }
            }
        }
        manager.queue(operation)
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
    
    var numberOfCells: Int {
        return holidayCellModels.count
    }
    func cellModel(at index: Int) -> BaseViewModel {
        return holidayCellModels[index]
    }
}
