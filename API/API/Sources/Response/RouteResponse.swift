import Foundation

public struct RouteResponse: Decodable {
    public let encodedPolylines: [String]

    enum CodingKeys: String, CodingKey {
        case routes
    }

    enum RouteCodingKeys: String, CodingKey {
        case polyline
    }

    enum PolylineCodingKeys: String, CodingKey {
        case encodedPolyline
    }

    public init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)

        var encodedPolylines: [String] = []
        if let container = container, var routesArray = try? container.nestedUnkeyedContainer(forKey: .routes) {
            while !routesArray.isAtEnd {
                let route = try routesArray.nestedContainer(keyedBy: RouteCodingKeys.self)
                let polyline = try route.nestedContainer(keyedBy: PolylineCodingKeys.self, forKey: .polyline)
                let encodedPolyline = try polyline.decode(String.self, forKey: .encodedPolyline)
                encodedPolylines.append(encodedPolyline)
            }
        }
        self.encodedPolylines = encodedPolylines
    }

    public init(encodedPolylines: [String]) {
        self.encodedPolylines = encodedPolylines
    }
}
