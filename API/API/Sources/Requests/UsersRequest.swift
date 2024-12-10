public struct UsersRequest: APIRequest {
    typealias Response = [UsersResponse]

    var httpMethod: APIHTTPMethod {
        .get
    }

    var resourceName: String {
        ""
    }
}
