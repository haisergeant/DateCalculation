//
//  BaseView.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/19/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

class BaseView: UIView, ViewConfigurable {
    init() {
        super.init(frame: .zero)
        configureSubviews()
        configureLayout()
        configureContent()
        configureStyle()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureSubviews() { }
    func configureLayout() { }
    func configureContent() { }
    func configureStyle() { }
    func configureActions() { }
    func configure(with viewModel: BaseViewModel) { }

}
