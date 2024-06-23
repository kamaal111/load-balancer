//
//  RequestLoggerMiddleware.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Vapor

struct RequestLoggerMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        let lines = [
            "Received request from \(request.remoteAddress?.ipAddress ?? "")",
            "\(request.method.string) \(request.url.path) \(request.version)",
        ] + request.headers.map({ header in "\(header.name): \(header.value)" }).sorted()
        let separatorLength = 30
        printSeparator(ofSize: separatorLength)
        print(lines.joined(separator: "\n"))
        printSeparator(ofSize: separatorLength)

        return next.respond(to: request)
    }

    private func printSeparator(ofSize size: Int) {
        let separator = (0..<size).map({ _ in "-" }).joined(separator: "")
        print(separator)
    }
}
