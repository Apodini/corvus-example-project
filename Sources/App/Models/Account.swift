import Corvus
import Fluent

final class Account: CorvusModel {

    static let schema = "accounts"

    @ID
    var id: UUID? {
        didSet {
            $id.exists = true
        }
    }

    @Field(key: "name")
    var name: String

    @Parent(key: "user_id")
    var user: CorvusUser

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Children(for: \.$account)
    var transactions: [Transaction]

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }

    init() {}
}

struct CreateAccount: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Account.schema)
            .id()
            .field("name", .string, .required)
            .field(
                "user_id",
                .uuid,
                .references(CorvusUser.schema, "id")
            )
            .field("deleted_at", .date)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Account.schema).delete()
    }
}
