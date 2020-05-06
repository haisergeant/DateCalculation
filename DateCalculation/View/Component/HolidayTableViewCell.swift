//
//  HolidayTableViewCell.swift
//  DateCalculation
//
//  Created by Hai Le Thanh on 5/5/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

struct HolidayTableViewModel: BaseViewModel {
    let name: String
    let weekDay: String
    let day: String
}

class HolidayTableViewCell: BaseTableViewCell {
    
    private let stackView = UIStackView()
    private let leftContainer = UIView()
    private let nameLabel = UILabel()
    
    private let rightContainer = UIView()
    private let rightStackView = UIStackView()
    private let weekDayLabel = UILabel()
    private let dayLabel = UILabel()
    
    override func configureSubviews() {
        super.configureSubviews()
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(leftContainer)
        stackView.addArrangedSubview(rightContainer)
        
        leftContainer.addSubview(nameLabel)
        
        rightContainer.addSubview(rightStackView)
        rightStackView.addArrangedSubview(weekDayLabel)
        rightStackView.addArrangedSubview(dayLabel)
        
        stackView.axis = .horizontal
        rightStackView.axis = .vertical
    }
    
    override func configureLayout() {
        super.configureLayout()
        [stackView, leftContainer, rightContainer, nameLabel,
         rightStackView, weekDayLabel, dayLabel].forEach { $0.disableTranslatesAutoResizing() }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: leftContainer.topAnchor, constant: 0),
            nameLabel.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightStackView.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor),
            rightStackView.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            rightStackView.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor)
        ])
    }
    
    override func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? HolidayTableViewModel else { return }
        nameLabel.text = viewModel.name
        weekDayLabel.text = viewModel.weekDay
        dayLabel.text = viewModel.day
    }
}
