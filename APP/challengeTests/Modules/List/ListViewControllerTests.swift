//
//  ListViewControllerTests.swift
//  challengeTests
//
//  Created by Wagner Sales
//

import XCTest
@testable import challenge

class ListViewControllerTests: XCTestCase {
    var sut: RidesViewController!
    var spy: ListViewModelSpy!

    override func setUp() {
        super.setUp()
        spy = ListViewModelSpy()
        sut = RidesViewController(viewModel: spy)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsViewModelViewDidLoad() {
        sut.viewDidLoad()
        XCTAssertTrue(spy.receivedMessages.contains(.viewDidLoad))
    }

    func testDidTapReload_CallsViewModelDidTapReload() {
        sut.didTapReload()
        XCTAssertTrue(spy.receivedMessages.contains(.didTapReload))
    }

    func testPullToRefresh_CallsViewModelPullToRefresh() {
        sut.pullToRefresh()
        XCTAssertTrue(spy.receivedMessages.contains(.pullToRefresh))
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
        XCTAssertFalse(sut.tableView.isHidden)
        XCTAssertTrue(sut.feedbackView.isHidden)
    }

    func testHandleStateChange_WhenStateIsLoading() {
        sut.handleStateChange(.loading)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.tableView.isHidden)
        XCTAssertTrue(sut.feedbackView.isHidden)
    }

    func testHandleStateChange_WhenStateIsFailure() {
        sut.handleStateChange(.failure(.init(title: "", actionButtonTitle: "", action: {})))
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.tableView.isHidden)
        XCTAssertFalse(sut.feedbackView.isHidden)
    }

    func testHandleStateChange_WhenStateIsSuccess() {
        sut.handleStateChange(.success([]))
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.tableView.isHidden)
        XCTAssertTrue(sut.feedbackView.isHidden)
    }
}
