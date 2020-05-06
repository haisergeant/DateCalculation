//
//  DateCalculationViewController.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 5/4/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

enum DateSelectionState {
    case start
    case end
}

protocol DateCalculationViewProtocol: class {
    func configure(with viewModel: DateCalculationViewModelProtocol)
    func handleError(_ error: Error)
}

class DateCalculationViewController: BaseViewController {
    private let topView = UIView()
    
    private let horizontalStackView = UIStackView()
    
    private let buttonStackView = UIStackView()
    private let startButton = UIButton()
    private let endButton = UIButton()
    
    private let labelStackView = UIStackView()
    private let daysContainer = UIView()
    private let daysLabel = UILabel()
    private let numberContainer = UIView()
    private let numberOfDaysLabel = UILabel()
    private let tableView = UITableView()
    
    private let datePicker = DatePickerView()
    private var dateState: DateSelectionState? = .start
    private var viewModel: DateCalculationViewModelProtocol?
    
    private lazy var formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd/MM/yyyy"
        return formatter
    }()
    
    init(viewModel: DateCalculationViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
        viewModel.bind(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(datePicker)
        
        topView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(buttonStackView)
        horizontalStackView.addArrangedSubview(labelStackView)
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(endButton)
        
        labelStackView.addArrangedSubview(daysContainer)
        daysContainer.addSubview(daysLabel)
        labelStackView.addArrangedSubview(numberContainer)
        numberContainer.addSubview(numberOfDaysLabel)
        
        datePicker.alpha = 0
    }
    
    override func configureLayout() {
        super.configureLayout()
        [topView, horizontalStackView, buttonStackView,
         startButton, endButton, labelStackView, daysLabel, numberOfDaysLabel, tableView, datePicker].forEach { $0.disableTranslatesAutoResizing() }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            horizontalStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            horizontalStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            daysLabel.leftAnchor.constraint(equalTo: daysContainer.leftAnchor),
            daysLabel.rightAnchor.constraint(equalTo: daysContainer.rightAnchor),
            daysLabel.topAnchor.constraint(greaterThanOrEqualTo: daysContainer.topAnchor),
            daysLabel.bottomAnchor.constraint(lessThanOrEqualTo: daysContainer.bottomAnchor),
            daysLabel.firstBaselineAnchor.constraint(equalTo: startButton.firstBaselineAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numberOfDaysLabel.leftAnchor.constraint(equalTo: numberContainer.leftAnchor),
            numberOfDaysLabel.rightAnchor.constraint(equalTo: numberContainer.rightAnchor),
            numberOfDaysLabel.topAnchor.constraint(greaterThanOrEqualTo: numberContainer.topAnchor),
            numberOfDaysLabel.bottomAnchor.constraint(lessThanOrEqualTo: numberContainer.bottomAnchor),
            numberOfDaysLabel.firstBaselineAnchor.constraint(equalTo: endButton.firstBaselineAnchor)
        ])
        daysLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        numberOfDaysLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func configureContents() {
        super.configureContents()
        topView.backgroundColor = .appLightPurple
        startButton.setTitle("Select START date", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(.appLightPurple, for: .normal)
        startButton.backgroundColor = .appDarkPurple
        startButton.layer.cornerRadius = 4
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        endButton.setTitle("Select END date", for: .normal)
        endButton.setTitleColor(.black, for: .normal)
        endButton.setTitleColor(.appLightPurple, for: .normal)
        endButton.backgroundColor = .appDarkPurple
        endButton.layer.cornerRadius = 4
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
        
        daysLabel.text = "Weekdays"
        daysLabel.textAlignment = .center
        daysLabel.textColor = .appDarkPurple
        daysLabel.font = UIFont.boldSystemFont(ofSize: 18)
        numberOfDaysLabel.text = "--"
        numberOfDaysLabel.textAlignment = .center
        numberOfDaysLabel.textColor = .appDarkPurple
        numberOfDaysLabel.font = UIFont.systemFont(ofSize: 16)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 20
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
        
        datePicker.delegate = self
        datePicker.configureDatePickerMode(.date)
        
        tableView.dataSource = self
        tableView.register(HolidayTableViewCell.self)
        tableView.separatorColor = .clear
    }
    
    override var backgroundColor: UIColor {
        return .white
    }
}

private extension DateCalculationViewController {
    @objc private func startButtonTapped() {
        dateState = .start
        showDatePicker(with: viewModel?.start)
    }
    
    @objc private func endButtonTapped() {
        dateState = .end
        showDatePicker(with: viewModel?.end)
    }
    
    private func showDatePicker(with date: Date?) {
        if let date = date {
            datePicker.presetDate(date)
        }
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.datePicker.alpha = 1
        }
    }
    
    private func hideDatePicker() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.datePicker.alpha = 0
        }
    }
}

extension DateCalculationViewController: DatePickerViewDelegate {
    func datePickerViewDidTapDone(_ sender: DatePickerView, date: Date) {
        hideDatePicker()
        guard let dateState = dateState else { return }
        switch dateState {
        case .start:
            startButton.setTitle(formatter.string(from: date), for: .normal)
            viewModel?.updateStartDate(date)
        case .end:
            endButton.setTitle(formatter.string(from: date), for: .normal)
            viewModel?.updateEndDate(date)
        }
    }
    
    func datePickerViewDidTapCancel(_ sender: DatePickerView) {
        hideDatePicker()
    }
}

extension DateCalculationViewController: DateCalculationViewProtocol {
    func configure(with viewModel: DateCalculationViewModelProtocol) {
        guard let dayDifference = viewModel.dayDifference else { return }
        numberOfDaysLabel.text = String(dayDifference)
        tableView.reloadData()
    }
    
    func handleError(_ error: Error) {
          showError(error)
      }
}

extension DateCalculationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfCells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel?.cellModel(at: indexPath.row) else { return UITableViewCell() }
        let cell: HolidayTableViewCell = tableView.dequeueReuseableCell(indexPath: indexPath)
        cell.configure(with: cellModel)
        return cell
    }
}
