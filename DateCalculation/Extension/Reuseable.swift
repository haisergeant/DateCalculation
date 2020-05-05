//
//  Reuseable.swift
//  WeatherApp
//
//  Created by Hai Le on 8/4/20.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import UIKit

protocol Reuseable {
    static var reuseIdentifier: String { get }
}

extension Reuseable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func dequeueReuseableCell<T: Reuseable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reuseable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

extension UITableView {
    func dequeueReuseableCell<T: Reuseable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: Reuseable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
