/// RawTransaction constructs necessary information to publish transaction.
public struct RawTransaction {
    
    /// Amount value to send, unit is in Wei
    public let value: Wei
    
    /// Address to send ether to
    public let to: Address
    
    /// Gas price for this transaction, unit is in Wei
    /// you need to convert it if it is specified in GWei
    /// use Converter.toWei method to convert GWei value to Wei
    public let gasPrice: Int
    
    /// Gas limit for this transaction
    /// Total amount of gas will be (gas price * gas limit)
    public let gasLimit: Int
    
    /// Nonce of your address
    public let nonce: Int
    
    /// Data to attach to this transaction
    public let data: Data
}

extension RawTransaction {
    public init(value: Wei, to: Address, gasPrice: Int, gasLimit: Int, nonce: Int) {
        self.value = value
        self.to = to
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.nonce = nonce
        self.data = Data()
    }
    
    public init(wei: String, to: String, gasPrice: Int, gasLimit: Int, nonce: Int, data: Data = Data()) {
        self.value = Wei(wei)!
        self.to = Address(string: to)
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.nonce = nonce
        self.data = data
    }
    
    public init(ether: String, to: String, gasPrice: Int, gasLimit: Int, nonce: Int, data: Data = Data()) {
        self.init(wei: Converter.toWei(ether: Ether(ether)!).description, to: to, gasPrice: gasPrice, gasLimit: gasLimit, nonce: nonce, data: data)
    }
}

extension RawTransaction: Codable {
    private enum CodingKeys: String, CodingKey {
        case value
        case to
        case gasPrice
        case gasLimit
        case nonce
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Wei.self, forKey: .value)
        to = try container.decode(Address.self, forKey: .to)
        gasPrice = try container.decode(Int.self, forKey: .gasPrice)
        gasLimit = try container.decode(Int.self, forKey: .gasLimit)
        nonce = try container.decode(Int.self, forKey: .nonce)
        data = try container.decode(Data.self, forKey: .data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(to, forKey: .to)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(data, forKey: .data)
    }
}
