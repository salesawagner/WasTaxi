public struct RideResponse: Codable {
    public let id: Int
    public let date: String
    public let origin: String
    public let destination: String
    public let distance: Double
    public let duration: String
    public let driver: DriverResponse
    public let value: Double

    public init(
        id: Int,
        date: String,
        origin: String,
        destination: String,
        distance: Double,
        duration: String,
        driver: DriverResponse,
        value: Double
    ) {
        self.id = id
        self.date = date
        self.origin = origin
        self.destination = destination
        self.distance = distance
        self.duration = duration
        self.driver = driver
        self.value = value
    }
}
