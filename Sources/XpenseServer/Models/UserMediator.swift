//
//  UserMediator.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Corvus


/// A mediator to control the encode and decode network requests for a `User`
struct UserMediator: CorvusResponse {
    /// The stable identifier of the `User`
    let id: UUID?
    /// The username of the `User`
    let username: String
    /// The password of the `User` that should only be used for decoding the initial message
    let password: String?
    
    
    /// Create a UserMediator from a `User`.
    ///
    /// The password is explcityl **not** set when loading from an existing `User`
    /// - Parameter corvusUser: The `User` the `UserMediator` should be based on
    init(item corvusUser: CorvusUser) {
        self.id = corvusUser.id
        self.username = corvusUser.username
        self.password = nil
    }
    
    /// Create a UserMediator for testing purposes
    /// - Parameters:
    ///   - id: The stable identifier of the `User`
    ///   - username: The username of the `User`
    ///   - password: The password of the `User`
    init(id: UUID? = nil, username: String, password: String? = nil) {
        self.id = nil
        self.username = username
        self.password = password
    }
}
