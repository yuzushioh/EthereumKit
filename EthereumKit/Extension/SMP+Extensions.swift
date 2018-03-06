//
//  SMP+Extensions.swift
//  EthereumKit
//
//  Created by Tomoya Hirano on 2018/02/22.
//  Copyright © 2018年 yuzushioh. All rights reserved.
//

import UIKit
import SMP

// https://github.com/mkrd/Swift-Big-Integer/pull/24
// TODO: use init(_:, radix:) in SMP but need to fix bugs
extension BInt {
  internal init?(str: String, radix: Int) {
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
