//
//  RidesViewModel.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

enum RidesState {
    case idle
    case loading
    case success([RidesRow])
    case failure(WASFeedbackViewDTO)
}

final class RidesViewModel {
    // MARK: Properties

    private(set) var state: RidesState = .idle {
        didSet {
            self.didChangeState?(state)
        }
    }

    var didChangeState: ((RidesState) -> Void)?

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
                            title: "no_rides".localized,
                            actionButtonTitle: "try_again".localized,
                            action: { [weak self] in
                            self?.didTapReload()
                        }))
                    } else {
                        self?.state = .success(response.toRows)
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    var title = ""
                    if case .error(let error) = error {
                        title = error.description
                    } else {
                        title = "generic_error".localized
                    }

                    self?.state = .failure(.init(
                        title: title,
                        actionButtonTitle: "try_again".localized,
                        action: { [weak self] in
                        self?.didTapReload()
                    }))
                }
            }
        }
    }
}

// MARK: - ListInputProtocol

extension RidesViewModel: RidesViewModelProtocol {
    func numberOfRows() -> Int {
        guard case .success(let rows) = state else { return 0 }
        return rows.count
    }

    func row(at index: Int) -> RidesRow? {
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

// MARK: - RidesResponse Helper

private extension RidesResponse {
    var toRows: [RidesRow] {
        var rows: [RidesRow] = []
        rides.forEach {
            rows.append(.init(
                customerId: customerId,
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
