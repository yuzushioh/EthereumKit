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

public struct Transaction: Decodable {
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
    public let txreceipt_status: String
    public let value: String
    
    public var balance: Balance {
        return Balance(wei: BInt(number: value, withBase: 10)!)
    }
}

public struct Transactions: Decodable {
    public let elements: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case elements = "result"
    }
}

extension SignTransaction {
    internal init(value: Wei, to: Address, nonce: Int, gasPrice: Int, gasLimit: Int, data: Data) {
        self.value = value
        self.to = to
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.data = data
    }
}
