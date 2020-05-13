//
//  API.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus


// MARK: XpenseApi
/// The main class that describes the RESTful API of the Xpense App
final class XpenseApi: RestApi {
    var content: Endpoint {
        Group("api") {
            // The users route that handles the creation of `CorvusUser`s
            UsersEndpoint()
            
            // The login route provided by Corvus that delivers `CorvusToken`s
            Login<CorvusToken>("login")
            
            // This group is authenticated using a bearer token based Authentication
            BearerAuthGroup<CorvusToken> {
                AccountsEndpoint()
                TransactionsEndpoint()
            }
        }
    }
}
