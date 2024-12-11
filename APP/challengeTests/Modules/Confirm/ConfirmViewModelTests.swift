//
//  ConfirmViewModelTests.swift
//  challengeTests
//
//  Created by Wagner Sales
//

import XCTest
import API
@testable import challenge

final class ConfirmViewModelTests: XCTestCase {
    var viewModel: ConfirmViewModelProtocol!
    var mockService: WASAPIMock!

    override func setUp() {
        super.setUp()
        mockService = WASAPIMock()
        viewModel = ConfirmViewModel(api: mockService, origin: "", destination: "", estimate: .mock, customerId: "")
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testDidTapActionButton_CallsServiceAndUpdatesState() {
        let expectation = XCTestExpectation(description: "State changes to success")
        viewModel.didChangeState = { state in
            if case .success(let customerId) = state {
                XCTAssertNotNil(customerId)
                expectation.fulfill()
            }
        }

        viewModel.didSelectDriver(index: 0)
        wait(for: [expectation], timeout: 1.0)
    }

    func testDidTapActionButton_FailureUpdatesState() {
        mockService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "State changes to error")
        viewModel.didChangeState = { state in
            if case .failure(let error) = state {
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        viewModel.didSelectDriver(index: 0)
        wait(for: [expectation], timeout: 1.0)
    }

    func testNumberOfRows_ReturnsCorrectCount() {
        XCTAssertEqual(viewModel.numberOfRows(), 1)
    }

    func testRowAtIndex_ReturnsCorrectRow() {
        let row = viewModel.row(at: 0)
        XCTAssertNotNil(row)
        XCTAssertEqual(row?.driver, "name")
    }
}
