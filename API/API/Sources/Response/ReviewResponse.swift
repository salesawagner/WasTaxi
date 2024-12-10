public struct ReviewResponse: Codable {
    public let rating: Int
    public let comment: String

    public init(rating: Int, comment: String) {
        self.rating = rating
        self.comment = comment
    }
}
