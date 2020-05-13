//
//  CorvusToken+Equatable.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Corvus


// MARK: CorvusToken + Equatable
extension CorvusToken: Equatable {
    public static func == (lhs: CorvusToken, rhs: CorvusToken) -> Bool {
        lhs.id == rhs.id
            && lhs.value == rhs.value
            && lhs.$user.id == rhs.$user.id
            && lhs.isValid == rhs.isValid
    }
}
