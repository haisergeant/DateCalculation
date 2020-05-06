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
    let colors: Color
    
    struct Color {
        let indicatorColor: UIColor
        let backgroundColor: UIColor
        let textColor: UIColor
    }
}

class HolidayTableViewCell: BaseTableViewCell {
    private let container = UIView()
    
    private let indicator = UIView()
    private let stackView = UIStackView()
    private let leftContainer = UIView()
    private let nameLabel = UILabel()
    
    private let rightContainer = UIView()
    private let rightStackView = UIStackView()
    private let weekDayLabel = UILabel()
    private let dayLabel = UILabel()
    
    override func configureSubviews() {
        super.configureSubviews()
        contentView.addSubview(container)
        container.addSubview(stackView)
        stackView.addArrangedSubview(indicator)
        stackView.addArrangedSubview(leftContainer)
        stackView.addArrangedSubview(rightContainer)
        stackView.spacing = 10
        
        leftContainer.addSubview(nameLabel)
        
        rightContainer.addSubview(rightStackView)
        rightStackView.addArrangedSubview(weekDayLabel)
        rightStackView.addArrangedSubview(dayLabel)
        
        stackView.axis = .horizontal
        rightStackView.axis = .vertical
        
        nameLabel.textAlignment = .left
        weekDayLabel.textAlignment = .right
        dayLabel.textAlignment = .right
        
        container.layer.cornerRadius = 4
        container.clipsToBounds = true
        self.selectionStyle = .none
    }
    
    override func configureLayout() {
        super.configureLayout()
        [container, stackView, indicator, leftContainer, rightContainer, nameLabel,
         rightStackView, weekDayLabel, dayLabel].forEach { $0.disableTranslatesAutoResizing() }
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: leftContainer.topAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightStackView.topAnchor.constraint(equalTo: rightContainer.topAnchor, constant: 10),
            rightStackView.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor, constant: -10),
            rightStackView.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            rightStackView.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            rightContainer.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    override func configure(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? HolidayTableViewModel else { return }
        nameLabel.text = viewModel.name
        weekDayLabel.text = viewModel.weekDay
        dayLabel.text = viewModel.day
        
        indicator.backgroundColor = viewModel.colors.indicatorColor
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        [nameLabel, weekDayLabel, dayLabel].forEach { $0.textColor = viewModel.colors.textColor }
        container.backgroundColor = viewModel.colors.backgroundColor
    }
}
