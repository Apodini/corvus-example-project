//
//  UsersEndpoint.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus
import Vapor
import Fluent


// MARK: UsersEndpoint
/// The `Endpoint` that handles all the API interaction with `Users`
final class UsersEndpoint: Endpoint {
    var content: Endpoint {
        Custom<CorvusUser>(pathComponents: "users", type: .post) { request in
            // Load the `User` as a `UserMediator` from the request
            let userMediator = try request.content.decode(UserMediator.self)
            
            // Hash the user password
            guard let password = userMediator.password else {
                // If the user has not provided a password we return a HTTP response 400 - Bad Request
                throw Abort(.badRequest)
            }
            let passwordHash = try Bcrypt.hash(password)
            
            // Create a DB query and check if a user with the same username already exists
            return CorvusUser // swiftlint:disable:this first_where
                .query(on: request.db)
                .filter(\.$username == userMediator.username)
                .first()
                .flatMapThrowing { existingUser in
                    guard existingUser == nil else {
                        // If a user alrady exists return a HTTP response 400 - Bad Request
                        throw Abort(.badRequest)
                    }
                }
                .flatMap {
                    // Create the new `CorvusUser`
                    let corvusUser = CorvusUser(username: userMediator.username, passwordHash: passwordHash)
                    // Save it to the `CorvusUser` and return the newly created `CorvusUser`
                    return corvusUser.save(on: request.db).map { corvusUser }
                }
        }.respond(with: UserMediator.self) // Map the `CorvusUser` to respond with a `UserMediator`
    }
}
