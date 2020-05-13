//
//  Transaction.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Corvus
import FluentKit


// MARK: - Cent
typealias Cent = Int


// MARK: - Transaction
/// Represents a single transaction of an `Account`
final class Transaction: CorvusModel {
    /// The name of the DB table that stores the `Transaction`s
    static let schema = "transactions"

    
    /// The stable identity of the `Transaction`
    @ID
    var id: UUID? {
        didSet {
            if id != nil {
                $id.exists = true
            }
        }
    }
    /// The amount of money this transaction is worth in `Cent`s
    @Field(key: "amount")
    var amount: Int
    /// A textual description of the `Transaction`
    @Field(key: "description")
    var description: String
    /// The date this `Transaction` was executed
    @Field(key: "date")
    var date: Date
    /// The location of the `Transaction` as a `Coordinate`
    @Field(key: "location")
    var location: Coordinate?
    /// The `Account` this `Transaction` is linked to
    @Parent(key: "account_id")
    var account: Account

    
    /// - Parameters:
    ///     - id: The stable identity of the `Transaction`
    ///     - amount: The amount of money this transaction is worth in `Cent`s
    ///     - description: A textual description of the `Transaction`
    ///     - date: The date this `Transaction` was executed
    ///     - location: The location of the `Transaction` as a `Coordinate`
    ///     - account: The `Account` this `Transaction` is linked to
    init(id: UUID? = nil,
         amount: Cent,
         description: String,
         date: Date? = nil,
         location: Coordinate?,
         account: Account.IDValue) {
        if let id = id {
            self.id = id
        }
        self.amount = amount
        self.description = description
        self.date = date ?? Date()
        self.location = location
        self.$account.id = account
    }

    /// An empty initializer that is used when loading an `Transaction` from the DB
    init() {}
}


// MARK: - CreateTransaction
struct CreateTransaction: Migration {
    /// Creates the schema for `Transaction`s for a specific `database`
    /// - Parameter database: The `Database` where the schema should be created
    /// - Returns: The future that results from the schema creation
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Transaction.schema)
            .id()
            .field("amount", .int, .required)
            .field("description", .string, .required)
            .field("date", .datetime, .required)
            .field("location", .data)
            .field("account_id", .uuid, .references(Account.schema, .id))
            .create()
    }
    
    /// Deletes the schema for `Transaction`s for a specific `database`
    /// - Parameter database: The `Database` where the schema should be deleted
    /// - Returns: The future that results from the schema deletion
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Transaction.schema).delete()
    }
}
