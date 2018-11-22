extension ERC20 {
    enum ContractFunctions {
        case balanceOf(address: String)
        case transfer(address: String, amount: BInt)
        
        var methodSignature: Data {
            switch self {
            case .balanceOf:
                return generateSignature(method: "balanceOf(address)")
            case .transfer:
                return generateSignature(method: "transfer(address,uint256)")
            }
        }
        
        private func generateSignature(method: String) -> Data {
            return method.data(using: .ascii)!.sha3(.keccak256)[0...3]
        }
        
        var data: Data {
            switch self {
                
            case .balanceOf(let address):
                let noHexAddress = ERC20.pad(string: address.stripHexPrefix())
                return Data(hex: methodSignature.toHexString() + noHexAddress)
                
            case .transfer(let toAddress, let poweredAmount):
                let address = ERC20.pad(string: toAddress.stripHexPrefix())
                let amount = ERC20.pad(string: poweredAmount.serialize().toHexString())
                return Data(hex: methodSignature.toHexString() + address + amount)
            }
        }
    }
}
