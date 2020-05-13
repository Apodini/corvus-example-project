//
//  TransactionsEndpoint.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus


// MARK: TransactionsEndpoint
/// The `Endpoint` that handles all the API interaction with `Transaction`s
final class TransactionsEndpoint: Endpoint {
    /// The `Parameter` used to identify `Transaction`s in the /api/accounts/ `Group`
    private let transactionParameter = Parameter<Transaction>()
    
    
    var content: Endpoint {
        Group("transactions") {
            Create<Transaction>()
            ReadAll<Transaction>().auth(\.$account, \.$user)
            
            // Access to individual Transactions
            Group(transactionParameter.id) {
                Update<Transaction>(transactionParameter.id)
                    .auth(\.$account, \.$user)
                Delete<Transaction>(transactionParameter.id)
                    .auth(\.$account, \.$user)
            }
        }
    }
}
