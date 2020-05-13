//
//  LoginTests.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

@testable import XpenseServer
import Corvus
import XCTVapor


// MARK: LoginTests
final class LoginTests: XpenseServerTests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let corvusUser = CorvusUser(username: user.username,
                                    passwordHash: try Bcrypt.hash(user.password))
        try corvusUser.save(on: database()).wait()
        user.id = corvusUser.id
    }
    
    func testLogin() throws {
        try tester()
            .test(.POST,
                  "/api/login",
                  headers: ["Authorization": user.basicAuth()]) { response in
                let content = try response.content.decode(CorvusToken.self)
                
                XCTAssertNotNil(content.id)
                XCTAssertTrue(content.isValid)
                XCTAssertEqual(content.$user.id, user.id)
                
                let tokens = try CorvusToken.query(on: database()).all().wait()
                
                XCTAssertEqual(tokens.count, 1)
                XCTAssertEqual(tokens.first, content)
            }
    }
    
    func testFailedLogin() throws {
        try tester()
            .test(.POST,
                  "/api/login",
                  headers: ["Authorization": "nothingHereToSee"]) { response in
                XCTAssertEqual(response.status, .unauthorized)
            }
    }
    
    func testNoHeaderLogin() throws {
        try tester()
            .test(.POST,
                  "/api/login") { response in
                XCTAssertEqual(response.status, .unauthorized)
            }
    }
}
