import Corvus
import Fluent

final class Transaction: CorvusModel {

    static let schema = "transactions"

    @ID
    var id: UUID? {
        didSet {
            $id.exists = true
        }
    }

    @Field(key: "amount")
    var amount: Double

    @Field(key: "currency")
    var currency: String

    @Field(key: "description")
    var description: String?

    @Field(key: "date")
    var date: Date

    @Parent(key: "account_id")
    var account: Account

    init(
        id: UUID? = nil,
        amount: Double,
        currency: String,
        description: String?,
        date: Date,
        accountID: Account.IDValue
    ) {
      self.id = id
      self.amount = amount
      self.currency = currency
      self.description = description
      self.date = date
      self.$account.id = accountID
    }

    init() {}
}

struct CreateTransaction: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Transaction.schema)
            .id()
            .field("amount", .double, .required)
            .field("currency", .string, .required)
            .field("description", .string)
            .field("date", .datetime, .required)
            .field("account_id", .uuid, .references(Account.schema, .id))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Transaction.schema).delete()
    }
}
