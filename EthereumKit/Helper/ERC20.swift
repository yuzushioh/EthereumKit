import CryptoSwift

/// ERC20 contains necessary method to support ERC20 tokens
public struct ERC20 {
    
    /// Transfer method signiture
    /// function transfer(address _to, uint256 _value) returns (bool success)
    private static var transferSigniture: Data {
        let method = "transfer(address,uint256)"
        return method.data(using: .ascii)!.sha3(.keccak256)[0...3]
    }
    
    /// Length of 256 bits
    private static var lengthOf256bits: Int {
        return 256 / 4
    }
    
    /// Generate transaction data for ERC20 token
    ///
    /// - Parameter:
    ///    - address: which address to send
    ///    - amount: amount to send
    /// - Returns: transaction data
    public static func generateData(with address: String, amount: String, decimal: Int) throws -> Data {
        let method = transferSigniture.toHexString()
        let address = pad(string: address.stripHexPrefix())
        
        let poweredAmount = try power(amount: amount, decimal: decimal)
        let amount = pad(string: poweredAmount.serialize().toHexString())
        
        return Data(hex: method + address + amount)
    }
    
    /// Power the amount by the decimal
    ///
    /// - Parameter:
    ///    - amount: amount in string format
    ///    - decimal: specified decimal of this erc20 token
    /// - Returns: BigInt value powered by (10 * decimal)
    private static func power(amount: String, decimal: Int) throws -> BInt {
        let components = amount.split(separator: ".")
        
        // components.count must be 1 or 2. this method accepts only integer or decimal value
        // like 1, 10, 100 or 1.15, 10.7777, 19.9999
        guard components.count == 1 || components.count == 2 else {
            throw EthereumKitError.contractError(.containsInvalidCharactor(amount))
        }
        
        guard let integer = BInt(String(components[0]), radix: 10) else {
            throw EthereumKitError.contractError(.containsInvalidCharactor(amount))
        }
        
        let poweredInteger = integer * (BInt(10) ** decimal)
        
        if components.count == 2 {
            let count = components[1].count
            
            guard count <= decimal else {
                throw EthereumKitError.contractError(.invalidDecimalValue(amount))
            }
            
            guard let digit = BInt(String(components[1]), radix: 10) else {
                throw EthereumKitError.contractError(.containsInvalidCharactor(amount))
            }
            
            let poweredDigit = digit * (BInt(10) ** (decimal - count))
            return poweredInteger + poweredDigit
        } else {
            return poweredInteger
        }
    }
    
    /// Pad left spaces out of 256bits with 0
    private static func pad(string: String) -> String {
        var string = string
        while string.count != lengthOf256bits {
            string = "0" + string
        }
        return string
    }
}
