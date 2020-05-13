//
//  configure.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus
import Vapor
import FluentSQLiteDriver


/// Configures a Vapor `Application` including the DB setup
/// - Parameter app: The `Application` that should be configured
/// - Throws: The function will throw an error in case the migration fails
public func configure(_ app: Application) throws {
    // Set up the middlewares to support a Corvus authentication
    app.middleware.use(CorvusUser.authenticator())
    app.middleware.use(CorvusToken.authenticator())
    
    // Set up the database that should be used with the Xpense Server
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    // Add migrations for the Types stored in the DB of the Xpense Server
    app.migrations.add(CreateAccount())
    app.migrations.add(CreateTransaction())
    app.migrations.add(CreateCorvusUser()) // The User class provided by Corvus
    app.migrations.add(CreateCorvusToken()) // The Token class provided by Corvus
    // Start the Vapor migration
    try app.autoMigrate().wait()
}
