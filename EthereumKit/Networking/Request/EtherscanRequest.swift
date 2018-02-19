//
//  EtherscanRequest.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/19.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import APIKit

public protocol EtherscanRequest: APIKit.Request {
    var network: Network { get }
}

extension EtherscanRequest {
    // Override in HTTPRequest
    public var network: Network {
        return .test
    }
    
    // Override in HTTPRequest
    public var baseURL: URL {
        return NetworkEnvironment(network: network).etherscanURL
    }
    
    public var path: String {
        return "/api"
    }
    
    public var method: HTTPMethod {
        return .get
    }
}

extension EtherscanRequest where Response == Any {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return object
    }
}
