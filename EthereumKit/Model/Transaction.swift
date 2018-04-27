public struct RawTransaction {
    public let value: Wei
    public let to: Address
    public let nonce: Int
    public let data: Data
    
    public static func create(wei: String, address: String, nonce: Int, data: Data = Data()) -> RawTransaction {
        return RawTransaction(wei: wei, address: address, nonce: nonce, data: data)
    }
    
    public static func create(ether: String, address: String, nonce: Int, data: Data = Data()) -> RawTransaction {
        return RawTransaction(ether: ether, address: address, nonce: nonce, data: data)
    }
}

extension RawTransaction {
    internal init(wei: String, address: String, nonce: Int, data: Data) {
        self.value = Wei(wei)!
        self.to = Address(string: address)
        self.nonce = nonce
        self.data = data
    }
    
    internal init(ether: String, address: String, nonce: Int, data: Data) {
        self.init(wei: Converter.toWei(ether: Ether(ether)!).description, address: address, nonce: nonce, data: data)
    }
}

public struct SignTransaction {
    public let value: Wei
    public let to: Address
    public let nonce: Int
    public let gasPrice: Int
    public let gasLimit: Int
    public let data: Data
}

extension SignTransaction {
    public init(rawTransaction: RawTransaction, gasPrice: Int, gasLimit: Int) {
        self.value = rawTransaction.value
        self.to = rawTransaction.to
        self.nonce = rawTransaction.nonce
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.data = rawTransaction.data
    }
}

public struct SentTransaction {
    public let id: String
}

public struct Transaction {
    public let blockHash: String
    public let blockNumber: String
    public let hash: String
    public let input: String
    public let confirmations: String
    public let nonce: String
    public let timeStamp: String
    public let contractAddress: String
    public let from: String
    public let to: String
    public let gas: String
    public let gasPrice: String
    public let gasUsed: String
    public let cumulativeGasUsed: String
    public let isError: String
    public let transactionIndex: String
    public let txReceiptStatus: String
    public let value: String
    
    public var balance: Balance {
        return Balance(wei: BInt(number: value, withBase: 10)!)
    }
}

extension Transaction: Codable {
    private enum CodingKeys: String, CodingKey {
        case blockHash
        case blockNumber
        case hash
        case input
        case confirmations
        case nonce
        case timeStamp
        case contractAddress
        case from
        case to
        case gas
        case gasPrice
        case gasUsed
        case cumulativeGasUsed
        case isError
        case transactionIndex
        case txReceiptStatus = "txreceipt_status"
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockHash = try container.decode(String.self, forKey: .blockHash)
        blockNumber = try container.decode(String.self, forKey: .blockNumber)
        hash = try container.decode(String.self, forKey: .hash)
        input = try container.decode(String.self, forKey: .input)
        confirmations = try container.decode(String.self, forKey: .confirmations)
        nonce = try container.decode(String.self, forKey: .nonce)
        timeStamp = try container.decode(String.self, forKey: .timeStamp)
        contractAddress = try container.decode(String.self, forKey: .contractAddress)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        gas = try container.decode(String.self, forKey: .gas)
        gasPrice = try container.decode(String.self, forKey: .gasPrice)
        gasUsed = try container.decode(String.self, forKey: .gasUsed)
        cumulativeGasUsed = try container.decode(String.self, forKey: .cumulativeGasUsed)
        isError = try container.decode(String.self, forKey: .isError)
        transactionIndex = try container.decode(String.self, forKey: .transactionIndex)
        txReceiptStatus = try container.decode(String.self, forKey: .txReceiptStatus)
        value = try container.decode(String.self, forKey: .value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(blockHash, forKey: .blockHash)
        try container.encode(blockNumber, forKey: .blockNumber)
        try container.encode(hash, forKey: .hash)
        try container.encode(input, forKey: .input)
        try container.encode(confirmations, forKey: .confirmations)
        try container.encode(nonce, forKey: .nonce)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(contractAddress, forKey: .contractAddress)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(gas, forKey: .gas)
        try container.encode(gasPrice, forKey: .gasPrice)
        try container.encode(gasUsed, forKey: .gasUsed)
        try container.encode(cumulativeGasUsed, forKey: .cumulativeGasUsed)
        try container.encode(isError, forKey: .isError)
        try container.encode(transactionIndex, forKey: .transactionIndex)
        try container.encode(txReceiptStatus, forKey: .txReceiptStatus)
        try container.encode(value, forKey: .value)
    }
}

public struct Transactions {
    public let elements: [Transaction]
}

extension Transactions: Codable {
    private enum CodingKeys: String, CodingKey {
        case elements = "result"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        elements = try container.decode([Transaction].self, forKey: .elements)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(elements, forKey: .elements)
    }
}
