//
//  WASErrorView.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

struct WASFeedbackViewDTO {
    let title: String
    let actionButtonTitle: String
    let action: () -> Void
}

final class WASFeedbackView: UIView {
    // MARK: Private Properties

    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let actionButton = UIButton(type: .system)
    private var action: (() -> Void)?

    // MARK: Inits

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: Private Methods

    private func setupUI() {
        setupTitleLabel()
        setupImageView()
        setupActionButton()
        setupStackView()
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }

    private func setupImageView() {
        imageView.image = .init(named: "error-found")
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupActionButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor.systemPink
        configuration.cornerStyle = .medium

        actionButton.configuration = configuration
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(actionButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    func configure(_ dto: WASFeedbackViewDTO) {
        action = dto.action
        titleLabel.text = dto.title
        actionButton.setTitle(dto.actionButtonTitle, for: .normal)
    }

    @objc
    private func didTapActionButton() {
        action?()
    }
}
