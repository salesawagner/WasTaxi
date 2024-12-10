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
        driverLabel.font = Typography.headline
        driverLabel.textColor = Colors.onBackground

        descriptionLabel.font = Typography.callout
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Colors.placeholder

        vehicleLabel.font = Typography.callout
        vehicleLabel.textColor = Colors.onBackground

        ratingLabel.font = Typography.callout
        ratingLabel.textColor = Colors.onBackground

        valueLabel.font = Typography.callout
        valueLabel.textColor = Colors.onBackground
    }

    private func setupActionButton() {
        actionButton.configuration?.title = "Escolher"
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    private func setupStackView() {
        let rideStackView = UIStackView()
        rideStackView.axis = .vertical
        rideStackView.spacing = Spacing.small
        rideStackView.addArrangedSubview(driverLabel)
        rideStackView.addArrangedSubview(descriptionLabel)
        rideStackView.addArrangedSubview(ratingLabel)
        rideStackView.addArrangedSubview(vehicleLabel)
        rideStackView.addArrangedSubview(valueLabel)
        rideStackView.addArrangedSubview(UIView())
        rideStackView.addArrangedSubview(actionButton)

        rideStackView.fill(on: contentView, insets: .all(constant: Spacing.large))
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
