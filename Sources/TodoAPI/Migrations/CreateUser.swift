//
//  CreateUser.swift
//  TodoAPI
//
//  Created by GaneshBalaraju on 21/06/25.
//


import Fluent

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("passwordHash", .string, .required)
            .unique(on: "username")
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
