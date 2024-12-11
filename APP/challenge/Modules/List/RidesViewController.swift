//
//  RidesViewController.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

final class RidesViewController: WASViewController {
    // MARK: Properties

    private var viewModel: RidesViewModelProtocol
    let refreshControl = UIRefreshControl()
    let tableView = UITableView(frame: .zero, style: .plain)

    let pickerContainerView = UIView()
    let pickerView = UIPickerView()
    let pickerViewButton = UIButton(type: .system)
    var isShowingPickerView: Bool = false
    var pickerViewSelected = 0
    weak var pickerViewBottomConstraint: NSLayoutConstraint?

    // MARK: Constructors

    init(viewModel: RidesViewModelProtocol) {
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

        viewModel.didChangeState = { [weak self] state in
            self?.handleStateChange(state)
        }

        viewModel.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        title = "history".localized
        addBackButton()
        addFilterButton()
        setupRefreshControl()
        setupTableView()

        setupPickerContainerView()
        setupPickerViewButton()
        setupPickerView()
        setupConstraints()
    }

    override func showLoading(_ isLoading: Bool) {
        super.showLoading(isLoading)
        if !isLoading {
            refreshControl.endRefreshing()
        }
    }

    // MARK: Private Methods

    private func addFilterButton() {
        let button = UIButton(type: .custom)
        let image = UIImage(resource: .filter).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Colors.onSurface
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        tableView.dataSource = self
        tableView.register(RidesCell.self, forCellReuseIdentifier: RidesCell.identifier)

        tableView.fill(on: view)
    }

    private func setupPickerContainerView() {
        pickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        pickerContainerView.backgroundColor = Colors.surface
        pickerContainerView.layer.shadowColor = UIColor.black.cgColor
        pickerContainerView.layer.shadowOpacity = 0.3
        pickerContainerView.layer.shadowOffset = CGSize(width: 0, height: -3)
        pickerContainerView.layer.shadowRadius = 3
        pickerContainerView.layer.masksToBounds = false
        pickerContainerView.layer.cornerRadius = 20
        pickerContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(pickerContainerView)
    }

    private func setupPickerViewButton() {
        pickerViewButton.translatesAutoresizingMaskIntoConstraints = false
        pickerViewButton.setTitle("select".localized, for: .normal)
        pickerViewButton.setTitleColor(Colors.primary, for: .normal)
        pickerViewButton.addTarget(self, action: #selector(didSelectPickerView), for: .touchUpInside)
        pickerContainerView.addSubview(pickerViewButton)
    }

    private func setupPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .clear
        pickerContainerView.addSubview(pickerView)
    }

    private func setupConstraints() {
        let constraint = pickerContainerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        pickerViewBottomConstraint = constraint
        NSLayoutConstraint.activate([
            pickerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            constraint
        ])

        NSLayoutConstraint.activate([
            pickerViewButton.topAnchor.constraint(equalTo: pickerContainerView.topAnchor, constant: Spacing.small),
            pickerViewButton.trailingAnchor.constraint(
                equalTo: pickerContainerView.trailingAnchor,
                constant: -Spacing.small
            ),
            pickerViewButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: pickerViewButton.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    private func handleIdleState() {
        showLoading(false)
        tableView.isHidden = false
    }

    private func handleLoadingState() {
        showLoading(true)
        showFeedbackView(false)
        tableView.isHidden = true
    }

    private func handleSuccessState() {
        showLoading(false)
        showFeedbackView(false)
        tableView.isHidden = false
        tableView.reloadData()
    }

    private func handleErrorState(_ dto: WASFeedbackViewDTO) {
        showLoading(false)
        showFeedbackView(true)
        tableView.isHidden = true
        feedbackView.configure(dto)
    }

    // MARK: Internal Methods

    func handleStateChange(_ state: RidesState) {
        switch state {
        case .idle: handleIdleState()
        case .loading: handleLoadingState()
        case .success: handleSuccessState()
        case .failure(let dto): handleErrorState(dto)
        }
    }

    func didTapReload() {
        viewModel.didTapReload()
    }

    @objc func pullToRefresh() {
        viewModel.pullToRefresh()
    }

    @objc func filterButtonTapped() {
        showPickerView(!isShowingPickerView)
    }

    @objc func showPickerView(_ isShowing: Bool) {
        isShowingPickerView = isShowing
        if isShowing {
            pickerViewBottomConstraint?.isActive = false
            pickerViewBottomConstraint = pickerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            pickerViewBottomConstraint?.isActive = true
        } else {
            pickerViewBottomConstraint?.isActive = false
            pickerViewBottomConstraint = pickerContainerView.topAnchor.constraint(equalTo: view.bottomAnchor)
            pickerViewBottomConstraint?.isActive = true
        }

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc func didSelectPickerView() {
        showPickerView(false)
        title = viewModel.driversRow(at: pickerViewSelected)?.name ?? ""
        viewModel.didSelectDriver(index: pickerViewSelected)
    }
}

// MARK: - UIPickerViewDataSource

extension RidesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfDrivesRows()
    }
}

// MARK: - UIPickerViewDelegate

extension RidesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.driversRow(at: row)?.name ?? ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewSelected = row
    }
}

// MARK: - UITableViewDataSource

extension RidesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRidesRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RidesCell.identifier) as? RidesCell
        if let row = viewModel.ridesRow(at: indexPath.row) {
            cell?.setup(with: row)
        }

        return cell ?? UITableViewCell()
    }
}
