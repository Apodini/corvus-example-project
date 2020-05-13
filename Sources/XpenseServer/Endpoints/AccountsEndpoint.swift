//
//  AccountsEndpoint.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus


// MARK: AccountsEndpoint
/// The `Endpoint` that handles all the API interaction with `Accounts`
final class AccountsEndpoint: Endpoint {
    var content: Endpoint {
        Group("accounts") {
            CRUD<Account>()
                .auth(\.$user)
        }
    }
}
