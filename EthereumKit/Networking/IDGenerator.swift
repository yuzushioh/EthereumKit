//
//  IDGenerator.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import JSONRPCKit

struct IDGenerator: JSONRPCKit.IdGenerator {
    
    private var currentIdentifier = 0
    
    mutating func next() -> Id {
        currentIdentifier += 1
        return .number(currentIdentifier)
    }
}
