//
//  DatePickerView.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 5/4/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate: class {
    func datePickerViewDidTapCancel(_ sender: DatePickerView)
    func datePickerViewDidTapDone(_ sender: DatePickerView, date: Date)
}

class DatePickerView: BaseView {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let stackView = UIStackView()
    
    private let buttonView = UIView()
    private let cancelButton = UIButton()
    private let doneButton = UIButton()
    
    private let datePicker = UIDatePicker()
    
    weak var delegate: DatePickerViewDelegate?
    
    func presetDate(_ date: Date) {
        datePicker.setDate(date, animated: false)
    }
    
    func configureDatePickerMode(_ datePickerMode: UIDatePicker.Mode) {
        datePicker.datePickerMode = datePickerMode
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        addSubview(blurView)
        addSubview(stackView)
        stackView.addArrangedSubview(buttonView)
        stackView.addArrangedSubview(datePicker)
        
        buttonView.addSubview(doneButton)
        buttonView.backgroundColor = .appLightPurple
        buttonView.addSubview(cancelButton)
        
        doneButton.setTitleColor(.appDarkPurple, for: .normal)
        cancelButton.setTitleColor(.appDarkPurple, for: .normal)
    }
    
    override func configureLayout() {
        super.configureLayout()
        [blurView, stackView, buttonView, cancelButton, doneButton, datePicker].forEach { $0.disableTranslatesAutoResizing() }
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 8),
            cancelButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -8),
            doneButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancelButton.trailingAnchor, constant: 20)
        ])
    }
    
    override func configureContent() {
        super.configureContent()
        stackView.axis = .vertical
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.black, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    override func configureActions() {
        super.configureActions()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.datePickerViewDidTapCancel(self)
    }
    
    @objc private func doneButtonTapped() {
        delegate?.datePickerViewDidTapDone(self, date: datePicker.date)
    }
}
