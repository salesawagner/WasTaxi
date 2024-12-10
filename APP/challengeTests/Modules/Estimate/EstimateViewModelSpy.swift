//
//  EstimateViewModelSpy.swift
//  challenge
//
//  Created by Wagner Sales
//

import API
@testable import challenge

final class EstimateViewModelSpy: EstimateViewModelProtocol {
    var receivedMessages: [Message] = []

    private(set) var state: challenge.EstimateState = .idle
    var didChangeState: ((challenge.EstimateState) -> Void)?

    var customerId: String = ""
    var origin: String = ""
    var destination: String = ""
    var response: EstimateResponse?

    func didTapActionButton() {
        receivedMessages.append(.didTapActionButton)
    }
}

extension EstimateViewModelSpy {
    enum Message {
        case didTapActionButton
    }
}
