import XCTest
@testable import EthereumKit

class PrivateKeyAndPublicKeyTests: XCTestCase {
    func testPrivateKeyAndPublicKeyTestnet() {
        let privateKey = PrivateKey(raw: Data(hex: "0ac03c260512582a94295185cfa899e0cb8067a89a61b7b5435ec524c088203c"))
        let publicKey = PublicKey(raw: Data(hex: "047e63dc23f0f6ecb0b2ab8a649f0e2966e9c6ceb10f901e0e0b712cfed2f78449710b2e3e0ce01386f5b1d4533dc21bb1b6d1dfc989884b0e099e3e25ce210e3d"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyTestnet2() {
        let privateKey = PrivateKey(raw: Data(hex: "56fa1542efa79a278bf78ba1cf11ef20d961d511d344dc1d4d527bc06eeca667"))
        let publicKey = PublicKey(raw: Data(hex: "040f57160f9f618085d3ff835d3a4b9835a586a662c8fb5fd1bb827f92b9cfd140c3f359f1e85253075ca0403bff729121ed1602bb44e65bef4901aced910f4e55"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyTestnet3() {
        let privateKey = PrivateKey(raw: Data(hex: "db5cbb5ff9d491f8135c4d0288955c82a2414c6130e143768cab3ddac9fb2fc0"))
        let publicKey = PublicKey(raw: Data(hex: "04a0aedc2e00f2b62cfe6b2d4d68e76f25f03099061cc5e0da0da5daac245e2eb7b75f218cb34c55895a2edb2fa2f196f59a2b8470269892fd7c5a30931f51377d"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyTestnet4() {
        let privateKey = PrivateKey(raw: Data(hex: "50f7ca18377d3d7e8a660633af0c94ae509c3da145197f813e58b9b716ca6429"))
        let publicKey = PublicKey(raw: Data(hex: "04d1b4895359166fde9c5b4b661058ec37517a41f4bfd8f2bec4414e4b3a328b8db05101b2baea41d4e229273ec840e3380347cb86524cdd7f5b0ca646e048e6ed"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyTestnet5() {
        let privateKey = PrivateKey(raw: Data(hex: "5e52f62afeb325a30db4e3bf076a907e88db78a99ed7ea0d8ac5db5f12ff835a"))
        let publicKey = PublicKey(raw: Data(hex: "04a13182c3bf1832648419e40e356c63c3ecf541a8888e65c8e8dd7f9577e665658c3f994cadcf1aba3057f06dc41d3a89880c0c1d7e6a34636f4e00957478d238"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyMainnet() {
        let privateKey = PrivateKey(raw: Data(hex: "df02cbea58239744a8a6ba328056309ae43f86fec6db45e5f782adcf38aacadf"))
        let publicKey = PublicKey(raw: Data(hex: "049966a68158fcf8839e7bdbc6b889d4608bd0b4afb358b073bed1d7b70dbe2f4fe1e8a769e62b4a97fe76689207906e3dc00a4be6c71e3ec39142d5a646c9c113"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyMainnet2() {
        let privateKey = PrivateKey(raw: Data(hex: "ae2998e73c1996b87a55e83ac31e5370a74678751afcd72801139c4f212fe93f"))
        let publicKey = PublicKey(raw: Data(hex: "04477ffcad060ac4d0dc6bcac8ea334c9ed2d156d09bb8076df01f79e09fa0ba47382db15a641fdd131cc340912a82e1be7ecc9cf60b553ba2404d5bf9b65414b6"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyMainnet3() {
        let privateKey = PrivateKey(raw: Data(hex: "85968884e16f6e44c86530f9b622eb2d8d6dcc4521d422a4f6204cd3c839ccbc"))
        let publicKey = PublicKey(raw: Data(hex: "0456c510eb79c74e600f88de8d3c3123d9a30812c533aa091f796964064a0ad9befb9d0d9905e791155433d967f622f36decb5d3fa6b235a7f5b435fb224c2cded"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyMainnet4() {
        let privateKey = PrivateKey(raw: Data(hex: "8a44657cf1937443831a3a9640229914a8fb8e18cfda34b604c5e78188fd6c17"))
        let publicKey = PublicKey(raw: Data(hex: "0454dad7949c8a254372053814ca2997dece6f00330f775307127b8673e18cc5367c93867d6aa5a2182716a1e54688c29c0d8147180825a88639ba321b535328bf"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
    
    func testPrivateKeyAndPublicKeyMainnet5() {
        let privateKey = PrivateKey(raw: Data(hex: "66d3d76a0e5865c682019752ce1a79dda06ad92d8c9e938c0faddca411b227f4"))
        let publicKey = PublicKey(raw: Data(hex: "04b9a90056381055e280fec085ae1957d708f5dd26314b2add1cf181d03e3947cdfc664fc55fff0581b62b59e7ae0548914676f500d6a422a31ea54e6f5e1c5a97"))
        XCTAssertEqual(privateKey.publicKey.raw, publicKey.raw)
        XCTAssertEqual(privateKey.publicKey.generateAddress(), publicKey.generateAddress())
    }
}
