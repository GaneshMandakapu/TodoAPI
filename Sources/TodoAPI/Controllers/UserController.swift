//
//  UserController.swift
//  TodoAPI
//
//  Created by GaneshBalaraju on 21/06/25.
//

import Vapor
import Fluent
import JWT

struct UserSignup: Content {
    var username: String
    var password: String
}

struct UserLogin: Content {
    var username: String
    var password: String
}

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post("signup", use: signup)
        users.post("login", use: login)
    }

    func signup(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(UserSignup.self)
        let passwordHash = try Bcrypt.hash(user.password)
        let newUser = User(username: user.username, passwordHash: passwordHash)
        return newUser.save(on: req.db).map { newUser }
    }

    func login(req: Request) throws -> EventLoopFuture<TokenResponse> {
        let login = try req.content.decode(UserLogin.self)
        return User.query(on: req.db)
            .filter(\.$username == login.username)
            .first()
            .flatMapThrowing { user in
                guard let user, try Bcrypt.verify(login.password, created: user.passwordHash) else {
                    throw Abort(.unauthorized)
                }
                let payload = UserPayload(subject: .init(value: try user.requireID().uuidString),
                                          expiration: .init(value: .distantFuture))
                let token = try req.jwt.sign(payload)
                return TokenResponse(token: token)
            }
    }
}

struct TokenResponse: Content {
    let token: String
}
