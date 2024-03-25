//
//  Measure.swift
//  CoreUtil
//
//  Created by yuki on 2020/03/22.
//  Copyright © 2020 yuki. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public func __warn_ifDebug(_ message: Any = "Error") {
    #if DEBUG
    print(message)
    #endif
}

public func __breakpoint_ifDebug(_ message: Any, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
    print(message)
    print("file: \(file), line: \(line).")
    raise(SIGTRAP)
    #endif
}

#if canImport(AppKit)
/// デバッグ時のみmessageを出力する。
public func __warn_ifDebug_beep_otherwise(_ message: Any = "waning", file: StaticString = #fileID, function: StaticString = #function) {
    #if DEBUG
    print(message, "\(file) \(function).")
    #endif
    NSSound.beep()
}
#endif

#if DEBUG
public let __TEST_IS_RUNNING = NSClassFromString("XCTest") != nil
public let __IS_DEBUG = true
#else
public let __TEST_IS_RUNNING = false
public let __IS_DEBUG = false
#endif

public func __fatalError_ifDebug(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
    fatalError(message(), file: file, line: line)
    #endif
}

public func __objc_getMethodsList<T: NSObject>(_ type: T.Type) -> [Selector] {
    var count: UInt32 = 0
    let methods = class_copyMethodList(T.self, &count)!
    var selectors = [Selector]()
    
    for i in 0..<Int(count) {
        let selector = method_getName(methods[i])
        selectors.append(selector)
    }
    return selectors
}
