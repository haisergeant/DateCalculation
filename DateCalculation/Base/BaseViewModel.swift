//
//  BaseViewModel.swift
//  WeatherApp
//
//  Created by Hai Le on 8/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

protocol BaseViewModel { }

protocol ViewConfigurable {
    func configure(with viewModel: BaseViewModel)
}
