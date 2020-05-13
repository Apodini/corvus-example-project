//
//  AccountsEndpointTests.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

@testable import XpenseServer
import Corvus
import XCTVapor


// MARK: AccountsEndpointTests
/// The unit tests that concern the `AccountsEndpoint`
final class AccountsEndpointTests: XpenseServerTests {
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
    }
    
    /// Tests getting an `Account` at the `api/accounts` endpoint
    func testGetAccountsOne() throws {
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        try account.create(on: database()).wait()
        
        try tester()
            .test(.GET,
                  "/api/accounts",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ]) { response in
                let content = try response.content.decode([Account].self)
                XCTAssertEqual(content.count, 1)
                XCTAssertEqual(content.first, account)
            }
    }
    
    /// Tests getting an `Account` at the `api/accounts` endpoint
    func testGetAccountsTwo() throws {
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        try account.create(on: database()).wait()
        
        let secondAccount = Account(name: "Paul's Wallet")
        user.id.map { secondAccount.$user.id = $0 }
        try secondAccount.create(on: database()).wait()
        
        try tester()
            .test(.GET,
                  "/api/accounts",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ]) { response in
                let content = try response.content.decode([Account].self)
                XCTAssertEqual(content.count, 2)
                XCTAssertEqual(content.first, account)
                XCTAssertEqual(content.last, secondAccount)
            }
    }
    
    /// Tests the sucessful creation of an `Account` at the `api/accounts` route
    func testCreateAccount() throws {
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        
        try tester()
            .test(.POST,
                  "/api/accounts",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ],
                  body: account.encode()) { response in
                let content = try response.content.decode(Account.self)
                
                XCTAssertNotNil(content.id)
                XCTAssertEqual(content.name, account.name)
                XCTAssertEqual(content.$user.id, account.$user.id)
                
                Account.query(on: try database()).all().whenSuccess { dbAccounts in
                    XCTAssertEqual(dbAccounts.count, 1)
                    XCTAssertEqual(content, dbAccounts.first)
                }
            }
    }
    
    /// Tests the sucessful update of an `Account` at the `api/accounts` route
    func testUpdateAccount() throws {
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        try account.create(on: database()).wait()
        
        account.name = "Paul's Second Wallet"
        let accountId = try XCTUnwrap(account.id?.uuidString)
        
        try tester()
            .test(.PUT,
                  "/api/accounts/\(accountId)",
                  headers: [
                    "Content-Type": "application/json",
                    "Authorization": user.bearerToken()
                  ],
                  body: account.encode()) { response in
                let content = try response.content.decode(Account.self)
                
                XCTAssertNotNil(content.id)
                XCTAssertEqual(content.name, account.name)
                XCTAssertEqual(content.$user.id, account.$user.id)
                
                Account.query(on: try database()).all().whenSuccess { dbAccounts in
                    XCTAssertEqual(dbAccounts.count, 1)
                    XCTAssertEqual(content, dbAccounts.first)
                }
            }
    }
    
    /// Tests the sucessful delete of an `Account` at the `api/accounts` route
    func testDeleteAccount() throws {
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        try account.create(on: database()).wait()
        
        let accountId = try XCTUnwrap(account.id?.uuidString)
        XCTAssertEqual(try Account.query(on: try database()).all().wait().count, 1)
        
        try tester()
            .test(.DELETE,
                  "/api/accounts/\(accountId)",
                  headers: ["Authorization": user.bearerToken()]) { response in
                XCTAssertEqual(response.status, .ok)
                XCTAssertEqual(try Account.query(on: try database()).all().wait().count, 0)
            }
    }
    
    func testAuthentication() throws {
        let account = Account(name: "Paul's Wallet")
        user.id.map { account.$user.id = $0 }
        try account.create(on: database()).wait()
        
        let accountId = try XCTUnwrap(account.id?.uuidString)
        XCTAssertEqual(try Account.query(on: try database()).all().wait().count, 1)
        
        try tester()
            .test(.GET,
                  "/api/accounts/") { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Account.query(on: try database()).all().wait().count, 1)
            }
        
        try tester()
            .test(.POST,
                  "/api/accounts/",
                  body: account.encode()) { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Account.query(on: try database()).all().wait().count, 1)
            }
        
        try tester()
            .test(.PUT,
                  "/api/accounts/\(accountId)",
                  body: account.encode()) { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Account.query(on: try database()).all().wait().first, account)
            }
        
        try tester()
            .test(.DELETE,
                  "/api/accounts/\(accountId)") { response in
                XCTAssertEqual(response.status, .unauthorized)
                XCTAssertEqual(try Account.query(on: try database()).all().wait().count, 1)
            }
    }
}
