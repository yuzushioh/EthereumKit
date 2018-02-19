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
