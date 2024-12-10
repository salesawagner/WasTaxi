//
//  EstimateViewControllerTests.swift
//  challengeTests
//
//  Created by Wagner Sales
//

import XCTest
@testable import challenge

class EstimateViewControllerTests: XCTestCase {
    var sut: EstimateViewController!
    var spy: EstimateViewModelSpy!

    override func setUp() {
        super.setUp()
        spy = EstimateViewModelSpy()
        sut = EstimateViewController(viewModel: spy)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }

    func testViewDidTapActionButton_CallsViewModelDidTapActionButton() {
        sut.didTapActionButton()
        XCTAssertTrue(spy.receivedMessages.contains(.didTapActionButton))
    }

    func testHandleStateChange_WhenStateIsIdle() {
        sut.handleStateChange(.idle)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.errorLabel.isHidden)
    }

    func testHandleStateChange_WhenStateIsLoading() {
        sut.handleStateChange(.loading)
        XCTAssertTrue(sut.isLoading)
        XCTAssertTrue(sut.errorLabel.isHidden)
    }

    func testHandleStateChange_WhenStateIsFailure() {
        let error = "TestError"
        sut.handleStateChange(.failure(error))
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, error)
    }

    func testHandleStateChange_WhenStateIsSuccess() {
        sut.handleStateChange(.success(.mock))
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.errorLabel.isHidden)
    }
}
