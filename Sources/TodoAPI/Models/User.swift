//
//  User.swift
//  TodoAPI
//
//  Created by GaneshBalaraju on 21/06/25.
//


import Fluent
import Vapor
import JWTKit

final class User: Model, Content,@unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "passwordHash")
    var passwordHash: String

    init() {}

    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }
}
