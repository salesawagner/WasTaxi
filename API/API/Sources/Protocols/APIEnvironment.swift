//
//  APIEnvironment.swift
//  API
//
//  Created by Wagner Sales
//

import Foundation

public protocol APIEnvironment {
    var domainURL: URL? { get }
    var type: APIEnvironmentType { get }
}
