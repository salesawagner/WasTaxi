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
    private let actionButton = UIButton(type: .system)
    private let isLoading: Bool = false
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
        driverLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        driverLabel.textColor = .darkText

        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray

        vehicleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        vehicleLabel.textColor = .darkText

        ratingLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        ratingLabel.textColor = .darkText

        valueLabel.font = UIFont.preferredFont(forTextStyle: .caption1).bold()
        valueLabel.textColor = .darkText
    }

    private func setupActionButton() {
        let title = "Escolher"
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = UIColor.systemPink
        configuration.cornerStyle = .medium

        actionButton.configuration = configuration
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        actionButton.configurationUpdateHandler = { [weak self] button in
            var configuration = button.configuration
            if let self = self, self.isLoading {
                configuration?.title = ""
                configuration?.showsActivityIndicator = true
            } else {
                configuration?.title = title
                configuration?.showsActivityIndicator = false
            }

            button.configuration = configuration
        }

        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupStackView() {
        let rideStackView = UIStackView()
        rideStackView.axis = .vertical
        rideStackView.spacing = 8
        rideStackView.addArrangedSubview(driverLabel)
        rideStackView.addArrangedSubview(descriptionLabel)
        rideStackView.addArrangedSubview(ratingLabel)
        rideStackView.addArrangedSubview(vehicleLabel)
        rideStackView.addArrangedSubview(valueLabel)
        rideStackView.addArrangedSubview(UIView())
        rideStackView.addArrangedSubview(actionButton)

        rideStackView.fill(on: contentView, insets: .all(constant: 24))
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
