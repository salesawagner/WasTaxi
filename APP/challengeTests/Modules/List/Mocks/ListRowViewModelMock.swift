//
//  ListRowViewModelMock.swift
//  challengeTests
//
//  Created by Wagner Sales
//

@testable import challenge

extension RidesRow {
    static var mock: RidesRow {
        .init(
            customerId: "",
            driver: "",
            date: "",
            origin: "",
            destination: "",
            duration: "",
            distance: "",
            value: ""
        )
    }
}

extension Array where Element == RidesRow {
    static var mock: [RidesRow] {
        [.mock]
    }
}
