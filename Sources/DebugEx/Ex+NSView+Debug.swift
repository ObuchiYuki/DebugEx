//
//  NSView+Debug+Ex.swift
//  CoreUtil
//
//  Created by yuki on 2021/07/22.
//  Copyright © 2021 yuki. All rights reserved.
//

#if canImport(AppKit)
import AppKit

public let NSOutlineViewNotificationItemKey = "NSObject"

extension NSView {
    #if DEBUG
    public func __setBackgroundColor(_ color: NSColor) {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
    }
    #endif
}
#endif
