//
//  SMP+Extensions.swift
//  EthereumKit
//
//  Created by Tomoya Hirano on 2018/02/22.
//  Copyright © 2018年 yuzushioh. All rights reserved.
//

import UIKit
import BigNumber_iOS

// https://github.com/mkrd/Swift-Big-Integer/pull/24
extension BInt {
  internal init?(_ str: String, radix: Int) {
    self.init(0)
    let bint16 = BInt(16)
    
    var exp = BInt(1)
    
    for c in str.reversed() {
      let int = Int(String(c), radix: radix)
      if int != nil {
        let value = BInt(int!)
        self = self + (value * exp)
        exp = exp * bint16
      } else {
        return nil
      }
    }
  }
}

extension String {
  internal var hex: String {
    var hex = self
    while hex.first == "0" || hex.first == "x" {
      hex = String(hex.dropFirst())
    }
    return hex
  }
}
