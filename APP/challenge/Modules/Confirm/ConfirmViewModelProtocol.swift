//
//  ConfirmViewModelProtocol.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

protocol ConfirmViewModelProtocol: AnyObject {
    var state: ConfirmState { get }
    var didChangeState: ((ConfirmState) -> Void)? { get set }
    var estimate: EstimateResponse { get }

    func didSelectDriver(index: Int)
    func numberOfRows() -> Int
    func row(at index: Int) -> ConfirmRow?
}
