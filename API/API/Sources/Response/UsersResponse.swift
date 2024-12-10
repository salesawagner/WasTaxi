public struct UsersResponse: Codable {
    public let customerId: String
    public let name: String

    enum CodingKeys: String, CodingKey {
        case customerId = "id"
        case name
    }
}
