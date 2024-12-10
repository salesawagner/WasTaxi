//
//  Button.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

struct Buttons {
    static func primary() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = Colors.primary
        configuration.cornerStyle = .medium
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = Typography.body
            return outgoing
        }

        let button = UIButton(type: .system)
        button.configuration = configuration

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48)
        ])

        return button
    }
}
