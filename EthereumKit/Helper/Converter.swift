// Online Converter: https://etherconverter.online
public typealias Ether = Decimal
public typealias Wei = BInt

public final class Converter {
    
    // NOTE: calculate wei by 10^18
    private static let etherInWei = pow(Decimal(10), 18)
    
    /// Convert Wei(BInt) unit to Ether(Decimal) unit
    public static func toEther(wei: Wei) throws -> Ether {
        guard let decimalWei = Decimal(string: wei.description) else {
            throw EthereumKitError.convertError(.failedToConvert(wei.description))
        }
        return decimalWei / etherInWei
    }
    
    /// Convert Ether(Decimal) unit to Wei(BInt) unit
    public static func toWei(ether: Ether) throws -> Wei {
        guard let wei = Wei((ether * etherInWei).description) else {
            throw EthereumKitError.convertError(.failedToConvert(ether * etherInWei))
        }
        return wei
    }
    
    /// Convert Ether(String) unit to Wei(BInt) unit
    public static func toWei(ether: String) throws -> Wei {
        guard let decimalEther = Decimal(string: ether) else {
            throw EthereumKitError.convertError(.failedToConvert(ether))
        }
        return try toWei(ether: decimalEther)
    }
    
    // Only used for calcurating gas price and gas limit.
    public static func toWei(GWei: Int) -> Int {
        return GWei * 1000000000
    }
}
