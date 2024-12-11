//
//  RidesViewModelProtocol.swift
//  challenge
//
//  Created by Wagner Sales
//

import Foundation

protocol RidesViewModelProtocol {
    var state: RidesState { get }
    var didChangeState: ((RidesState) -> Void)? { get set }

    func didTapReload()
    func pullToRefresh()
    func viewDidLoad()

    func numberOfRidesRows() -> Int
    func ridesRow(at index: Int) -> RidesRow?

    func numberOfDrivesRows() -> Int
    func driversRow(at index: Int) -> DriversRow?
    func didSelectDriver(index: Int)
}
