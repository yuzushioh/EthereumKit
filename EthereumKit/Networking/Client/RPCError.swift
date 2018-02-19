//
//  RPCError.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import APIKit

// TODO: Handle jsonrpc error
public enum RPCError: Error {
    case connectionError(Error)
    case systemError(Error)
    
    init(_ error: Error) {
        switch error {
        case SessionTaskError.connectionError(let error):
            self = .connectionError(error)
            
        default:
            self = .systemError(error)
        }
    }
}
