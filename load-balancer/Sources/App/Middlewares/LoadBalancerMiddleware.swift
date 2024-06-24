//
//  LoadBalancerMiddleware.swift
//
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Vapor
import Foundation

private let SERVICES = [
    "http://127.0.0.1:3001",
    "http://127.0.0.1:3002",
    "http://127.0.0.1:3003",
    "http://127.0.0.1:3004",
]

struct LoadBalancerMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        let serviceIndex = await State.shared.incrementAndGetPreviousRequestCount() % SERVICES.count
        let urlRequest = URLRequest(url: URL(string: "\(SERVICES[serviceIndex])\(request.url.path)")!)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw Abort(.internalServerError) }

        let headers = response.allHeaderFields
            .compactMap({ key, value -> (key: String, value: String)? in
                guard let key = key as? String else { return nil }
                guard let value = value as? String else { return nil }

                return (key, value)
            })
        return Response(
            status: .custom(code: UInt(response.statusCode), reasonPhrase: ""),
            version: request.version,
            headers: HTTPHeaders(headers),
            body: .init(data: data)
        )
    }
}

private actor State {
    var requestCount: Int

    init() {
        self.requestCount = 0
    }

    func incrementAndGetPreviousRequestCount() -> Int {
        let requestCount = requestCount
        incrementRequestCount()
        return requestCount
    }

    private func incrementRequestCount() {
        requestCount += 1
    }

    static let shared = State()
}
