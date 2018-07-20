import XCTest
@testable import EthereumKit

class EIP155SignerTests: XCTestCase {

    func testEIP155Signing() {
        testSigning(chainID: Fixture.TestNet.chainID, fixture: Fixture.TestNet.hashForTx)
        testSigning(chainID: Fixture.MainNet.chainID, fixture: Fixture.MainNet.hashForTx)
        testSigning(chainID: Fixture.AnyChain.chainID, fixture: Fixture.AnyChain.hashForTx)
    }

    private func testSigning(chainID: Int, fixture hashForTx: [(String, RawTransaction)], line: UInt = #line) {
        let signer = EIP155Signer(chainID: chainID)
        for (hash, tx) in hashForTx {
            XCTAssertEqual(try! signer.hash(rawTransaction: tx).toHexString(), hash)
        }
    }
    
    func testGeneratingRSVOnTestnet1() {
        let signer = EIP155Signer(chainID: 3)
        let (r, s, v) = signer.calculateRSV(signature: Fixture.signature)
        XCTAssertEqual(r, BInt("18515461264373351373200002665853028612451056578545711640558177340181847433846")!)
        XCTAssertEqual(s, BInt("46948507304638947509940763649030358759909902576025900602547168820602576006531")!)
        XCTAssertEqual(v, BInt(41))
        XCTAssertEqual(r.asString(withBase: 16), "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa636276")
        XCTAssertEqual(s.asString(withBase: 16), "67cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d83")
        XCTAssertEqual(v.asString(withBase: 16), "29")
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(Fixture.signature, restoredSignature)
    }
    
    func testGeneratingRSVOnTestnet2() {
        let signiture = Data(hex: "5e7e818d4ca60295c42f0fab371e8a0409cb5080ba958a67d8d31cdcf18ae50b21fe08e591cb6d5f75d4a443818fdc3ee324f0599253cfd1f5b5c7ac17d0c73a00")
        let signer = EIP155Signer(chainID: 3)
        let (r, s, v) = signer.calculateRSV(signature: signiture)
        XCTAssertEqual(r.asString(withBase: 16), "5e7e818d4ca60295c42f0fab371e8a0409cb5080ba958a67d8d31cdcf18ae50b")
        XCTAssertEqual(s.asString(withBase: 16), "21fe08e591cb6d5f75d4a443818fdc3ee324f0599253cfd1f5b5c7ac17d0c73a")
        XCTAssertEqual(v.asString(withBase: 16), "29")
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(signiture, restoredSignature)
    }
    
    func testGeneratingRSVOnMainnet() {
        let signer = EIP155Signer(chainID: 1)
        let (r, s, v) = signer.calculateRSV(signature: Fixture.signature)
        XCTAssertEqual(r, BInt("18515461264373351373200002665853028612451056578545711640558177340181847433846")!)
        XCTAssertEqual(s, BInt("46948507304638947509940763649030358759909902576025900602547168820602576006531")!)
        XCTAssertEqual(v, BInt(37))
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(Fixture.signature, restoredSignature)
    }

    func testRestoringSignatureSignedWithOldScheme() {
        let v = 27
        let r = "75119860711638973245538703589762310947594328712729260330312782656531560398776"
        let s = "51392727032514077370236468627319183981033698696331563950328005524752791633785"
        let signer = EIP155Signer(chainID: 1)
        let signature = signer.calculateSignature(r: BInt(r)!, s: BInt(s)!, v: BInt(v))
        XCTAssertEqual(signature.toHexString(), "a614559de76862bb1dbf8a969d8979e5bf21b72c51c96b27b3d247b728ebffb8719f40b018940ffd0880285d2196cdd31a710bf7cdda60c77632743d687dff7900")
    }

    func testRestoringSignatureSignedWithOldScheme2() {
        let v = 27
        let r = "79425995431864040500581522255237765710685762616259654871112297909982135982384"
        let s = "1777326029228985739367131500591267170048497362640342741198949880105318675913"
        let signer = EIP155Signer(chainID: 1)
        let signature = signer.calculateSignature(r: BInt(r)!, s: BInt(s)!, v: BInt(v))
        XCTAssertEqual(signature.toHexString(), "af998533cdac5d64594f462871a8ba79fe41d59295e39db3f069434c9862193003edee4e64d899a2c57bd726e972bb6fdb354e3abcd5846e2315ecfec332f5c900")
    }

    func testGeneratingRSVForAnyChain() {
        let signer = EIP155Signer(chainID: 0)
        let rsv = signer.calculateRSV(signature: Fixture.signature)
        XCTAssertEqual(rsv.r.asString(withBase: 10), "18515461264373351373200002665853028612451056578545711640558177340181847433846")
        XCTAssertEqual(rsv.s.asString(withBase: 10), "46948507304638947509940763649030358759909902576025900602547168820602576006531")
        XCTAssertEqual(rsv.v, 27)
    }

}

extension EIP155SignerTests {

    struct Fixture {

        static let signature = Data(hex: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")

        struct TestNet {

            static let chainID = 3

            static let hashForTx: [(String, RawTransaction)] =
                [("84df8756f832aa25f79fdeac98ae9adf83b1da0119dd3555807f890f09c3e1a7", rawTransaction1),
                 ("18f93470671a0db633e4346dfa5ecdc2568e2befdbf815ac205d9eef06a91350", rawTransaction2),
                 ("0af0867d4acb71dd0bd590b86aef78d7ccfdcdcf16e881e9f426e432a1603eaf", rawTransaction3)]

            static let rawTransaction1 = RawTransaction(
                value: Wei("10000000000000000")!,
                to: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F",
                gasPrice: 99000000000,
                gasLimit: 21000,
                nonce: 2
            )

            static let rawTransaction2 = RawTransaction(
                value: Wei("10000000000000000")!,
                to: "0x88b44BC83add758A3642130619D61682282850Df",
                gasPrice: 99000000000,
                gasLimit: 21000,
                nonce: 4
            )

            static let rawTransaction3 = RawTransaction(
                value: Wei("10000000000000000")!,
                to: "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1",
                gasPrice: 99000000000,
                gasLimit: 21000,
                nonce: 25
            )

        }

        struct MainNet {

            static let chainID = 1

            static let hashForTx: [(String, RawTransaction)] =
                [("de6ed032e8f09adb557f6a0ebc16ed52d6a75e0644a77a236aa1cfffa7746e9a", rawTransaction1),
                 ("b148272b2a985365e08abb17a85ca5e171169978f3b55e6852a035f83b9f3aa5", rawTransaction2),
                 ("280e29f030cfa256b4298a2b834a4add92b37f159b3cce1110e1ff9f7514f9fe", rawTransaction3)]

            static let rawTransaction1 = RawTransaction(
                value: Wei("10000000000000000")!,
                to: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F",
                gasPrice: 99000000000,
                gasLimit: 21000,
                nonce: 2
            )

            static let rawTransaction2 = RawTransaction(
                value: Wei("10000000000000000")!,
                to: "0x88b44BC83add758A3642130619D61682282850Df",
                gasPrice: 99000000000,
                gasLimit: 200000,
                nonce: 4
            )

            static let rawTransaction3 = RawTransaction(
                value: Wei("20000000000000000")!,
                to: "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1",
                gasPrice: 99000000000,
                gasLimit: 21000,
                nonce: 25
            )

        }

        struct AnyChain {

            static let chainID = 0

            static let hashForTx: [(String, RawTransaction)] =
                [("2301ff79ec9df8e3ed0ba50ed73310b7f5b95a245923adbb900441d8866b8fe9", MainNet.rawTransaction1),
                 ("3f505a80565016ae81bee259aa62877debc99581d21c45ae1ed1e2a130dd963d", MainNet.rawTransaction2),
                 ("703a9b5bb972f9c3bd794c02e81bd29db7cd01441ef771fccd33393b0827aaf0", MainNet.rawTransaction3)]
        }

    }

}
