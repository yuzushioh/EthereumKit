/// Represents a balance
public struct Balance {
    
    /// User's balance in wei unit
    public let wei: Wei
    
    /// User's balance in ether unit
    public func ether() throws -> Ether {
        return try Converter.toEther(wei: wei)
    }
    
    public init(wei: Wei) {
        self.wei = wei
    }
}

extension Balance: Codable {
    private enum CodingKeys: String, CodingKey {
        case wei
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        wei = try container.decode(Wei.self, forKey: .wei)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wei, forKey: .wei)
    }
}
