//
//  Gas.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/07.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public final class Gas {
    public enum GasPrice {
        case `default`, low, high, custom(GWei: Int)
        
        // Its unit is in GWei
        public var value: Int {
            switch self {
            case .default: return 41
            case .low: return 1
            case .high: return 99
            case .custom(let gwei): return gwei
            }
        }
    }
    
    public enum GasLimit {
        case `default`, low, high, custom(Int)
        
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
