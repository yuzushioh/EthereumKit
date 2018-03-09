import Foundation
import SMP

public struct Balance {
    public let wei: Wei
    
    public var ether: Ether {
        return Converter.toEther(wei: wei)
    }
}
