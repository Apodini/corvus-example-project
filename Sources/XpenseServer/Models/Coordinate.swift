//
//  Coordinate.swift
//  Xpense Server
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: Coordinate
/// Represents a single point on earth, specified by latitude and longitude.
public struct Coordinate: Equatable {
    /// The latitude of the Coordinate
    var latitude: Double
    /// The longitude of the Coordinate
    var longitude: Double
    
    
    /// - Parameters:
    ///   - latitude: The latitude of the Coordinate
    ///   - longitude: The longitude of the Coordinate
    public init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


// MARK: Coordinate: Codable
extension Coordinate: Codable {}
