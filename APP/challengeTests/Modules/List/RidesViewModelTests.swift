//
//  RidesViewModelTests.swift
//  challengeTests
//
//  Created by Wagner Sales
//

import XCTest
import API
@testable import challenge

final class RidesViewModelTests: XCTestCase {
    var viewModel: RidesViewModelProtocol!
    var mockService: WASAPIMock!

    override func setUp() {
        super.setUp()
        mockService = WASAPIMock()
        viewModel = RidesViewModel(api: mockService, customerId: "")
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsServiceAndUpdatesState() {
        let expectation = XCTestExpectation(description: "State changes to success with rows")
        viewModel.didChangeState = { state in
            if case .success(let rows) = state {
                XCTAssertEqual(rows.count, 1)
                XCTAssertEqual(rows.first?.origin, "origin")
                expectation.fulfill()
            }
        }

        viewModel.viewDidLoad()

        wait(for: [expectation], timeout: 1.0)
    }

    func testDidTapReload_CallsServiceAndReloadsData() {
        let expectation = XCTestExpectation(description: "State changes to success with rows")
        viewModel.didChangeState = { state in
            if case .success(let rows) = state {
                XCTAssertEqual(rows.count, 1)
                XCTAssertEqual(rows.first?.origin, "origin")
                expectation.fulfill()
            }
        }

        viewModel.didTapReload()

        wait(for: [expectation], timeout: 1.0)
    }

    func testPullToRefresh_UpdatesState() {
        let expectation = XCTestExpectation(description: "State changes to success with rows")
        viewModel.didChangeState = { state in
            if case .success(let rows) = state {
                XCTAssertEqual(rows.count, 1)
                XCTAssertEqual(rows.first?.origin, "origin")
                expectation.fulfill()
            }
        }

        viewModel.pullToRefresh()

        wait(for: [expectation], timeout: 1.0)
    }

    func testNumberOfRows_ReturnsCorrectCount() {
        let expectation = XCTestExpectation(description: "State changes to success with rows")
        viewModel.didChangeState = { state in
            if case .success = state {
                expectation.fulfill()
            }
        }

        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.numberOfRidesRows(), 1)
    }

    func testRowAtIndex_ReturnsCorrectRow() {
        let expectation = XCTestExpectation(description: "State changes to success with rows")
        viewModel.didChangeState = { state in
            if case .success = state {
                expectation.fulfill()
            }
        }

        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        let row = viewModel.ridesRow(at: 0)
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.origin, "origin")
    }

    func testViewDidSelectDriver_CallsServiceAndUpdatesState() {
        let expectation = XCTestExpectation(description: "State changes to success with rows")
        viewModel.didChangeState = { state in
            if case .success(let rows) = state {
                XCTAssertEqual(rows.count, 1)
                XCTAssertEqual(rows.first?.origin, "origin")
                expectation.fulfill()
            }
        }

        viewModel.didSelectDriver(index: 0)

        wait(for: [expectation], timeout: 1.0)
    }

    func testViewDidLoad_FailureUpdatesState() {
        mockService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "State changes to error")
        viewModel.didChangeState = { state in
            if case .failure(let error) = state {
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        viewModel.viewDidLoad()

        wait(for: [expectation], timeout: 1.0)
    }
}
