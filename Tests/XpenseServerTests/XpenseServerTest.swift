//
//  UsersEndpointTests.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

@testable import XpenseServer
import Corvus
import XCTVapor
import Fluent


// MARK: XpenseServerTests
class XpenseServerTests: XCTestCase {
    /// The user that can be used to store information about the current user in the test cases
    var user = TestUser(username: "PSchmiedmayer", password: "AVerySecurePassword")
    /// The Vaport Test Application that forms the system under test
    private var app: Application?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let app = Application(.testing)
        app.databases.use(.sqlite(.memory), as: .init(string: "XpenseServerTest"), isDefault: true)
        
        app.middleware.use(CorvusToken.authenticator())
        app.middleware.use(CorvusUser.authenticator())
        
        app.migrations.add(CreateAccount())
        app.migrations.add(CreateTransaction())
        app.migrations.add(CreateCorvusUser()) // The User class provided by Corvus
        app.migrations.add(CreateCorvusToken()) // The Token class provided by Corvus

        try app.autoMigrate().wait()
        
        try app.register(collection: xpenseApi)
        
        self.app = app
        
        self.user = TestUser(username: "PSchmiedmayer", password: "AVerySecurePassword")
    }
    
    override func tearDownWithError() throws {
        let app = try XCTUnwrap(self.app)
        app.shutdown()
    }
    
    /// Cerates an instance of `XCTApplicationTester` that can be used in unit tests
    /// - Throws: Throws an error it there is no Vapor application to create the `XCTApplicationTester` or creating the `XCTApplicationTester` fails
    /// - Returns: Return an instance of `XCTApplicationTester` that can be used in unit tests
    func tester() throws -> XCTApplicationTester {
        try XCTUnwrap(app?.testable())
    }
    
    /// Returns the database to manually create elements in the database
    /// - Returns: The database instance to configure the unit tests
    func database() throws -> Database {
        try XCTUnwrap(self.app?.db)
    }
}
