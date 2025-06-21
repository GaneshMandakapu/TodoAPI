//
//  JWTMiddleware.swift
//  TodoAPI
//
//  Created by GaneshBalaraju on 21/06/25.
//


import Vapor
import JWT

struct JWTMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        do {
            try request.jwt.verify(as: UserPayload.self)
            return next.respond(to: request)
        } catch {
            return request.eventLoop.makeFailedFuture(Abort(.unauthorized))
        }
    }
}
