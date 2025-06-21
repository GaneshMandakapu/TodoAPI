import Vapor
import Fluent
import FluentSQLiteDriver
import JWT

func configure(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())

    try await app.autoMigrate()

    app.middleware.use(JWTMiddleware())
    
    try routes(app)
}
