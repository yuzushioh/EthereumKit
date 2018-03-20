// Online Converter: https://etherconverter.online
public typealias Ether = BDouble
public typealias Wei = BInt

extension Wei {
    public init?(hex: String) {
        self.init(hex, radix: 16)
    }
}

public final class Converter {
    private static let etherInWei = Wei(number: "1000000000000000000", withBase: 10)!
    
    public static func toEther(wei: Wei) -> Ether {
        return Ether(wei, over: etherInWei)
    }
    
    public static func toWei(ether: Ether) -> Wei {
        return (ether * Ether(etherInWei.description)!).rounded()
    }
    
    // Only used for calcurating gas price and gas limit.
    public static func toWei(GWei: Int) -> Int {
        return GWei * 1000000000
    }
}
