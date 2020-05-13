//
//  LinuxMain.swift
//  Xpense Server Tests
//
//  Created by Paul Schmiedmayer on 04/03/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

// A LinuxMain.swift file is no longer needed since `swift test --enable-test-discovery` is possible
// Provide an error message when testing on Linux with no automatic test discovery
#error("""
  -----------------------------------------------------
  Please test with `swift test --enable-test-discovery`
  -----------------------------------------------------
  """)
