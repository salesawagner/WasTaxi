//
//  APITests.swift
//  APITests
//
//  Created by Wagner Sales
//

import XCTest
import API

final class APITests: XCTestCase {
    func test_estimate() throws {
        let expectation = XCTestExpectation(description: "test_estimate")
        let api = WASAPI(environment: Environment.local)
        api.estimante(.init(customerId: "", origin: "", destination: "")) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.origin.latitude, -23.5215624)
                XCTAssertEqual(response.origin.longitude, -46.763286699999995)
                XCTAssertEqual(response.destination.latitude, -23.5615351)
                XCTAssertEqual(response.destination.longitude, -46.6562816)
                XCTAssertEqual(response.distance, 20018)
                XCTAssertEqual(response.duration, 1920)
                XCTAssertEqual(response.drivers.count, 3)
                XCTAssertFalse(response.routeResponse?.encodedPolylines.isEmpty ?? true)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_confirm() throws {
        let expectation = XCTestExpectation(description: "test_confirm")
        let api = WASAPI(environment: Environment.local)
        api.confirm(.init(
            customerId: "",
            origin: "",
            destination: "",
            distance: 0,
            duration: 0,
            driver: .init(id: "", name: ""),
            value: 0
        )) { result in
            switch result {
            case .success(let response):
                XCTAssertTrue(response.success)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_rides() throws {
        let expectation = XCTestExpectation(description: "test_rides")
        let api = WASAPI(environment: Environment.local)
        api.rides(.init(customerId: "")) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.rides.count, 1)

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
