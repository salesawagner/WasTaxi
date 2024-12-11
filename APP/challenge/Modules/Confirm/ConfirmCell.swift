//
//  ConfirmCell.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

final class ConfirmCell: UITableViewCell {
    static var identifier = String(describing: ConfirmCell.self)

    // MARK: Properties

    private let driverLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let vehicleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let valueLabel = UILabel()
    private let actionButton = Buttons.primary()
    private var buttonAction: (() -> Void)?

    // MARK: Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Methods

    private func setupUI() {
        setupLabels()
        setupActionButton()
        setupStackView()
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    private func setupLabels() {
        driverLabel.configure(font: Typography.headline, textColor: Colors.onBackground)
        descriptionLabel.configure(font: Typography.callout, textColor: Colors.placeholder, numberOfLines: 0)
        vehicleLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        ratingLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        valueLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
    }

    private func setupActionButton() {
        actionButton.configuration?.title = "select".localized
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    private func setupStackView() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.small
        stack.addArrangedSubview(driverLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(ratingLabel)
        stack.addArrangedSubview(vehicleLabel)
        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(actionButton)

        stack.fill(on: contentView, insets: .all(constant: Spacing.large))
    }

    // MARK: Internal Methods

    func setup(with viewModel: ConfirmRow, action: @escaping () -> Void) {
        driverLabel.text = viewModel.driver
        descriptionLabel.text = viewModel.description
        vehicleLabel.text = "🚘 \(viewModel.vehicle)"
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        valueLabel.text = "💲 \(viewModel.value)"
        buttonAction = action
    }

    @objc func didTapActionButton() {
        buttonAction?()
    }
}
