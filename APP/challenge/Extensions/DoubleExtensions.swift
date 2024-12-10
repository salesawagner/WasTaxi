//
//  DoubleExtensions.swift
//  challenge
//
//  Created by Wagner Sales
//

import Foundation

extension Double {
    var toBRL: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")

        return formatter.string(from: NSNumber(value: self))?.trimmingCharacters(in: .whitespaces) ?? "0,00"
    }

    var toKM: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        return "\(formatter.string(from: NSNumber(value: self)) ?? "0") km"
    }
}
