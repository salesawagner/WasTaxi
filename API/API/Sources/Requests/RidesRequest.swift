public struct RidesRequest: APIRequest {
    typealias Response = RidesResponse

    var httpMethod: APIHTTPMethod {
        .get
    }

    var resourceName: String {
        "/ride/\(customerId)"
    }

    var customerId: String
    var driverId: Int?

    enum CodingKeys: String, CodingKey {
        case driverId = "driver_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(self.driverId, forKey: .driverId)
    }

    public init(customerId: String, driverId: Int? = nil) {
        self.customerId = customerId
        self.driverId = driverId
    }
}
