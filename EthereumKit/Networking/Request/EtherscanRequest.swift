//
//  EtherscanRequest.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/19.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import APIKit

public struct EtherscanRequest<Request: EtherscanRequestType>: APIKit.Request {
    
    public typealias Response = Request.Response
    
    private let baseRequest: Request
    private let network: Network
    
    public init(_ baseRequest: Request, network: Network) {
        self.baseRequest = baseRequest
        self.network = network
    }
    
    public var baseURL: URL {
        return NetworkEnvironment(network: network).etherscanURL
    }
    
    public var method: HTTPMethod {
        return baseRequest.method
    }
    
    public var path: String {
        return "/api"
    }
    
    public var parameters: Any? {
        var parameters: [String: Any] = [:]
        if let originalParameters = baseRequest.parameters as? [String: Any] {
            parameters = originalParameters
        }
        parameters["apikey"] = "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7"
        return parameters
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Request.Response {
        return try baseRequest.response(from: object, urlResponse: urlResponse)
    }
}
