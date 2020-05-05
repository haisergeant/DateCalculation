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
}

class DateCalculationViewController: BaseViewController {
    private let topView = UIView()
    
    private let horizontalStackView = UIStackView()
    
    private let buttonStackView = UIStackView()
    private let startButton = UIButton()
    private let endButton = UIButton()
    
    private let labelStackView = UIStackView()
    private let daysLabel = UILabel()
    private let numberOfDaysLabel = UILabel()
    
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
        view.addSubview(datePicker)
        topView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(buttonStackView)
        horizontalStackView.addArrangedSubview(labelStackView)
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(endButton)
        
        labelStackView.addArrangedSubview(daysLabel)
        labelStackView.addArrangedSubview(numberOfDaysLabel)
        
        datePicker.alpha = 0
    }
    
    override func configureLayout() {
        super.configureLayout()
        [topView, horizontalStackView, buttonStackView,
         startButton, endButton, labelStackView, daysLabel, numberOfDaysLabel, datePicker].forEach { $0.disableTranslatesAutoResizing() }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    }
    
    override func configureContents() {
        super.configureContents()
        startButton.setTitle("Select START date", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        endButton.setTitle("Select END date", for: .normal)
        endButton.setTitleColor(.black, for: .normal)
        
        daysLabel.text = "Weekdays"
        numberOfDaysLabel.text = "--"
        horizontalStackView.axis = .horizontal
        buttonStackView.axis = .vertical
        labelStackView.axis = .vertical
        
        datePicker.delegate = self
        datePicker.configureDatePickerMode(.date)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
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
    }
}
