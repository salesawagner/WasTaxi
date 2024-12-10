public struct DriverResponse: Codable {
    public let id: Int
    public let name: String
    public let description: String?
    public let vehicle: String?
    public let review: ReviewResponse?
    public let value: Double?

    public init(
        id: Int,
        name: String,
        description: String?,
        vehicle: String?,
        review: ReviewResponse?,
        value: Double?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.vehicle = vehicle
        self.review = review
        self.value = value
    }
}
