import Result

public final class Geth {
    
    private let etherClient: JSONRPCClient
    private let etherscanClient: EtherscanClient
    
    public init(configuration: Configuration) {
        etherClient = JSONRPCClient(configuration: configuration)
        etherscanClient = EtherscanClient(configuration: configuration)
    }
    
    // MARK: - JSONRPC APIs
    
    public func getGasPrice(handler: @escaping (Result<Wei, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetGasPrice(), handler: handler)
    }
    
    public func getBalance(of address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Balance, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetBalance(address: Address(string: address), blockParameter: blockParameter), handler: handler)
    }
    
    public func getTransactionCount(of address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Int, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetTransactionCount(address: Address(string: address), blockParameter: blockParameter), handler: handler)
    }
    
    public func sendRawTransaction(rawTransaction: String, handler: @escaping (Result<SentTransaction, GethError>) -> Void) {
        etherClient.send(JSONRPC.SendRawTransaction(rawTransaction: rawTransaction), handler: handler)
    }
    
    public func call(from: String? = nil, to: String, gasLimit: Gas.GasLimit? = nil, gasPrice: Gas.GasPrice? = nil, value: Int? = nil, data: String? = nil, blockParameter: BlockParameter = .latest, handler: @escaping (Result<String, GethError>) -> Void) {
        etherClient.send(JSONRPC.Call(from: from.map(Address.init), to: Address(string: to), gas: gasLimit.map { $0.value }, gasPrice: gasPrice.map { $0.value }, value: value, data: data, blockParameter: blockParameter), handler: handler)
    }
    
    public func getEstimateGas(from: String? = nil, to: String, gasLimit: Gas.GasLimit? = nil, gasPrice: Gas.GasPrice? = nil, value: Int? = nil, data: String? = nil, handler: @escaping (Result<Wei, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetEstimatGas(from: from.map(Address.init), to: Address(string: to), gas: gasLimit.map { $0.value }, gasPrice: gasPrice.map { $0.value }, value: value, data: data), handler: handler)
    }
    
    public func getBlockNumber(handler: @escaping (Result<Int, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetBlockNumber(), handler: handler)
    }
    
    // MARK: - Etherscan APIs
    
    public func getTransactions(address: String, handler: @escaping (Result<Transactions, GethError>) -> Void) {
        etherscanClient.send(Etherscan.GetTransactions(address: Address(string: address)), handler: handler)
    }
}
