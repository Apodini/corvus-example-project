//
//  Account.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Corvus
import Fluent


// MARK: - Account
/// Represents a single account that consists of a set of transactions.
final class Account: CorvusModel {
    /// The name of the DB table that stores the `Account`s
    static let schema = "accounts"

    
    /// The stable identity of the `Account`
    @ID
    var id: UUID? {
        didSet {
            if id != nil {
                $id.exists = true
            }
        }
    }
    /// The name of the `Account`
    @Field(key: "name")
    var name: String
    /// The `CorvusUser` of the `Account`
    @Parent(key: "user_id")
    var user: CorvusUser
    /// The `Transaction`s that are associated with the `Account`
    @Children(for: \.$account)
    var transactions: [Transaction]

    
    /// - Parameters:
    ///   - id: The stable identity of the `Account`
    ///   - name: The name of the `Account`
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }

    /// An empty initializer that is used when loading an `Account` from the DB
    init() { }
}


// MARK: - CreateAccount
struct CreateAccount: Migration {
    /// Creates the schema for `Account`s for a specific `database`
    /// - Parameter database: The `Database` where the schema should be created
    /// - Returns: The future that results from the schema creation
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Account.schema)
            .id()
            .field("name", .string, .required)
            .field(
                "user_id",
                .uuid,
                .references(CorvusUser.schema, .id)
            )
            .create()
    }

    /// Deletes the schema for `Account`s for a specific `database`
    /// - Parameter database: The `Database` where the schema should be deleted
    /// - Returns: The future that results from the schema deletion
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Account.schema).delete()
    }
}
