//
//  routes.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus
import Vapor


/// Registers the routes that should be served by the Xpense Application
/// - Parameter app: The `Application` instance where the routes should be registered to
/// - Throws: The function will throw an error in case the registration of the routes fails
public func routes(_ app: Application) throws {
    // Instantiate the Corvus API and register the API to the Vapor router
    let api = XpenseApi()
    try app.register(collection: api)
}
