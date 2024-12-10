//
//  ListViewController.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

final class ListViewController: WASViewController {
    // MARK: Properties

    private var viewModel: ListViewModelProtocol
    let refreshControl = UIRefreshControl()
    let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: Constructors

    init(viewModel: ListViewModelProtocol) {
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
        title = "Histórico"
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
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)

        tableView.fill(on: view)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    // MARK: Internal Methods

    func handleStateChange(_ state: ListState) {
        switch state {
        case .idle:
            showLoading(false)
            tableView.isHidden = false

        case .loading:
            showLoading(true)
            showFeedbackView(false)
            tableView.isHidden = true

        case .success:
            showLoading(false)
            showFeedbackView(false)
            tableView.isHidden = false
            tableView.reloadData()

        case .failure(let dto):
            showLoading(false)
            showFeedbackView(true)
            tableView.isHidden = true
            feedbackView.configure(dto)
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

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier) as? ListCell
        if let row = viewModel.row(at: indexPath.row) {
            cell?.setup(with: row)
        }

        return cell ?? UITableViewCell()
    }
}
