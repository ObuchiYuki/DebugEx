//
//  Backtrace.swift
//  RCBackTrace
//
//  Created by roy.cao on 2019/8/27.
//  Copyright © 2019 roy. All rights reserved.
//

import Foundation

public struct Backtrace {
    public let symbols: [Symbol]
    
    @inlinable init(symbols: [Symbol]) {
        self.symbols = symbols
    }

    @inline(never)
    public init(skipFirst: Int = 1) {
        var addresses = Thread.callStackReturnAddresses
        addresses.removeFirst(skipFirst)
        self.symbols = addresses.map{ Symbol(address: $0.uintValue) }
    }
    
    @inlinable public subscript<Range: RangeExpression>(range: Range) -> Backtrace where Range.Bound == Int {
        Backtrace(symbols: Array(self.symbols[range]))
    }
}

extension Backtrace: CustomStringConvertible {
    @inlinable public var description: String {
        self.description()
    }
    
    @inlinable public func description(options: Symbol.FormatOptions = .default) -> String {
        self.symbols.enumerated().map{ $1.description(index: $0, options: options) }.joined(separator: "\n")
    }
}

extension Backtrace {
    public struct Symbol {
        public let symbol: String
        public let file: String
        public let address: UInt
        public let image: String
        public let offset: Int
    }
}

extension Backtrace.Symbol {
    @inlinable init(address: UInt) {
        var info = dl_info()
        dladdr(UnsafeRawPointer(bitPattern: address), &info)

        let dsymbol = Backtrace.Symbol._getSymbolName(info: info)
        
        self.symbol = Backtrace.Symbol._demangle(dsymbol)
        self.file = String(cString: info.dli_fname)
        self.address = address
        self.image = Backtrace.Symbol._getImageName(info: info)
        self.offset = Backtrace.Symbol._getOffset(info: info, address: address)
    }
    
    @inlinable static func _demangle(_ mangledName: String) -> String {
        mangledName.utf8CString.withUnsafeBufferPointer { str in
            guard let namePtr = self._demangle(mangledName: str.baseAddress, length: UInt(str.count-1)) else {
                return mangledName
            }
            defer { namePtr.deallocate() }
            return String(cString: namePtr)
        }
    }
    
    @_silgen_name("swift_demangle")
    @inlinable static func _demangle(
        mangledName: UnsafePointer<CChar>?, length: UInt, _: Int? = nil, _: Int? = nil, _: UInt32 = 0
    ) -> UnsafePointer<CChar>?

    @inlinable static func _getImageName(info: dl_info) -> String {
        if let dli_fname = info.dli_fname, let fname = String(validatingUTF8: dli_fname), let _ = fname.range(of: "/", options: .backwards, range: nil, locale: nil) {
            return (fname as NSString).lastPathComponent
        } else {
            return "???"
        }
    }

    @inlinable static func _getSymbolName(info: dl_info) -> String {
        if let dli_sname = info.dli_sname, let sname = String(validatingUTF8: dli_sname) {
            return sname
        } else if let dli_fname = info.dli_fname, let _ = String(validatingUTF8: dli_fname) {
            return self._getImageName(info: info)
        } else {
            return String(format: "0x%1x", UInt(bitPattern: info.dli_saddr))
        }
    }

    @inlinable static func _getOffset(info: dl_info, address: UInt) -> Int {
        if let dli_sname = info.dli_sname, let _ = String(validatingUTF8: dli_sname) {
            return Int(address - UInt(bitPattern: info.dli_saddr))
        } else if let dli_fname = info.dli_fname, let _ = String(validatingUTF8: dli_fname) {
            return Int(address - UInt(bitPattern: info.dli_fbase))
        } else {
            return Int(address - UInt(bitPattern: info.dli_saddr))
        }
    }
}

extension Backtrace.Symbol: CustomStringConvertible {
    public struct FormatOptions: OptionSet {
        public var rawValue: Int
        
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let index =   FormatOptions(rawValue: 1 << 0)
        public static let file =    FormatOptions(rawValue: 1 << 1)
        public static let image =   FormatOptions(rawValue: 1 << 2)
        public static let address = FormatOptions(rawValue: 1 << 3)
        public static let symbol =  FormatOptions(rawValue: 1 << 4)
        public static let offset =  FormatOptions(rawValue: 1 << 5)
        public static let minimum: Self = [.index, .symbol]
        public static let `default`: Self = [.index, .image, .symbol]
    }
    
    @inlinable public var description: String {
        self.description(index: nil)
    }
    
    @inlinable public func description(index: Int?, options: FormatOptions = .default) -> String {
        var result = ""
        
        if let index = index, options.contains(.index) {
            result += "\(index)".padding(toLength: 3, withPad: " ", startingAt: 0)
            result += " "
        }
        if options.contains(.file) {
            result += "'\(self.file)'\n"
        }
        if options.contains(.image) {
            result += "\(self.image)".padding(toLength: 32, withPad: " ", startingAt: 0)
            result += " "
        }
        if options.contains(.address) {
            result += String(format: "0x%016llx", self.address)
            result += " "
        }
        if options.contains(.symbol) {
            result += self.symbol.replacingOccurrences(of: "Swift.", with: "")
            result += " "
        }
        if options.contains(.offset) {
            result += "+ \(self.offset)"
            result += " "
        }
        
        return result
    }
}
