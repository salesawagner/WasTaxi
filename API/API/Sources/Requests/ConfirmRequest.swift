public struct ConfirmRequest: APIRequest {
    typealias Response = SuccessResponse

    var httpMethod: APIHTTPMethod {
        .patch
    }

    var resourceName: String {
        "ride/confirm"
    }

    var customerId: String
    var origin: String
    var destination: String
    var distance: Int
    var duration: Int
    var driver: DriverRequest
    var value: Double

    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case origin
        case destination
        case distance
        case duration
        case driver
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(self.customerId, forKey: .customerId)
        try? container.encodeIfPresent(self.origin, forKey: .origin)
        try? container.encodeIfPresent(self.destination, forKey: .destination)
        try? container.encodeIfPresent(self.distance, forKey: .distance)
        try? container.encodeIfPresent(self.duration, forKey: .duration)
        try? container.encodeIfPresent(self.driver, forKey: .driver)
        try? container.encodeIfPresent(self.value, forKey: .value)
    }

    public init(
        customerId: String,
        origin: String,
        destination: String,
        distance: Int,
        duration: Int,
        driver: DriverRequest,
        value: Double
    ) {
        self.customerId = customerId
        self.origin = origin
        self.destination = destination
        self.distance = distance
        self.duration = duration
        self.driver = driver
        self.value = value
    }
}
