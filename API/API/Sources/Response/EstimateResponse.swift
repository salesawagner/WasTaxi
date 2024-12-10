public struct EstimateResponse: Decodable {
    public let origin: GeoLocationResponse
    public let destination: GeoLocationResponse
    public let distance: Int
    public let duration: Int
    public let drivers: [DriverResponse]
    public let routeResponse: RouteResponse?

    enum CodingKeys: String, CodingKey {
        case origin
        case destination
        case distance
        case duration
        case drivers = "options"
        case routeResponse
    }

    public init(
        origin: GeoLocationResponse,
        destination: GeoLocationResponse,
        distance: Int,
        duration: Int,
        drivers: [DriverResponse],
        routeResponse: RouteResponse
    ) {
        self.origin = origin
        self.destination = destination
        self.distance = distance
        self.duration = duration
        self.drivers = drivers
        self.routeResponse = routeResponse
    }
}
