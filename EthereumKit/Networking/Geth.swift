/// Geth is responsible for interacting with Ethereum blockchain
public final class Geth {
    
    private let configuration: Configuration
    private let httpClient: HTTPClient
    
    /// init initialize Geth instance
    ///
    /// - Parameter configuration: configuration to use in http client
    public init(configuration: Configuration) {
        self.configuration = configuration
        self.httpClient = HTTPClient(configuration: configuration)
    }
    
    // MARK: - JSONRPC APIs
    
    /// getGasPrice returns currenct gas price
    ///
    /// - Parameters:
    ///   - completionHandler:
    public func getGasPrice(completionHandler: @escaping (Result<Wei>) -> Void) {
        httpClient.send(JSONRPC.GetGasPrice(), completionHandler: completionHandler)
    }
    
    /// getBalance returns currenct balance of specified address.
    ///
    /// - Parameters:
    ///   - address: address you want to get the balance of
    ///   - blockParameter:
    ///   - completionHandler:
    public func getBalance(of address: String, blockParameter: BlockParameter = .latest, completionHandler: @escaping (Result<Balance>) -> Void) {
        httpClient.send(JSONRPC.GetBalance(address: address, blockParameter: blockParameter), completionHandler: completionHandler)
    }
    
    /// getTransactionCount returns the current nonce of specified address
    ///
    /// - Parameters:
    ///   - address: address to check
    ///   - blockParameter:
    ///   - completionHandler:
    public func getTransactionCount(of address: String, blockParameter: BlockParameter = .latest, completionHandler: @escaping (Result<Int>) -> Void) {
        httpClient.send(JSONRPC.GetTransactionCount(address: address, blockParameter: blockParameter), completionHandler: completionHandler)
    }
    
    /// sendRawTransaction sends the raw transaction string
    ///
    /// - Parameters:
    ///   - rawTransaction: raw transaction encoded in rlp hex format
    ///   - completionHandler:
    public func sendRawTransaction(rawTransaction: String, completionHandler: @escaping (Result<SentTransaction>) -> Void) {
        httpClient.send(JSONRPC.SendRawTransaction(rawTransaction: rawTransaction), completionHandler: completionHandler)
    }
    
    /// getBlockNumber returns the latest block number
    ///
    /// - Parameter completionHandler:
    public func getBlockNumber(completionHandler: @escaping (Result<Int>) -> Void) {
        httpClient.send(JSONRPC.GetBlockNumber(), completionHandler: completionHandler)
    }
    
    /// call sends transaction to a contract method
    ///
    /// - Parameters:
    ///   - from: which address to send from
    ///   - to: which address to send to
    ///   - gasLimit: gas limit
    ///   - gasPrice: gas price
    ///   - value: value in wei
    ///   - data: data to include in tx
    ///   - blockParameter:
    ///   - completionHandler:
    public func call(from: String? = nil, to: String, gasLimit: Int? = nil, gasPrice: Int? = nil, value: Int? = nil, data: String? = nil, blockParameter: BlockParameter = .latest, completionHandler: @escaping (Result<String>) -> Void) {
        let request = JSONRPC.Call(
            from: from,
            to: to,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            value: value,
            data: data,
            blockParameter: blockParameter
        )
        
        httpClient.send(request, completionHandler: completionHandler)
    }
    
    /// getEstimateGas returns estimated gas for the tx
    ///
    /// - Parameters:
    ///   - from: which address to send from
    ///   - to: which address to send to
    ///   - gasLimit: gas limit
    ///   - gasPrice: gas price
    ///   - value: value in wei
    ///   - data: data to include in tx
    ///   - completionHandler:
    public func getEstimateGas(from: String? = nil, to: String, gasLimit: Int? = nil, gasPrice: Int? = nil, value: Int? = nil, data: String? = nil, completionHandler: @escaping (Result<Wei>) -> Void) {
        let request = JSONRPC.GetEstimatGas(
            from: from,
            to: to,
            gasLimit: gasLimit,
            gasPrice: gasPrice,
            value: value,
            data: data
        )
        
        httpClient.send(request, completionHandler: completionHandler)
    }
    
    // MARK: - Etherscan APIs
    
    /// getTransactions returns the list of transaction for the specified address.
    ///
    /// - Parameters:
    ///   - address: address to get transactions from
    ///   - completionHandler:
    public func getTransactions(address: String, completionHandler: @escaping (Result<Transactions>) -> Void) {
        let request = Etherscan.GetTransactions(
            configuration: .init(baseURL: configuration.etherscanURL, apiKey: configuration.etherscanAPIKey),
            address: address
        )
        httpClient.send(request, completionHandler: completionHandler)
    }
}
