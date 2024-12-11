//
//  UILabelExtensions.swift
//  challenge
//
//  Created by Wagner Sales on 10/12/24.
//

import UIKit

extension UILabel {
    func configure(text: String = "", font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
