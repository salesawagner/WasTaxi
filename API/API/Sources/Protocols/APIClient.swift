//
//  APIClient.swift
//  API
//
//  Created by Wagner Sales
//

import Foundation

public typealias ResultCallback<Value> = (Result<Value, APIError>) -> Void
public protocol APIClient {
    func estimante(_ request: EstimateRequest, completion: @escaping ResultCallback<EstimateResponse>)
    func confirm(_ request: ConfirmRequest, completion: @escaping ResultCallback<SuccessResponse>)
    func rides(_ request: RidesRequest, completion: @escaping ResultCallback<RidesResponse>)
}
