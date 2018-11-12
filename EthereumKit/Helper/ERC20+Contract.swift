extension ERC20 {
    enum ContractFunctions {
        case balanceOf(address: String)
        
        var methodSignature: String {
            // We could get the signature by doing this:
//                Digest.sha3("balanceOf(address)".bytes, variant: .keccak256).toHexString().addHexPrefix()
//                let index = methodSignature.index(methodSignature.startIndex, offsetBy: 10)
//                methodSignature = String(methodSignature[..<index])
            
            switch self {
            case .balanceOf:
                return "0x70a08231"
            }
        }
        
        func data() -> String {
            switch self {
            case .balanceOf(let address):
                let noHexAddress = address.stripHexPrefix()
                let padding = String(Array(repeating: "0", count: 64 - noHexAddress.count)) // Padding the 20 bytes token address to 32 bytes with 0
                return self.methodSignature + padding + noHexAddress
            }
        }
    }
}
