//
//  LoadingView.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/19/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

// MARK: - LoadingView
final class LoadingView: BaseView {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)
    
    override func configureSubviews() {
        super.configureSubviews()
        addSubview(blurView)
        blurView.contentView.addSubview(loadingIndicator)
        
        backgroundColor = .clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = false
    }
    
    override func configureLayout() {
        super.configureLayout()
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // Public functions
    func showLoading(on view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
