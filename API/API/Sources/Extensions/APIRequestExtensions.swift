//
//  APIRequestExtensions.swift
//  API
//
//  Created by Wagner Sales
//

extension APIRequest {
    var localURL: URL? {
        let classType = type(of: self)
        let fileName = String(describing: classType)
        let bundle = Bundle(for: WASAPI.self)
        return bundle.getUrlFile(named: fileName)
    }
}
