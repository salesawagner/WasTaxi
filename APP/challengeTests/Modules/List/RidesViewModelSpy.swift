//
//  RidesViewModelSpy.swift
//  challenge
//
//  Created by Wagner Sales
//

@testable import challenge

final class RidesViewModelSpy: RidesViewModelProtocol {
    var receivedMessages: [Message] = []

    private(set) var state: challenge.RidesState = .idle
    var didChangeState: ((challenge.RidesState) -> Void)?
    private var mockRows: [RidesRow] = []

    func didTapReload() {
        receivedMessages.append(.didTapReload)
    }

    func pullToRefresh() {
        receivedMessages.append(.pullToRefresh)
    }

    func viewDidLoad() {
        receivedMessages.append(.viewDidLoad)
    }

    func numberOfRidesRows() -> Int {
        receivedMessages.append(.numberOfRidesRows)
        return 0
    }

    func ridesRow(at index: Int) -> challenge.RidesRow? {
        receivedMessages.append(.ridesRow)
        return nil
    }

    func numberOfDrivesRows() -> Int {
        receivedMessages.append(.numberOfDriversRows)
        return 0
    }

    func driversRow(at index: Int) -> challenge.DriversRow? {
        receivedMessages.append(.driversRow)
        return nil
    }

    func didSelectDriver(index: Int) {
        receivedMessages.append(.didSelectDriver)
    }
}

extension RidesViewModelSpy {
    enum Message {
        case viewDidLoad
        case pullToRefresh
        case didTapReload
        case ridesRow
        case numberOfRidesRows
        case driversRow
        case numberOfDriversRows
        case didSelectDriver
    }
}
