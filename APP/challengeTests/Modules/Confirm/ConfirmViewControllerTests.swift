//
//  ConfirmViewControllerTests.swift
//  challengeTests
//
//  Created by Wagner Sales
//

import XCTest
@testable import challenge

class ConfirmViewControllerTests: XCTestCase {
    var sut: ConfirmViewController!
    var spy: ConfirmViewModelSpy!

    override func setUp() {
        super.setUp()
        spy = ConfirmViewModelSpy()
        sut = ConfirmViewController(viewModel: spy)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsViewModelViewDidLoad() {
        sut.didSelectDriver(index: 0)
        XCTAssertTrue(spy.receivedMessages.contains(.didSelectDriver))
    }

    func testNumberOfRows_CallsViewModelNumberOfRows() {
        _ = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertTrue(spy.receivedMessages.contains(.numberOfRows))
    }

    func testRowAt_CallsViewModelRowAt() {
        _ = sut.tableView(UITableView(), cellForRowAt: .init(row: 0, section: 0))
        XCTAssertTrue(spy.receivedMessages.contains(.row))
    }

    func testHandleStateChange_WhenStateIsIdle() {
        sut.handleStateChange(.idle)
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.contentView.isHidden)
    }

    func testHandleStateChange_WhenStateIsLoading() {
        sut.handleStateChange(.loading)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.contentView.isHidden)
    }

    func testHandleStateChange_WhenStateIsFailure() {
        sut.handleStateChange(.failure(""))
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.contentView.isHidden)
    }

    func testHandleStateChange_WhenStateIsSuccess() {
        sut.handleStateChange(.success(customerId: "", driverId: ""))
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.contentView.isHidden)
    }
}
