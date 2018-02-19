//
//  EtherscanRequestType.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/20.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import APIKit

public protocol EtherscanRequestType {
    associatedtype Response
    var method: HTTPMethod { get }
    var parameters: Any? { get }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response
}

extension EtherscanRequestType where Response: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
