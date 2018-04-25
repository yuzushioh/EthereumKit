import Result

public final class Geth {
    
    private let etherClient: JSONRPCClient
    private let etherscanClient: EtherscanClient
    
    public init(configuration: Configuration) {
        etherClient = JSONRPCClient(configuration: configuration)
        etherscanClient = EtherscanClient(configuration: configuration)
    }
    
    // MARK: - JSONRPC APIs
    
    public func getGasPrice(handler: @escaping (Result<Wei, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.GetGasPrice(), handler: handler)
    }
    
    public func getBalance(of address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Balance, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.GetBalance(address: address, blockParameter: blockParameter), handler: handler)
    }
    
    public func getTransactionCount(of address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Int, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.GetTransactionCount(address: address, blockParameter: blockParameter), handler: handler)
    }
    
    public func sendRawTransaction(rawTransaction: String, handler: @escaping (Result<SentTransaction, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.SendRawTransaction(rawTransaction: rawTransaction), handler: handler)
    }
    
    public func call(from: String? = nil, to: String, gasLimit: Gas.GasLimit? = nil, gasPrice: Gas.GasPrice? = nil, value: Int? = nil, data: String? = nil, blockParameter: BlockParameter = .latest, handler: @escaping (Result<String, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.Call(from: from, to: to, gas: gasLimit.map { $0.value }, gasPrice: gasPrice.map { $0.value }, value: value, data: data, blockParameter: blockParameter), handler: handler)
    }
    
    public func getEstimateGas(from: String? = nil, to: String, gasLimit: Gas.GasLimit? = nil, gasPrice: Gas.GasPrice? = nil, value: Int? = nil, data: String? = nil, handler: @escaping (Result<Wei, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.GetEstimatGas(from: from, to: to, gas: gasLimit.map { $0.value }, gasPrice: gasPrice.map { $0.value }, value: value, data: data), handler: handler)
    }
    
    public func getBlockNumber(handler: @escaping (Result<Int, EthereumKitError>) -> Void) {
        etherClient.send(JSONRPC.GetBlockNumber(), handler: handler)
    }
    
    // MARK: - Etherscan APIs
    
    public func getTransactions(address: String, sort: Etherscan.GetTransactions.Sort = .des, startBlock: Int64 = 0, endBlock: Int64 = 99999999, handler: @escaping (Result<Transactions, EthereumKitError>) -> Void) {
        etherscanClient.send(Etherscan.GetTransactions(address: address, sort: sort, startBlock: startBlock, endBlock: endBlock), handler: handler)
    }
}
