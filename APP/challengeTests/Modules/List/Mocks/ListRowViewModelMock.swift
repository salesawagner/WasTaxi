//
//  ListRowViewModelMock.swift
//  challengeTests
//
//  Created by Wagner Sales
//

@testable import challenge

extension ListRow {
    static var mock: ListRow {
        .init(driver: "", date: "", origin: "", destination: "", duration: "", distance: "", value: "")
    }
}

extension Array where Element == ListRow {
    static var mock: [ListRow] {
        [.mock]
    }
}
