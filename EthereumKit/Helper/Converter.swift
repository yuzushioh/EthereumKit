//
//  Converter.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/08.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import SMP

public final class Converter {
    private static let etherUnit = BInt(number: "1000000000000000000", withBase: 10)!
    
    public static func toEther(wei: BInt) -> BDouble {
        return BDouble(wei, over: etherUnit)
    }
    
    public static func toWei(ether: BDouble) -> BInt {
        return (ether * BDouble(etherUnit.description)!).rounded()
    }
}
