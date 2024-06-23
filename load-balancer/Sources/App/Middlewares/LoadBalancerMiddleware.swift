//
//  LoadBalancerMiddleware.swift
//
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Vapor

struct LoadBalancerMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        let response = Response(status: .ok, version: request.version, headers: request.headers, body: .empty)

        return request.eventLoop.future(response)
    }
}
