//
//  Gas.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/07.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public final class Gas {
    public enum GasPrice {
        case normal, low, high, custom(GWei: Int)
        
        // Its unit is in GWei
        public var value: Int {
            switch self {
            case .normal: return 41
            case .low: return 1
            case .high: return 99
            case .custom(let gwei): return gwei
            }
        }
    }
    
    public enum GasLimit {
        case normal, low, high, custom(Int)
        
        public var value: Int {
            return 21000
        }
    }
    
    public static var price: GasPrice = GasPrice.normal
    public static var limit: GasLimit = GasLimit.normal
    
    public static func setGasPirce(_ gasPrice: GasPrice) {
        self.price = gasPrice
    }
    
    public static func setGasLimit(_ gasLimit: GasLimit) {
        self.limit = gasLimit
    }
}
