//
//  RidesCell.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

final class RidesCell: UITableViewCell {
    static var identifier = String(describing: RidesCell.self)

    // MARK: Properties

    private let userLabel = UILabel()
    private let driverLabel = UILabel()
    private let dateLabel = UILabel()
    private let originLabel = UILabel()
    private let destinationLabel = UILabel()
    private let durationLabel = UILabel()
    private let distanceLabel = UILabel()
    private let valueLabel = UILabel()

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
        setupStackView()
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    private func setupLabels() {
        userLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        driverLabel.configure(font: Typography.headline, textColor: Colors.onBackground)
        dateLabel.configure(font: Typography.callout, textColor: Colors.placeholder)
        originLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        destinationLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        durationLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        distanceLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
        valueLabel.configure(font: Typography.callout, textColor: Colors.onBackground)
    }

    private func setupStackView() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spacing.small
        stack.addArrangedSubview(driverLabel)
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(userLabel)
        stack.addArrangedSubview(durationLabel)
        stack.addArrangedSubview(distanceLabel)
        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(iconStackView(color: Colors.secondary, label: originLabel))
        stack.addArrangedSubview(iconStackView(color: Colors.primary, label: destinationLabel))
        stack.fill(on: contentView, insets: .all(constant: Spacing.large))
    }

    private func iconStackView(color: UIColor, label: UILabel) -> UIStackView {
        let viewSize = 5.0
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = viewSize / 2
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: viewSize),
            view.heightAnchor.constraint(equalToConstant: viewSize)
        ])

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Spacing.extraSmall
        stackView.alignment = .center
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(label)

        return stackView
    }

    // MARK: Internal Methods

    func setup(with viewModel: RidesRow) {
        driverLabel.text = viewModel.driver
        dateLabel.text = viewModel.date
        originLabel.text = viewModel.origin
        destinationLabel.text = viewModel.destination
        userLabel.text = "🧑‍🦱 \(viewModel.customerId)"
        durationLabel.text = "🕐 \(viewModel.duration)"
        distanceLabel.text = "🗺️ \(viewModel.distance)"
        valueLabel.text = "💲 \(viewModel.value)"
    }
}
