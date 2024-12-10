//
//  ListCell.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

final class ListCell: UITableViewCell {
    static var identifier = String(describing: ListCell.self)

    // MARK: Properties

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
        driverLabel.font = Typography.headline
        driverLabel.textColor = Colors.onBackground

        dateLabel.font = Typography.callout
        dateLabel.textColor = Colors.placeholder

        originLabel.font = Typography.callout
        originLabel.textColor = Colors.onBackground

        destinationLabel.font = Typography.callout
        destinationLabel.textColor = Colors.onBackground

        durationLabel.font = Typography.callout
        durationLabel.textColor = Colors.onBackground

        distanceLabel.font = Typography.callout
        distanceLabel.textColor = Colors.onBackground

        valueLabel.font = Typography.callout
        valueLabel.textColor = Colors.onBackground
    }

    private func setupStackView() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = Spacing.small
        mainStackView.addArrangedSubview(driverLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(durationLabel)
        mainStackView.addArrangedSubview(distanceLabel)
        mainStackView.addArrangedSubview(valueLabel)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(iconStackView(color: Colors.secondary, label: originLabel))
        mainStackView.addArrangedSubview(iconStackView(color: Colors.primary, label: destinationLabel))
        mainStackView.fill(on: contentView, insets: .all(constant: 24))
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

    func setup(with viewModel: ListRow) {
        driverLabel.text = viewModel.driver
        dateLabel.text = viewModel.date
        originLabel.text = viewModel.origin
        destinationLabel.text = viewModel.destination
        durationLabel.text = "🕐 \(viewModel.duration)"
        distanceLabel.text = "🗺️ \(viewModel.distance)"
        valueLabel.text = "💲 \(viewModel.value)"
    }
}
