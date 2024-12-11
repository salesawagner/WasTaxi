//
//  EstimateViewController.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit
import API

final class EstimateViewController: WASViewController {
    // MARK: Properties

    var viewModel: EstimateViewModelProtocol

    let userLabel = UILabel()
    let userTextField = TextFields.primary(placeholder: "insert_user".localized)
    let originLabel = UILabel()
    let originTextField = TextFields.primary(placeholder: "insert_address".localized)
    let destinationLabel = UILabel()
    let destinationTextField = TextFields.primary(placeholder: "insert_address".localized)
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

    override func showLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        actionButton.setNeedsUpdateConfiguration()
    }

    override func setupUI() {
        super.setupUI()
        title = "search_driver".localized
        setupLabels()
        setupTextFields()
        setupStackView()
        setupActionButton()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Setups

    private func setupLabels() {
        userLabel.configure(text: "search_driver".localized, font: Typography.headline, textColor: Colors.onBackground)
        originLabel.configure(text: "which_origin".localized, font: Typography.headline, textColor: Colors.onBackground)
        destinationLabel.configure(
            text: "which_destination".localized,
            font: Typography.headline,
            textColor: Colors.onBackground
        )

        errorLabel.configure(font: Typography.body, textColor: Colors.error)
        errorLabel.isHidden = true
        errorLabel.textAlignment = .center
    }

    private func setupTextFields() {
        configureTextField(userTextField, action: #selector(userChanged))
        configureTextField(originTextField, action: #selector(originChanged))
        configureTextField(destinationTextField, action: #selector(destinationChanged))
    }

    private func setupStackView() {
        let userStackView = createFieldStackView(label: userLabel, textfield: userTextField)
        let originStackView = createFieldStackView(label: originLabel, textfield: originTextField)
        let destinationStackView = createFieldStackView(label: destinationLabel, textfield: destinationTextField)

        let mainStackView = createStackView(
            arrangedSubviews: [userStackView, originStackView, destinationStackView, errorLabel],
            spacing: Spacing.extraLarge,
            axis: .vertical
        )
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
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
                configuration?.title = "continue_button".localized
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

    private func configureTextField(_ textField: UITextField, action: Selector) {
        textField.delegate = self
        textField.addTarget(self, action: action, for: .editingChanged)
    }

    private func createStackView(
        arrangedSubviews: [UIView],
        spacing: CGFloat,
        axis: NSLayoutConstraint.Axis)
    -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = spacing
        stackView.axis = axis

        return stackView
    }

    private func createFieldStackView(label: UILabel, textfield: UITextField) -> UIStackView {
        createStackView(arrangedSubviews: [label, textfield], spacing: Spacing.medium, axis: .vertical)
    }

    @objc private func keyboardWillShow(notification: Notification) {
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

    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = -Spacing.large
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func enableActionButton() {
        let isEnabled = [viewModel.customerId, viewModel.origin, viewModel.destination].allSatisfy { $0 != nil }
        actionButton.isEnabled = isEnabled
    }

    private func showError(_ isShowing: Bool) {
        errorLabel.isHidden = !isShowing
    }

    private func handleIdleState() {
        showLoading(false)
        showError(false)
    }

    private func handleLoadingState() {
        showLoading(true)
        showError(false)
    }

    private func handleSuccessState(_ estimate: EstimateResponse) {
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
    }

    private func handleErrorState(_ text: String) {
        showLoading(false)
        showError(true)
        errorLabel.text = text
    }

    // MARK: Internal Methods

    @objc func userChanged() {
        enableActionButton()
        viewModel.setCustomId(userTextField.text)
    }

    @objc func originChanged() {
        enableActionButton()
        viewModel.setOrigin(originTextField.text)
    }

    @objc func destinationChanged() {
        enableActionButton()
        viewModel.setDestination(destinationTextField.text)
    }

    @objc func didTapActionButton() {
        viewModel.didTapActionButton()
        view.endEditing(true)
    }

    func handleStateChange(_ state: EstimateState) {
        switch state {
        case .idle: handleIdleState()
        case .loading: handleLoadingState()
        case .success(let estimate): handleSuccessState(estimate)
        case .failure(let error): handleErrorState(error)
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
