//
//  EstimateViewModel.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

enum EstimateState {
    case idle
    case loading
    case success(EstimateResponse)
    case failure(String)
}

final class EstimateViewModel: EstimateViewModelProtocol {
    // MARK: Properties

    private(set) var state: EstimateState = .idle {
        didSet {
            self.didChangeState?(state)
        }
    }

    var didChangeState: ((EstimateState) -> Void)?

    private var api: APIClient

    var customerId: String?
    var origin: String?
    var destination: String?

    // MARK: Inits

    init(api: APIClient = DependencyContainer.apiClient) {
        self.api = api
    }

    // MARK: Private Methods

    private func requestEstimate() {
        state = .loading
        api.estimante(.init(customerId: customerId, origin: origin, destination: destination)) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.drivers.isEmpty {
                        self?.state = .failure("no_driver".localized)
                    } else {
                        self?.state = .success(response)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    if case .error(let error) = error {
                        self?.state = .failure(error.description)
                    } else {
                        self?.state = .failure("generic_error".localized)
                    }
                }
            }
        }
    }

    // MARK: Internal Methods

    func didTapActionButton() {
        requestEstimate()
    }

    func setCustomId(_ text: String?) {
        customerId = (text?.isEmpty ?? true) ? nil : text
    }

    func setOrigin(_ text: String?) {
        origin = (text?.isEmpty ?? true) ? nil : text
    }

    func setDestination(_ text: String?) {
        destination = (text?.isEmpty ?? true) ? nil : text
    }
}
