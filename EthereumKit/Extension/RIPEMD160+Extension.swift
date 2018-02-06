//
//  RIPEMD160+Extension.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/04.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension RIPEMD160 {
    static func hash(message: Data) -> Data {
        var md = RIPEMD160()
        md.update(data: message)
        return md.finalize()
    }
}
