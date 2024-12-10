//
//  EstimateViewModelTests.swift
//  challengeTests
//
//  Created by Wagner Sales
//

import XCTest
import API
@testable import challenge

final class EstimateViewModelTests: XCTestCase {
    var viewModel: EstimateViewModelProtocol!
    var mockService: WASAPIMock!

    override func setUp() {
        super.setUp()
        mockService = WASAPIMock()
        viewModel = EstimateViewModel(api: mockService, customerId: "")
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testDidTapActionButton_CallsServiceAndUpdatesState() {
        let expectation = XCTestExpectation(description: "State changes to success")
        viewModel.didChangeState = { state in
            if case .success(let estimate) = state {
                XCTAssertNotNil(estimate)
                expectation.fulfill()
            }
        }

        viewModel.didTapActionButton()
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

        viewModel.didTapActionButton()
        wait(for: [expectation], timeout: 1.0)
    }
}
