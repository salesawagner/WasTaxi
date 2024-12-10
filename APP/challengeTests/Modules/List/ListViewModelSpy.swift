//
//  ListViewModelSpy.swift
//  challenge
//
//  Created by Wagner Sales
//

@testable import challenge

final class ListViewModelSpy: ListViewModelProtocol {
    var receivedMessages: [Message] = []

    private(set) var state: challenge.ListState = .idle
    var didChangeState: ((challenge.ListState) -> Void)?
    private var mockRows: [ListRow] = []

    func numberOfRows() -> Int {
        receivedMessages.append(.numberOfRows)
        return 0
    }

    func row(at index: Int) -> challenge.ListRow? {
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
