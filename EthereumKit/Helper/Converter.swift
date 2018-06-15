// Online Converter: https://etherconverter.online
public typealias Ether = Decimal
public typealias Wei = BInt

extension Wei {
    public init?(hex: String) {
        self.init(hex, radix: 16)
    }
}

public final class Converter {
    private static let etherInWei = Decimal(1000000000000000000)
    
    public static func toEther(wei: Wei) -> Ether {
        guard let decimalWei = Decimal(string: wei.description)else {
            fatalError("Failed to convert Wei to Ether")
        }
        return decimalWei / etherInWei
    }
    
    public static func toWei(ether: Ether) -> Wei {
        guard let wei = Wei((ether * etherInWei).description) else {
            fatalError("Faied to convert Ether to Wei")
        }
        return wei
    }
    
    // Only used for calcurating gas price and gas limit.
    public static func toWei(GWei: Int) -> Int {
        return GWei * 1000000000
    }
}
