/// ERC20 contains necessary method to support ERC20 tokens
public struct ERC20 {
    
    /// Generate transaction data for ERC20 token
    ///
    /// - Parameter:
    ///    - address: which address to send
    ///    - amount: amount to send
    /// - Returns: transaction data
    public static func generateData(with address: String, amount: Decimal) -> Data {
        let transferSignature = Data(bytes: [0xa9, 0x05, 0x9c, 0xbb]).toHexString()
        let address = address.stripHexPrefix()
        let amount = (amount * 1e18).toHexString().withLeadingZero(until: 64)
        return Data(hex: transferSignature + "000000000000000000000000" + address + amount)
    }
}
