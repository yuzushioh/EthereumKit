/// Represents an address
public struct Address {
    
    /// Address in data format
    public let data: Data
    
    /// Address in string format, EIP55 encoded
    public let string: String
    
    public init(data: Data) {
        self.data = data
        self.string = "0x" + EIP55.encode(data)
    }
    
    public init(string: String) {
        self.data = Data(hex: string.stripHexPrefix())
        self.string = string
    }
}

extension Address: Codable {
    private enum CodingKeys: String, CodingKey {
        case data
        case string
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Data.self, forKey: .data)
        string = try container.decode(String.self, forKey: .string)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(string, forKey: .string)
    }
}
