//
//  ByteBuffer+Encodable.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Vapor


// MARK: Encodable + + JSONEncoder + ByteBuffer
extension Encodable {
    func encode(
        _ encoder: JSONEncoder = JSONEncoder(),
        _ allocator: ByteBufferAllocator = .init()) throws -> ByteBuffer {
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encodeAsByteBuffer(self, allocator: allocator)
    }
}
