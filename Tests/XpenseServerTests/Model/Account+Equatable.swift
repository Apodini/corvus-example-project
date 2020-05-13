//
//  Account+Equatable.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

@testable import XpenseServer


// MARK: Account + Equatable
extension Account: Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.$user.id == rhs.$user.id
    }
}
