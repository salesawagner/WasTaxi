//
//  GeoLocationResponseExtensions.swift
//  challenge
//
//  Created by Wagner Sales
//

import API
import CoreLocation

extension GeoLocationResponse {
    var toCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
