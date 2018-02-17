//
//  RPCError.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public enum RPCError: Error {
    case hoge
    
    init(_ error: Error) {
        self = .hoge
    }
}
