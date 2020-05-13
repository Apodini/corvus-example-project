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


// MARK: UserTests
/// The unit tests that concern the `UsersEndpoint`
final class UsersEndpointTests: XpenseServerTests {
    /// Tests the sucessful creation of a `User` at the `api/users` route
    func testCreateUser() throws {
        try tester()
            .test(.POST,
                  "/api/users",
                  headers: ["content-type": "application/json"],
                  body: user.encode()) { response in
                let content = try response.content.decode(UserMediator.self)
                
                XCTAssertNil(content.password)
                
                let users = try CorvusUser.query(on: database()).all().wait()
                
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.id, content.id)
                XCTAssertEqual(users.first?.username, content.username)
            }
    }
    
    /// Tests the failure of creating a `User` without a password
    func testFailureWithoutPassword() throws {
        let request = UserMediator(username: "PSchmiedmayer")
        
        try tester()
            .test(.POST,
                  "/api/users",
                  headers: ["content-type": "application/json"],
                  body: request.encode()) { response in
                let content = try? response.content.decode(UserMediator.self)
                
                XCTAssertEqual(response.status, HTTPStatus.badRequest)
                XCTAssertNil(content)
            }
    }
    
    /// Tests the failure of creating a `User` without a password
    func testFailureWithSameUsername() throws {
        let corvusUser = CorvusUser(username: user.username,
                                    passwordHash: try Bcrypt.hash(user.password))
        try corvusUser.save(on: database()).wait()
        user.id = corvusUser.id
        
        try tester()
            .test(.POST,
                  "/api/users",
                  headers: ["content-type": "application/json"],
                  body: user.encode()) { response in
                let content = try? response.content.decode(UserMediator.self)
                
                XCTAssertEqual(response.status, HTTPStatus.badRequest)
                XCTAssertNil(content)
            }
    }
}
