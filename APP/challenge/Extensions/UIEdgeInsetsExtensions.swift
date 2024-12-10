//
//  UIEdgeInsetsExtensions.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

extension UIEdgeInsets {
    static func all(constant: CGFloat) -> UIEdgeInsets {
        .init(top: constant, left: constant, bottom: constant, right: constant)
    }
}
