//
//  TransactionsEndpointTests.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

@testable import XpenseServer
import Corvus
import XCTVapor


// MARK: TransactionsEndpointTests
/// The unit tests that concern the `TransactionsEndpoint`
final class TransactionsEndpointTests: XpenseServerTests {
    /// The `Account` that can be used in the testcases
    var account: Account?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create the User
        let corvusUser = CorvusUser(username: user.username,
                                    passwordHash: try Bcrypt.hash(user.password))
        try corvusUser.save(on: database()).wait()
        user.id = corvusUser.id
        
        // Create the Token
        let userId = try XCTUnwrap(user.id)
        
        let corvusToken = CorvusToken(value: "kt3Lp9Aozk9JAwo13wueCw==", userID: userId)
        try corvusToken.save(on: database()).wait()
        user.token = corvusToken.value
        
        // Create the Account
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        try account.create(on: database()).wait()
        self.account = account
    }
    
    /// Tests getting an `Transaction` at the `api/transactions` endpoint
    func testGetTransactionsOne() throws {
        let transaction = Transaction(amount: -490,
                                      description: "Käsespätzle",
                                      date: Date(),
                                      location: Coordinate(48.262432, 11.667976),
                                      account: try XCTUnwrap(account?.id))
        try transaction.create(on: database()).wait()
        
        try tester()
            .test(.GET,
                  "/api/transactions",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ]) { response in
                let content = try response.content.decode([Transaction].self)
                XCTAssertEqual(content.count, 1)
                XCTAssertEqual(content.first, transaction)
            }
    }
    
    /// Tests getting an `Transaction` at the `api/transactions` endpoint
    func testGetTransactionsTwo() throws {
        let transaction = Transaction(amount: -490,
                                      description: "Käsespätzle",
                                      location: Coordinate(48.262432, 11.667976),
                                      account: try XCTUnwrap(account?.id))
        try transaction.create(on: database()).wait()
        
        let secondTransaction = Transaction(amount: -120,
                                            description: "Spezi",
                                            location: Coordinate(48.262432, 11.667976),
                                            account: try XCTUnwrap(account?.id))
        try secondTransaction.create(on: database()).wait()
        
        try tester()
            .test(.GET,
                  "/api/transactions",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ]) { response in
                let content = try response.content.decode([Transaction].self)
                XCTAssertEqual(content.count, 2)
                XCTAssertEqual(content.first, transaction)
                XCTAssertEqual(content.last, secondTransaction)
            }
    }
    
    /// Tests the sucessful creation of an `Transaction` at the `api/transactions` route
    func testCreateTransaction() throws {
        let transaction = Transaction(amount: -490,
                                      description: "Käsespätzle",
                                      location: Coordinate(48.262432, 11.667976),
                                      account: try XCTUnwrap(account?.id))
        
        try tester()
            .test(.POST,
                  "/api/transactions",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ],
                  body: transaction.encode()) { response in
                let content = try response.content.decode(Transaction.self)
                
                XCTAssertNotNil(content.id)
                content.xctAssertEqualWithoutId(transaction)
                
                Transaction.query(on: try database()).all().whenSuccess { dbTransactions in
                    XCTAssertEqual(dbTransactions.count, 1)
                    XCTAssertEqual(content, dbTransactions.first)
                }
            }
    }
    
    /// Tests the sucessful update of an `Transaction` at the `api/transactions` route
    func testUpdateTransaction() throws {
        let transaction = Transaction(amount: -490,
                                      description: "Käsespätzle",
                                      location: Coordinate(48.262432, 11.667976),
                                      account: try XCTUnwrap(account?.id))
        try transaction.create(on: database()).wait()
        
        transaction.amount = -500
        transaction.description = "Great Käsespätzle"
        transaction.location = Coordinate(37.332792, -122.005349)
        let transactionId = try XCTUnwrap(transaction.id?.uuidString)
        
        try tester()
            .test(.PUT,
                  "/api/transactions/\(transactionId)",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ],
                  body: transaction.encode()) { response in
                let content = try response.content.decode(Transaction.self)
                
                XCTAssertNotNil(content.id)
                content.xctAssertEqualWithoutId(transaction)
                
                Transaction.query(on: try database()).all().whenSuccess { dbTransactions in
                    XCTAssertEqual(dbTransactions.count, 1)
                    XCTAssertEqual(content, dbTransactions.first)
                }
            }
    }
    
    /// Tests the sucessful delete of an `Transaction` at the `api/transactions` route
    func testDeleteTransaction() throws {
        let transaction = Transaction(amount: -490,
                                      description: "Käsespätzle",
                                      location: Coordinate(48.262432, 11.667976),
                                      account: try XCTUnwrap(account?.id))
        try transaction.create(on: database()).wait()
        
        let transactionId = try XCTUnwrap(transaction.id?.uuidString)
        XCTAssertEqual(try Transaction.query(on: try database()).all().wait().count, 1)
        
        try tester()
            .test(.DELETE,
                  "/api/transactions/\(transactionId)",
                  headers: ["Authorization": user.bearerToken()]) { response in
                XCTAssertEqual(response.status, .ok)
                XCTAssertEqual(try Transaction.query(on: try database()).all().wait().count, 0)
            }
    }
    
    func testAuthentication() throws {
        let transaction = Transaction(amount: -490,
                                      description: "Käsespätzle",
                                      location: Coordinate(48.262432, 11.667976),
                                      account: try XCTUnwrap(account?.id))
        try transaction.create(on: database()).wait()
        
        let transactionId = try XCTUnwrap(transaction.id?.uuidString)
        XCTAssertEqual(try Transaction.query(on: try database()).all().wait().count, 1)
        
        try tester()
            .test(.GET,
                  "/api/transactions/") { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Transaction.query(on: try database()).all().wait().count, 1)
            }
        
        try tester()
            .test(.POST,
                  "/api/transactions/",
                  body: account.encode()) { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Transaction.query(on: try database()).all().wait().count, 1)
            }
        
        try tester()
            .test(.PUT,
                  "/api/transactions/\(transactionId)",
                  body: account.encode()) { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Transaction.query(on: try database()).all().wait().first, transaction)
            }
        
        try tester()
            .test(.DELETE,
                  "/api/transactions/\(transactionId)") { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Transaction.query(on: try database()).all().wait().count, 1)
            }
    }
}
