//
//  ConfirmViewModel.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

enum ConfirmState: Equatable {
    case idle
    case loading
    case success(customerId: String)
    case failure(String)
}

final class ConfirmViewModel: ConfirmViewModelProtocol {
    // MARK: Properties

    private(set) var state: ConfirmState = .idle {
        didSet {
            self.didChangeState?(state)
        }
    }

    var didChangeState: ((ConfirmState) -> Void)?

    private var api: APIClient
    private var origin: String
    private var destination: String
    private(set) var estimate: EstimateResponse
    private var customerId: String

    // MARK: Inits

    init(
        api: APIClient = DependencyContainer.apiClient,
        origin: String?,
        destination: String?,
        estimate: EstimateResponse,
        customerId: String?
    ) {
        self.api = api
        self.origin = origin ?? ""
        self.destination = destination ?? ""
        self.estimate = estimate
        self.customerId = customerId ?? ""
    }

    // MARK: Private Methods

    private func requestConfirm(index: Int) {
        state = .loading
        let driver = estimate.drivers[index]
        api.confirm(.init(
            customerId: customerId,
            origin: origin,
            destination: destination,
            distance: estimate.distance,
            duration: estimate.duration,
            driver: .init(id: "\(driver.id)", name: driver.name),
            value: driver.value ?? 0
        )) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.success {
                        self?.state = .success(customerId: self?.customerId ?? "")
                    } else {
                        self?.state = .failure("generic_error".localized)
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

    private func isDriverEligible(index: Int) -> Bool {
        let estimateDistance = Double(estimate.distance)
        let minimumDistance = Driver.drivers.first { $0.id == estimate.drivers[index].id }?.minimumDistance ?? 0
        return estimateDistance >= minimumDistance
    }

    // MARK: Internal Methods

    func didSelectDriver(index: Int) {
        guard isDriverEligible(index: index) else {
            state = .failure("driver_eligible".localized)
            return
        }

        requestConfirm(index: index)
    }

    func numberOfRows() -> Int {
        estimate.drivers.count
    }

    func row(at index: Int) -> ConfirmRow? {
        let driver = estimate.drivers[index]
        return .init(
            driver: driver.name,
            description: driver.description ?? "",
            vehicle: driver.vehicle ?? "",
            rating: "\(driver.review?.rating ?? 0)",
            value: (driver.value ?? 0).toBRL
        )
    }
}
