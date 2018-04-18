public final class Geth {
    
    private let configuration: Configuration
    private let httpClient: HTTPClient
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        self.httpClient = HTTPClient(configuration: configuration)
    }
    
    // MARK: - JSONRPC APIs
    
    public func getGasPrice(completionHandler: @escaping (Result<Wei>) -> Void) {
        httpClient.send(JSONRPC.GetGasPrice(), completionHandler: completionHandler)
    }
    
    public func getBalance(of address: String, blockParameter: BlockParameter = .latest, completionHandler: @escaping (Result<Balance>) -> Void) {
        httpClient.send(JSONRPC.GetBalance(address: address, blockParameter: blockParameter), completionHandler: completionHandler)
    }
    
    public func getTransactionCount(of address: String, blockParameter: BlockParameter = .latest, completionHandler: @escaping (Result<Int>) -> Void) {
        httpClient.send(JSONRPC.GetTransactionCount(address: address, blockParameter: blockParameter), completionHandler: completionHandler)
    }
    
    public func sendRawTransaction(rawTransaction: String, completionHandler: @escaping (Result<SentTransaction>) -> Void) {
        httpClient.send(JSONRPC.SendRawTransaction(rawTransaction: rawTransaction), completionHandler: completionHandler)
    }
    
    public func getBlockNumber(completionHandler: @escaping (Result<Int>) -> Void) {
        httpClient.send(JSONRPC.GetBlockNumber(), completionHandler: completionHandler)
    }
    
    public func call(from: String? = nil, to: String, gasLimit: Gas.GasLimit? = nil, gasPrice: Gas.GasPrice? = nil, value: Int? = nil, data: String? = nil, blockParameter: BlockParameter = .latest, completionHandler: @escaping (Result<String>) -> Void) {
        let request = JSONRPC.Call(
            from: from,
            to: to,
            gas: gasLimit.map { $0.value },
            gasPrice: gasPrice.map { $0.value },
            value: value,
            data: data,
            blockParameter: blockParameter
        )
        
        httpClient.send(request, completionHandler: completionHandler)
    }
    
    public func getEstimateGas(from: String? = nil, to: String, gasLimit: Gas.GasLimit? = nil, gasPrice: Gas.GasPrice? = nil, value: Int? = nil, data: String? = nil, completionHandler: @escaping (Result<Wei>) -> Void) {
        let request = JSONRPC.GetEstimatGas(
            from: from,
            to: to,
            gas: gasLimit.map { $0.value },
            gasPrice: gasPrice.map { $0.value },
            value: value,
            data: data
        )
        
        httpClient.send(request, completionHandler: completionHandler)
    }
    
    // MARK: - Etherscan APIs
    
    public func getTransactions(address: String, completionHandler: @escaping (Result<Transactions>) -> Void) {
        let request = Etherscan.GetTransactions(
            configuration: .init(baseURL: configuration.etherscanURL, apiKey: configuration.etherscanAPIKey),
            address: Address(string: address)
        )
        httpClient.send(request, completionHandler: completionHandler)
    }
}
