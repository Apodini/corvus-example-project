//
//  main.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Vapor
import XpenseServer


// Detect the current execution environment, e.g. environment variables and configure the
// `LoggingSystem` as well as the Vapor `Application` instance
var environment = try Environment.detect()
try LoggingSystem.bootstrap(from: &environment)
let app = Application(environment)

// Configure the Vapor application with the help of Corvus found in `configure.swift`
try configure(app)

// Set up the routes found in `routes.swift`
try routes(app)

// Start the Application
defer {
    // Use a defer statement to shut down the server once `app.run()` returns
    // which is the case if the server is stopped e.g. using the command line
    app.shutdown()
}

try app.run()
