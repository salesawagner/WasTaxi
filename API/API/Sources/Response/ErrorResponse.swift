public struct ErrorResponse: Codable {
    public let code: String
    public let description: String

    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case description = "error_description"
    }

    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
