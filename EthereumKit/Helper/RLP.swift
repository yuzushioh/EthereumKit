public struct RLP {
    public static func encode(_ element: Any) throws -> Data {
        let encoded: Data?
        
        switch element {
        case let list as [Any]:
            encoded = try encode(elements: list)
        
        case let bint as BInt:
            encoded = encode(bint: bint)
        
        case let int as Int:
            encoded = encode(bint: BInt(int))
        
        case let data as Data:
            encoded = encode(data: data)
            
        case let string as String:
            encoded = encode(string: string)
        
        default:
            encoded = nil
        }
        
        guard let data = encoded else {
            throw EthereumKitError.cryptoError(.failedToEncode(element))
        }
        
        return data
    }
    
    private static func encode(data: Data) -> Data {
        if data.count == 1 && data[0] <= 0x7f {
            return data
        }
        
        var encoded = encodeHeader(size: UInt64(data.count), smallTag: 0x80, largeTag: 0xb7)
        encoded.append(data)
        return encoded
    }
    
    private static func encode(string: String) -> Data? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return encode(data: data)
    }
    
    private static func encode(bint: BInt) -> Data? {
        let data = bint.serialize()
        if data.isEmpty {
            return Data(bytes: [0x80])
        }
        return encode(data: data)
    }
    
    private static func encode(elements: [Any]) throws -> Data? {
        var data = Data()
        for element in elements {
            data.append(try encode(element))
        }
        
        var encodedData = encodeHeader(size: UInt64(data.count), smallTag: 0xc0, largeTag: 0xf7)
        encodedData.append(data)
        return encodedData
    }
    
    private static func encodeHeader(size: UInt64, smallTag: UInt8, largeTag: UInt8) -> Data {
        if size < 56 {
            return Data([smallTag + UInt8(size)])
        }
        
        let sizeData = putint(size)
        var encoded = Data()
        encoded.append(largeTag + UInt8(sizeData.count))
        encoded.append(contentsOf: sizeData)
        return encoded
    }
    
    private static func putint(_ i: UInt64) -> Data {
        switch i {
        case 0 ..< (1 << 8):
            return Data([UInt8(i)])
        case 0 ..< (1 << 16):
            return Data([
                UInt8(i >> 8),
                UInt8(truncatingIfNeeded: i)
                ])
        case 0 ..< (1 << 24):
            return Data([
                UInt8(i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i)
                ])
        case 0 ..< (1 << 32):
            return Data([
                UInt8(i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i)
                ])
        case 0 ..< (1 << 40):
            return Data([
                UInt8(i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i)
                ])
        case 0 ..< (1 << 48):
            return Data([
                UInt8(i >> 40),
                UInt8(truncatingIfNeeded: i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i)
                ])
        case 0 ..< (1 << 56):
            return Data([
                UInt8(i >> 48),
                UInt8(truncatingIfNeeded: i >> 40),
                UInt8(truncatingIfNeeded: i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i)
                ])
        default:
            return Data([
                UInt8(i >> 56),
                UInt8(truncatingIfNeeded: i >> 48),
                UInt8(truncatingIfNeeded: i >> 40),
                UInt8(truncatingIfNeeded: i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i)
            ])
        }
    }
}
