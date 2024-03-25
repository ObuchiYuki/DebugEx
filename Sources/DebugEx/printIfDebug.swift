//
//  printIfDebug.swift
//  CoreUtil
//
//  Created by yuki on 2021/11/13.
//  Copyright © 2021 yuki. All rights reserved.
//

@inlinable public func printIfDebug(_ item: @autoclosure () -> Any) {
    #if DEBUG
    print(item())
    #endif
}

@inlinable public func printIfDebug(_ item1: @autoclosure () -> Any, _ item2: @autoclosure () -> Any) {
    #if DEBUG
    print(item1(), item2())
    #endif
}

@inlinable public func printIfDebug(_ item1: @autoclosure () -> Any, _ item2: @autoclosure () -> Any, _ item3: @autoclosure () -> Any) {
    #if DEBUG
    print(item1(), item2(), item3())
    #endif
}

@inlinable public func printIfDebug(_ item1: @autoclosure () -> Any, _ item2: @autoclosure () -> Any, _ item3: @autoclosure () -> Any, _ item4: @autoclosure () -> Any) {
    #if DEBUG
    print(item1(), item2(), item3(), item4())
    #endif
}

@inlinable public func printIfDebug(_ item1: @autoclosure () -> Any, _ item2: @autoclosure () -> Any, _ item3: @autoclosure () -> Any, _ item4: @autoclosure () -> Any, _ item5: @autoclosure () -> Any) {
    #if DEBUG
    print(item1(), item2(), item3(), item4(), item5())
    #endif
}
