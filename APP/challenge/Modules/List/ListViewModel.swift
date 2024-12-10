//
//  ListViewModel.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

enum ListState {
    case idle
    case loading
    case success([ListRow])
    case failure(WASFeedbackViewDTO)
}

final class ListViewModel {
    // MARK: Properties

    private(set) var state: ListState = .idle {
        didSet {
            self.didChangeState?(state)
        }
    }

    var didChangeState: ((ListState) -> Void)?

    private var api: APIClient
    private var customerId: String
    private var driverId: String

    // MARK: Inits

    init(api: APIClient = DependencyContainer.apiClient, customerId: String, driverId: String) {
        self.api = api
        self.customerId = customerId
        self.driverId = driverId
    }

    // MARK: Private Methods

    private func requestList() {
        state = .loading
        api.rides(.init(customerId: customerId, driverId: driverId)) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.rides.isEmpty {
                        self?.state = .failure(.init(
                            title: "Nenhum resultado encontrado!",
                            actionButtonTitle: "Tentar novamente",
                            action: { [weak self] in
                            self?.didTapReload()
                        }))
                    } else {
                        self?.state = .success(response.rides.toRows)
                    }
                }

            case .failure:
                DispatchQueue.main.async {
                    self?.state = .failure(.init(
                        title: "Ocorreu um erro, tente novamente!",
                        actionButtonTitle: "Tentar novamente",
                        action: { [weak self] in
                        self?.didTapReload()
                    }))
                }
            }
        }
    }
}

// MARK: - ListInputProtocol

extension ListViewModel: ListViewModelProtocol {
    func numberOfRows() -> Int {
        guard case .success(let rows) = state else { return 0 }
        return rows.count
    }

    func row(at index: Int) -> ListRow? {
        guard case .success(let rows) = state else { return nil }
        return rows[index]
    }

    func didTapReload() {
        requestList()
    }

    func pullToRefresh() {
        requestList()
    }

    func viewDidLoad() {
        requestList()
    }
}

// MARK: - ListResponse Helper

private extension Array where Element == RideResponse {
    var toRows: [ListRow] {
        var rows: [ListRow] = []
        forEach {
            rows.append(.init(
                driver: $0.driver.name,
                date: $0.date.toDateFormatted ?? "-",
                origin: $0.origin,
                destination: $0.destination,
                duration: $0.duration,
                distance: $0.distance.toKM,
                value: $0.value.toBRL
            ))
        }

        return rows
    }
}
