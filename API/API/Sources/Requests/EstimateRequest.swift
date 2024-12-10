public struct EstimateRequest: APIRequest {
    typealias Response = EstimateResponse

    var httpMethod: APIHTTPMethod {
        .post
    }

    var resourceName: String {
        "ride/estimate"
    }

    var customerId: String
    var origin: String
    var destination: String

    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case origin
        case destination
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encodeIfPresent(self.customerId, forKey: .customerId)
        try? container.encodeIfPresent(self.origin, forKey: .origin)
        try? container.encodeIfPresent(self.destination, forKey: .destination)
    }

    public init(customerId: String, origin: String, destination: String) {
        self.customerId = customerId
        self.origin = origin
        self.destination = destination
    }
}
