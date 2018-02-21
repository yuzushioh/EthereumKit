//
//  SMP+Extensions.swift
//  EthereumKit
//
//  Created by Tomoya Hirano on 2018/02/22.
//  Copyright © 2018年 yuzushioh. All rights reserved.
//

import UIKit

// https://github.com/mkrd/Swift-Big-Integer/pull/24
extension BInt {
  public static func make(_ str: String, radix: Int) -> BInt? {
    let bint16 = BInt(16)
    
    var total = BInt(0)
    var exp = BInt(1)
    
    for c in str.reversed() {
      let int = Int(String(c), radix: radix)
      if int != nil {
        let value =  BInt(int!)
        total = total + (value * exp)
        exp = exp * bint16
      } else {
        return nil
      }
    }
    return total
  }
}

extension String {
  func toHex() -> String {
    var hex = self
    while hex.first == "0" || hex.first == "x" {
      hex = String(hex.dropFirst())
    }
    return hex
  }
}
