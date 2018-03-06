//
//  String+Extension.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension String {
    public var hex: String {
        var hex = self
        while hex.first == "0" || hex.first == "x" {
            hex = String(hex.dropFirst())
        }
        return hex
    }
    
    public var appending0xPrefix: String {
        return "0x".appending(self)
    }
}
