//
//  String+Extension.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

extension String {
    var mnemonicData: Data {
        var mnemonicData = Data(capacity: count / 2)
        var index = 0
        var charactors = ""
        
        forEach { charactor in
            charactors += String(charactor)
            if index % 2 == 1 {
                let i = UInt8(strtoul(charactors, nil, 16))
                mnemonicData.append(i)
                charactors = ""
            }
            index += 1
        }
        
        return mnemonicData
    }
    
    var bytes: [UInt8] {
        return data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? []
    }
}
