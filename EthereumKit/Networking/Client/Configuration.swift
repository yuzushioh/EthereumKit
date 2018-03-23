public struct Configuration {
    public let network: Network
    public let nodeEndpoint: String
    public let etherscanAPIKey: String
    
    public init(network: Network, nodeEndpoint: String, etherscanAPIKey: String) {
        self.network = network
        self.nodeEndpoint = nodeEndpoint
        self.etherscanAPIKey = etherscanAPIKey
    }
    
    public var etherscanURL: URL {
        switch network {
        case .main:
            return URL(string: "https://api.etherscan.io")!
            
        case .ropsten:
            return URL(string: "https://ropsten.etherscan.io")!
            
        case .private:
            // NOTE: does not get any transactions because of private network.
            return URL(string: "https://ropsten.etherscan.io")!
        }
    }
}
