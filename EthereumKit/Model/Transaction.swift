/// Represents transaction
public struct Transaction {
    
    /// Blockhash of the block which includes this tx
    public let blockHash: String
    
    /// Block number of the block which includes this tx
    public let blockNumber: String
    
    /// Tx id
    public let hash: String
    
    /// Input value of this tx
    public let input: String
    
    /// Confirmations which this tx has
    public let confirmations: String
    
    /// Nonce of this tx
    public let nonce: String
    
    /// Timestamp of this tx
    public let timeStamp: String
    
    /// Contract address if exists
    public let contractAddress: String
    
    /// Sender of this tx
    public let from: String
    
    /// Receiver of this tx
    public let to: String
    
    /// Gas limit
    public let gas: String
    
    /// Gas price in wei
    public let gasPrice: String
    
    /// Gas actually used in tx
    public let gasUsed: String
    
    /// Remained gas
    public let cumulativeGasUsed: String
    
    /// Whether any error occured during broadcasting
    public let isError: String
    
    /// Index of this transaction
    public let transactionIndex: String
    
    ///
    public let txReceiptStatus: String
    
    /// Value of this tx, unit of wei
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

/// Represents an array of transactions
public struct Transactions {
    
    // Transactions
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
