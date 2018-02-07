//
//  Data+Extension.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import Foundation
import CryptoSwift

extension Data {
    var toBits: [String] {
        var bitArray = [String]()
        for byte in bytes {
            bitArray.append(contentsOf: byte.bits)
        }
        return bitArray
    }
    
    var bytes: [UInt8] {
        return Array(self)
    }
}
