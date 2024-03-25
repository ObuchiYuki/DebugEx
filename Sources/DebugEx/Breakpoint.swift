//
//  File.swift
//  
//
//  Created by yuki on 2023/12/24.
//

import Foundation

@inlinable @inline(__always) @_transparent
public func __breakpoint() {
    #if DEBUG
    print("[breakpoint]")
    raise(SIGTRAP)
    #endif
}

@inlinable @inline(__always) @_transparent
public func __breakpoint(_ message: String) {
    #if DEBUG
    print(message)
    raise(SIGTRAP)
    #endif
}


