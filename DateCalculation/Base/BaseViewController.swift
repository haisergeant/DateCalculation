//
//  BaseViewController.swift
//  TechnicalTest
//
//  Created by Hai Le Thanh on 4/17/20.
//  Copyright © 2020 Hai Le Thanh. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var loadingView = LoadingView()
    
    var backgroundColor: UIColor {
        return .clear
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureLayout()
        configureContents()
        self.view.backgroundColor = backgroundColor
    }
    
    // To be overriden
    func configureSubviews() { }
    func configureLayout() { }
    func configureContents() { }
    
    func showError(_ error: Error, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            self?.dismiss(animated: true, completion: completion)
        })
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoadinng() {
        loadingView.showLoading(on: view)
    }
    
    func hideLoading() {
        loadingView.removeFromSuperview()
    }
}
