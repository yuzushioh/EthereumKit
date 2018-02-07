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
