import Vapor
import Fluent

struct TodoController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let todos = routes.grouped("todos").grouped(JWTMiddleware()) // 👈 Secure with JWT
        todos.get(use: index)
        todos.post(use: create)
        todos.delete(":todoID", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        let userID = payload.userID
        return Todo.query(on: req.db)
            .filter(\.$user.$id == payload.userID)
            .all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        let todo = try req.content.decode(Todo.self)
        let newTodo = Todo(title: todo.title, userID: payload.userID)
        return newTodo.save(on: req.db).map { newTodo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { todo in
                guard todo.$user.id == payload.userID else {
                    return req.eventLoop.makeFailedFuture(Abort(.forbidden))
                }
                return todo.delete(on: req.db).transform(to: .ok)
            }
    }
}
