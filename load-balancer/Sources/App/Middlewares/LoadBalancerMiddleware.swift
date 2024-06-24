//
//  LoadBalancerMiddleware.swift
//
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Vapor
import Foundation

struct LoadBalancerMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        let urlRequest = URLRequest(url: URL(string: "http://127.0.0.1:3001/ping")!)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw Abort(.internalServerError)
        }

        let responseHeaders = urlResponse.allHeaderFields
            .compactMap({ key, value -> (key: String, value: String)? in
                guard let key = key as? String else { return nil }
                guard let value = value as? String else { return nil }

                return (key, value)
            })
        let response = Response(
            status: .custom(code: UInt(urlResponse.statusCode), reasonPhrase: ""),
            version: request.version,
            headers: HTTPHeaders(responseHeaders),
            body: .init(data: data)
        )
        return response
    }
}
