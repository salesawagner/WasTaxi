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
    var customerId: String? { get }
    var origin: String? { get }
    var destination: String? { get }

    func didTapActionButton()
    func setCustomId(_ text: String?)
    func setOrigin(_ text: String?)
    func setDestination(_ text: String?)
}
