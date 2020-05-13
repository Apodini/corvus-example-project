//
//  Transaction+Equatable.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

@testable import XpenseServer
import XCTest


// MARK: Transaction + Equatable
extension Transaction: Equatable {
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.id == rhs.id
            && lhs.amount == rhs.amount
            && lhs.description == rhs.description
            && lhs.date.timeIntervalSinceReferenceDate - rhs.date.timeIntervalSinceReferenceDate < 1.0
            && lhs.$account.id == rhs.$account.id
            && lhs.location == rhs.location
    }
    
    func xctAssertEqualWithoutId(_ transaction: Transaction) {
        XCTAssertEqual(self.amount, transaction.amount)
        XCTAssertEqual(self.description, transaction.description)
        XCTAssertEqual(self.date.timeIntervalSinceReferenceDate, transaction.date.timeIntervalSinceReferenceDate, accuracy: 1)
        XCTAssertEqual(self.location, transaction.location)
        XCTAssertEqual(self.$account.id, transaction.$account.id)
    }
}
