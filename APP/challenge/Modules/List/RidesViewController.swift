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
        setupRefreshControl()
        setupTableView()
    }

    override func showLoading(_ isLoading: Bool) {
        super.showLoading(isLoading)
        if !isLoading {
            refreshControl.endRefreshing()
        }
    }

    // MARK: Private Methods

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
}

// MARK: - UITableViewDataSource

extension RidesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RidesCell.identifier) as? RidesCell
        if let row = viewModel.row(at: indexPath.row) {
            cell?.setup(with: row)
        }

        return cell ?? UITableViewCell()
    }
}
