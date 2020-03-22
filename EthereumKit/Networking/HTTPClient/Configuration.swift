/// Configuration has necessary information to use in Geth network
public struct Configuration {
    
    /// represents which network to use
    public let network: Network
    
    /// represents an endpoint of ethereum node to connect to
    public let nodeEndpoint: String
    
    /// represents an etherscan api key
    public let etherscanAPIKey: String
    
    /// represents whether to print debug logs in console
    public let debugPrints: Bool
    
    public init(network: Network, nodeEndpoint: String, etherscanAPIKey: String, debugPrints: Bool) {
        self.network = network
        self.nodeEndpoint = nodeEndpoint
        self.etherscanAPIKey = etherscanAPIKey
        self.debugPrints = debugPrints
    }
    
    /// reprensets an etherscan url based on which network to use
    public var etherscanURL: URL {
        switch network {
        case .mainnet:
            return URL(string: "https://api.etherscan.io")!
            
        case .ropsten:
            return URL(string: "https://ropsten.etherscan.io")!
            
        case .kovan:
            return URL(string: "https://kovan.etherscan.io")!
            
        case .rinkeby:
        return URL(string: "https://rinkeby.etherscan.io/")!
            
        case .private:
            // NOTE: does not get any transactions because of private network.
            return URL(string: "https://ropsten.etherscan.io")!
        }
    }
}
