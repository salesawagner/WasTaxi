//
//  Environment.swift
//  challenge
//
//  Created by Wagner Sales
//

import API

final class Environment: APIEnvironment {
    var domainURL: URL?
    var type: API.APIEnvironmentType

    init(domainURL: URL? = nil, type: API.APIEnvironmentType) {
        self.domainURL = domainURL
        self.type = type
    }
}

// MARK: - Helpers

extension Environment {
    static var local = Environment(type: .local)
    static var production = Environment(
        domainURL: URL(string: "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws"),
        type: .production
    )
}
