//
//  EstimateViewModelProtocol.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

protocol EstimateViewModelProtocol: AnyObject {
    var state: EstimateState { get }
    var didChangeState: ((EstimateState) -> Void)? { get set }
    var customerId: String { get }
    var origin: String { get set }
    var destination: String { get set }

    func didTapActionButton()
}
