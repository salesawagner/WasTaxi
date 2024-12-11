//
//  ListViewModelSpy.swift
//  challenge
//
//  Created by Wagner Sales
//

@testable import challenge

final class ListViewModelSpy: RidesViewModelProtocol {
    var receivedMessages: [Message] = []

    private(set) var state: challenge.RidesState = .idle
    var didChangeState: ((challenge.RidesState) -> Void)?
    private var mockRows: [RidesRow] = []

    func numberOfRows() -> Int {
        receivedMessages.append(.numberOfRows)
        return 0
    }

    func row(at index: Int) -> challenge.RidesRow? {
        receivedMessages.append(.row)
        return nil
    }

    func didTapReload() {
        receivedMessages.append(.didTapReload)
    }

    func pullToRefresh() {
        receivedMessages.append(.pullToRefresh)
    }

    func viewDidLoad() {
        receivedMessages.append(.viewDidLoad)
    }
}

extension ListViewModelSpy {
    enum Message {
        case viewDidLoad
        case pullToRefresh
        case didTapReload
        case row
        case numberOfRows
    }
}
