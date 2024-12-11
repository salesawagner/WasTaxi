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

    func numberOfRows() -> Int
    func row(at index: Int) -> RidesRow?
    func didTapReload()
    func pullToRefresh()
    func viewDidLoad()
}
