//
//  CatchAllMiddleware.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Vapor

struct CatchAllMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        return request.eventLoop.future(error: Abort(.badGateway))
    }
}
