//
//  TestUser.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Vapor
import XCTest


// MARK: TestUser
/// A test user to test the user and login enpoints
struct TestUser: Codable {
    /// The id of the `TestUser`
    var id: UUID?
    /// The username of the `TestUser`
    let username: String
    /// The password of the `TestUser`
    let password: String
    /// The the token of the `TestUser`
    var token: String?
    
    
    /// Returns the user credentials formatted in a way that it can be passed into the Authorization header of a HTTP request
    /// - Throws: An error it the credentials could not be created
    /// - Returns: The credentials formatted in a way that it can be passed into the Authorization header of a HTTP request
    func basicAuth() throws -> String {
        let credentials = try XCTUnwrap("\(username):\(password)".data(using: .utf8)?.base64EncodedString())
        return "Basic \(credentials)"
    }
    
    /// Returns the token formatted in a way that it can be passed into the Authorization header of a HTTP request
    /// - Throws: An error of the token was nil
    /// - Returns: The token formatted in a way that it can be passed into the Authorization header of a HTTP request
    func bearerToken() throws -> String {
        "Bearer \(try XCTUnwrap(token))"
    }
}
