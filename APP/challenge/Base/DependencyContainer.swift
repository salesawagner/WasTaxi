//
//  DependencyContainer.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

final class DependencyContainer {
    static let apiClient = WASAPI(environment: Environment.production)
}
