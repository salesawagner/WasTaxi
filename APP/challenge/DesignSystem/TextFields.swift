//
//  TextFields.swift
//  challenge
//
//  Created by Wagner Sales on 10/12/24.
//

import UIKit

struct TextFields {
    static func primary(placeholder: String) -> UITextField {
        let textField = UITextField()

        textField.font = Typography.body
        textField.backgroundColor = .clear
        textField.textColor = Colors.onBackground

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: Colors.placeholder]
        )

        return textField
    }
}
