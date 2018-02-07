//
//  UInt32.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh.
//

import Foundation

extension UInt32 {
    var toHexData: Data {
        var v = byteSwapped
        return Data(bytes: &v, count: MemoryLayout<UInt32>.size)
    }
}

// NOTE: Copied from CryptoSwift/UInt32+Extension.swift
extension UInt32 {
    @_specialize(exported: true, where T == ArraySlice<UInt8>)
    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.Index == Int {
        self = UInt32(bytes: bytes, fromIndex: bytes.startIndex)
    }
    
    @_specialize(exported: true, where T == ArraySlice<UInt8>)
    init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Iterator.Element == UInt8, T.Index == Int {
        let val0 = UInt32(bytes[index.advanced(by: 0)]) << 24
        let val1 = UInt32(bytes[index.advanced(by: 1)]) << 16
        let val2 = UInt32(bytes[index.advanced(by: 2)]) << 8
        let val3 = UInt32(bytes[index.advanced(by: 3)])
        
        self = val0 | val1 | val2 | val3
    }
}
