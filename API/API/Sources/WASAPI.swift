//
//  APIClient.swift
//  API
//
//  Created by Wagner Sales
//

import Foundation

public final class WASAPI {
    // MARK: Private Properties

    private var environment: APIEnvironment
    private let session = URLSession(configuration: .default)

    // MARK: Inits

    public init(environment: APIEnvironment) {
        self.environment = environment
    }

    // MARK: Private Methods

    private func endpoint<T: APIRequest>(for request: T) -> URL? {
        guard environment.type != .local else {
            return request.localURL
        }

        guard
            let domainURL = environment.domainURL,
            let endpoint = URL(string: request.resourceName, relativeTo: domainURL),
            var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true) else {
            return nil
        }

        var customQueryItems: [URLQueryItem] = []
        switch request.httpMethod {
        case .get:
            do {
                let queryItems = try URLQueryItemEncoder.encode(request)
                customQueryItems.append(contentsOf: queryItems)
            } catch {
                return nil
            }

            components.queryItems = customQueryItems
            return components.url

        default:
            return components.url
        }
    }

    private func prepareRequest<R: APIRequest>(_ request: R, endpoint: URL) -> URLRequest {
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        if request.httpMethod != .get {
            do {
                let parameters = try JSONEncoder().encode(request)
                urlRequest.httpBody = parameters
            } catch let error {
                print(error.localizedDescription)
            }
        }

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }

    private func dataTask(urlRequest: URLRequest, completion: @escaping ResultCallback<(Data?, URLResponse?)>) {
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.invalidResponse))
                return
            }

            completion(.success((data, response)))
        }

        task.resume()
    }

    private func parse<R: APIRequest>(
        _ request: R,
        data: Data?,
        response: URLResponse?,
        completion: @escaping ResultCallback<R.Response>
    ) {
        guard let data = data else {
            completion(.failure(APIError.invalidResponse))
            return
        }

        let decoder = JSONDecoder()
        do {
            let response = try decoder.httpRequest(request: request, data: data)
            completion(.success(response))
            showData(data: data)
        } catch DecodingError.keyNotFound(let key, let context) {

            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                completion(.failure(APIError.error(error: errorResponse)))
                showData(data: data)
            } catch {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(APIError.invalidResponse))
            }

        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(APIError.invalidResponse))
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(APIError.invalidResponse))
        } catch {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 404
            completion(.failure(APIError.unknown(error: error, statusCode: statusCode)))
        }
    }

    private func send<R>(_ request: R, completion: @escaping ResultCallback<R.Response>) where R: APIRequest {
        guard let endpoint = endpoint(for: request) else {
            completion(.failure(APIError.badUrl))
            return
        }

        let urlRequest = prepareRequest(request, endpoint: endpoint)
        print(urlRequest.cURL(pretty: true))

        dataTask(urlRequest: urlRequest) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                self?.parse(request, data: data, response: response, completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func showData(data: Data) {
        if let str = String(data: data, encoding: .utf8) {
            print("Successfully decoded: \(str)")
        }
    }
}

// MARK: APIClient

extension WASAPI: APIClient {
    public func estimante(_ request: EstimateRequest, completion: @escaping ResultCallback<EstimateResponse>) {
        send(request, completion: completion)
    }

    public func confirm(_ request: ConfirmRequest, completion: @escaping ResultCallback<SuccessResponse>) {
        send(request, completion: completion)
    }

    public func rides(_ request: RidesRequest, completion: @escaping ResultCallback<RidesResponse>) {
        send(request, completion: completion)
    }
}
