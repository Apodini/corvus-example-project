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
    let parameter = Parameter<Account>()
    
    var content: Endpoint {
        Group("accounts") {
            Create<Account>().auth(\.$user)
            ReadAll<Account>().auth(\.$user)
            
            Group(parameter.id) {
                ReadOne<Account>(parameter.id).auth(\.$user)
                Update<Account>(parameter.id).auth(\.$user)
                Delete<Account>(parameter.id).auth(\.$user)
            }
        }
    }
}
