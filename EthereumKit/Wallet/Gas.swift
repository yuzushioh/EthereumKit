//
//  Gas.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/07.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public final class Gas {
    public enum GasPrice {
        case `default`
        case low
        case high
        case custom(Int)
        
        public var value: Int {
            switch self {
            case .default:
                return 41000000000
            case .low:
                return 1000000000
            case .high:
                return 99000000000
            case .custom(let price):
                return price
            }
        }
    }
    
    public enum GasLimit {
        case `default`
        case low
        case high
        case custom(Int)
        
        public var value: Int {
            return 21000
        }
    }
    
    internal static var price: GasPrice = GasPrice.default
    internal static var limit: GasLimit = GasLimit.default
    
    public static func setGasPirce(_ gasPrice: GasPrice) {
        self.price = gasPrice
    }
    
    public static func setGasLimit(_ gasLimit: GasLimit) {
        self.limit = gasLimit
    }
}
