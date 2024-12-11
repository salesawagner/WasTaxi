public struct RidesResponse: Codable {
    public let customerId: String
    public let rides: [RideResponse]

    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case rides
    }

    public init(customerId: String, rides: [RideResponse]) {
        self.customerId = customerId
        self.rides = rides
    }
}
