import APIKit

public final class Etherscan {
    public struct GetTransactions: EtherscanRequestType {
        public typealias Response = Transactions
        
        public enum Sort: String {
            case asc, des
        }
        
        public let address: String
        public let sort: Sort
        public let startBlock: Int64
        public let endBlock: Int64
        
        public init(address: String, sort: Sort, startBlock: Int64, endBlock: Int64) {
            self.address = address
            self.sort = sort
            self.startBlock = startBlock
            self.endBlock = endBlock
        }
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var parameters: Any? {
            return [
                "module": "account",
                "action": "txlist",
                "address": address,
                "startblock": NSNumber(value: startBlock),
                "endblock": NSNumber(value: endBlock),
                "sort": sort.rawValue
            ]
        }
    }
}
