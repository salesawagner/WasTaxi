//
//  StringExtensions.swift
//  challenge
//
//  Created by Wagner Sales
//

import Foundation
import CoreLocation

extension String {
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeZone = TimeZone.current

        return formatter.date(from: self)
    }

    var toDateFormatted: String? {
        guard let date = toDate else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeZone = TimeZone.current

        return formatter.string(from: date)
    }

    var toCoordinates: [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        var index = startIndex

        var latitude: Int32 = 0
        var longitude: Int32 = 0

        while index < endIndex {
            var result: Int32 = 0
            var shift: Int32 = 0
            var byte: Int32

            repeat {
                byte = Int32(self[index].asciiValue! - 63)
                index = self.index(after: index)
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20

            let deltaLatitude = (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
            latitude += deltaLatitude

            result = 0
            shift = 0

            repeat {
                byte = Int32(self[index].asciiValue! - 63)
                index = self.index(after: index)
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20

            let deltaLongitude = (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
            longitude += deltaLongitude

            let coordinate = CLLocationCoordinate2D(
                latitude: Double(latitude) * 1e-5,
                longitude: Double(longitude) * 1e-5
            )
            coordinates.append(coordinate)
        }

        return coordinates
    }
}
