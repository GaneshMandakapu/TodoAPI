import Fluent

struct CreateTodo: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("isCompleted", .bool, .required, .sql(.default(false)))
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("todos").delete()
    }
}
