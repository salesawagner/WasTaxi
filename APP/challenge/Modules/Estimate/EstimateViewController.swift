//
//  EstimateViewController.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

final class EstimateViewController: WASViewController {
    // MARK: Properties

    var viewModel: EstimateViewModelProtocol

    let originLabel = UILabel()
    let originTextField = TextFields.primary(placeholder: "Insira o endereço")
    let destinationLabel = UILabel()
    let destinationTextField = TextFields.primary(placeholder: "Insira o endereço")
    let errorLabel = UILabel()
    let actionButton = Buttons.primary()
    var isLoading: Bool = false

    weak var bottomConstraint: NSLayoutConstraint?

    // MARK: Constructors

    init(viewModel: EstimateViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        viewModel.didChangeState = { [weak self] state in
            self?.handleStateChange(state)
        }
    }

    override func viewDidAppear(_ animated: Bool) { // FIXME: Remover
        super.viewDidAppear(animated)
        viewModel.origin = "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031"
        viewModel.destination = "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"
        actionButton.isEnabled = true
    }

    override func showLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        actionButton.setNeedsUpdateConfiguration()
    }

    override func setupUI() {
        super.setupUI()
        title = "Buscar Motoristas"
        setupOriginLabel()
        setupOriginTextField()
        setupDestinationLabel()
        setupDestinationTextField()
        setupErrorLabel()
        setupStackView()
        setupActionButton()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Setups

    private func setupOriginLabel() {
        originLabel.text = "Qual Origem?"
        originLabel.textColor = Colors.onBackground
        originLabel.font = Typography.headline
        originLabel.adjustsFontForContentSizeCategory = true
    }

    private func setupOriginTextField() {
        originTextField.delegate = self
        originTextField.addTarget(self, action: #selector(originChanged), for: .editingChanged)
    }

    private func setupDestinationLabel() {
        destinationLabel.text = "Qual Destino?"
        destinationLabel.textColor = Colors.onBackground
        destinationLabel.font = Typography.headline
        destinationLabel.adjustsFontForContentSizeCategory = true
    }

    private func setupDestinationTextField() {
        destinationTextField.delegate = self
        destinationTextField.addTarget(self, action: #selector(destinationChanged), for: .editingChanged)
    }

    private func setupErrorLabel() {
        errorLabel.font = Typography.body
        errorLabel.textColor = Colors.error
        errorLabel.isHidden = true
        errorLabel.textAlignment = .center
    }

    private func setupStackView() {
        let originLabelsStackView = UIStackView()
        originLabelsStackView.axis = .vertical
        originLabelsStackView.spacing = Spacing.medium
        originLabelsStackView.addArrangedSubview(originLabel)
        originLabelsStackView.addArrangedSubview(originTextField)

        let destinationLabelStackView = UIStackView()
        destinationLabelStackView.axis = .vertical
        destinationLabelStackView.spacing = Spacing.medium
        destinationLabelStackView.addArrangedSubview(destinationLabel)
        destinationLabelStackView.addArrangedSubview(destinationTextField)

        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = Spacing.extraLarge
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(originLabelsStackView)
        mainStackView.addArrangedSubview(destinationLabelStackView)
        mainStackView.addArrangedSubview(errorLabel)

        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.large),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large)
        ])
    }

    private func setupActionButton() {
        actionButton.isEnabled = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        actionButton.configurationUpdateHandler = { [weak self] button in
            var configuration = button.configuration
            if let self = self, self.isLoading {
                configuration?.title = ""
                configuration?.showsActivityIndicator = true
            } else {
                configuration?.title = "Continue"
                configuration?.showsActivityIndicator = false
            }

            button.configuration = configuration
        }

        view.addSubview(actionButton)

        let constraint = actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Spacing.large)
        bottomConstraint = constraint
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large),
            constraint
        ])
    }

    // MARK: Private Methods

    @objc func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        bottomConstraint?.constant = -(keyboardHeight + Spacing.large)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = -Spacing.large
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func originChanged() {
        enableActionButton()
        viewModel.origin = originTextField.text ?? ""
    }

    @objc private func destinationChanged() {
        enableActionButton()
        viewModel.destination = destinationTextField.text ?? ""
    }

    private func enableActionButton() {
        actionButton.isEnabled = originTextField.text?.isEmpty == false && destinationTextField.text?.isEmpty == false
    }

    private func showError(_ isShowing: Bool) {
        errorLabel.isHidden = !isShowing
    }

    // MARK: Internal Methods

    @objc func didTapActionButton() {
        viewModel.didTapActionButton()
        view.endEditing(true)
    }

    func handleStateChange(_ state: EstimateState) {
        switch state {
        case .idle:
            showLoading(false)
            showError(false)

        case .loading:
            showLoading(true)
            showError(false)

        case .success(let estimate):
            showLoading(false)
            showError(false)
            let viewModel = ConfirmViewModel(
                origin: viewModel.origin,
                destination: viewModel.destination,
                estimate: estimate,
                customerId: viewModel.customerId
            )
            let viewController = ConfirmViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)

        case .failure(let error):
            showLoading(false)
            errorLabel.text = error
            showError(true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension EstimateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
