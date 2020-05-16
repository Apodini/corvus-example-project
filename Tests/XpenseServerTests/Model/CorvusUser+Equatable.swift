//
//  CorvusUser+Equatable.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus


// MARK: CorvusUser + Equatable
extension CorvusUser: Equatable {
    public static func == (lhs: CorvusUser, rhs: CorvusUser) -> Bool {
        lhs.username == rhs.username
            && lhs.id == rhs.id
            && lhs.password == rhs.password
    }
}
