//
//  ConfirmViewModelSpy.swift
//  challenge
//
//  Created by Wagner Sales
//

import API
@testable import challenge

final class ConfirmViewModelSpy: ConfirmViewModelProtocol {
    var receivedMessages: [Message] = []

    private(set) var state: challenge.ConfirmState = .idle
    var didChangeState: ((challenge.ConfirmState) -> Void)?
    var estimate: EstimateResponse = .mock

    func didSelectDriver(index: Int) {
        receivedMessages.append(.didSelectDriver)
    }

    func numberOfRows() -> Int {
        receivedMessages.append(.numberOfRows)
        return 0
    }

    func row(at index: Int) -> challenge.ConfirmRow? {
        receivedMessages.append(.row)
        return nil
    }
}

extension ConfirmViewModelSpy {
    enum Message {
        case didSelectDriver
        case row
        case numberOfRows
    }
}
