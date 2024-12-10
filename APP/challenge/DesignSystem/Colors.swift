//
//  AppColors.swift
//  challenge
//
//  Created by Wagner Sales on 10/12/24.
//

import UIKit

struct Colors {
    static let primary = UIColor(named: "PrimaryColor") ?? UIColor.systemBlue
    static let secondary = UIColor(named: "SecondaryColor") ?? UIColor.systemTeal
    static let background = UIColor(named: "BackgroundColor") ?? UIColor.systemBackground
    static let surface = UIColor(named: "SurfaceColor") ?? UIColor.white
    static let error = UIColor(named: "ErrorColor") ?? UIColor.systemRed

    static let onPrimary = UIColor(named: "OnPrimaryColor") ?? UIColor.white
    static let onSecondary = UIColor(named: "OnSecondaryColor") ?? UIColor.black
    static let onBackground = UIColor(named: "OnBackgroundColor") ?? UIColor.label
    static let onSurface = UIColor(named: "OnSurfaceColor") ?? UIColor.label

    static let placeholder = UIColor(named: "PlaceholderColor") ?? UIColor(white: 0.74, alpha: 1.0)

    static func withOpacity(color: UIColor, opacity: CGFloat) -> UIColor {
        return color.withAlphaComponent(opacity)
    }
}
