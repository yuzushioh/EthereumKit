public final class Etherscan {
    public struct GetTransactions: EtherscanRequestType {
        public typealias Response = Transactions
        
        public enum Sort: String {
            case asc, des
        }
        
        public let address: Address
        public let sort: Sort
        public let startBlock: Int64
        public let endBlock: Int64
        
        public init(address: Address, sort: Sort = .asc, startBlock: Int64 = 0, endBlock: Int64 = 99999999) {
            self.address = address
            self.sort = sort
            self.startBlock = startBlock
            self.endBlock = endBlock
        }
        
        public var method: Method {
            return .get
        }
        
        public var parameters: Any? {
            return [
                "module": "account",
                "action": "txlist",
                "address": address.string,
                "startblock": NSNumber(value: startBlock),
                "endblock": NSNumber(value: endBlock),
                "sort": sort.rawValue
            ]
        }
    }
}
