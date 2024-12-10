public struct RidesResponse: Codable {
    public let customerID: String
    public let rides: [RideResponse]

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case rides
    }

    public init(customerID: String, rides: [RideResponse]) {
        self.customerID = customerID
        self.rides = rides
    }
}
