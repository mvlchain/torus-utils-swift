import XCTest
import PromiseKit
import fetch_node_details
import CryptoSwift
import BigInt
import web3swift
import secp256k1

@testable import torus_utils_swift

final class torus_utils_swiftTests: XCTestCase {
    
    static let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN|SECP256K1_CONTEXT_VERIFY))
    
    var tempVerifierId = "shubham@tor.us"
    
    func testKeyLookup() {
        
        let expectation = self.expectation(description: "getting node details")
        
        let fd = Torus()
        let arr = ["https://lrc-test-13-a.torusnode.com/jrpc", "https://lrc-test-13-b.torusnode.com/jrpc", "https://lrc-test-13-c.torusnode.com/jrpc", "https://lrc-test-13-d.torusnode.com/jrpc", "https://lrc-test-13-e.torusnode.com/jrpc"]
        let key = fd.keyLookup(endpoints: arr, verifier: "google", verifierId: "somethinsdfgTest@g.com")
        key.done { data in
            print(data)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 6)
    }
    
    func testKeyAssign(){
        let expectations = self.expectation(description: "testing key assign")
        let fd = Torus()
        
        let nodePubKeys : Array<TorusNodePub> = [TorusNodePub(_X: "4086d123bd8b370db29e84604cd54fa9f1aeb544dba1cc9ff7c856f41b5bf269", _Y: "fde2ac475d8d2796aab2dea7426bc57571c26acad4f141463c036c9df3a8b8e8"),TorusNodePub(_X: "1d6ae1e674fdc1849e8d6dacf193daa97c5d484251aa9f82ff740f8277ee8b7d", _Y: "43095ae6101b2e04fa187e3a3eb7fbe1de706062157f9561b1ff07fe924a9528"),TorusNodePub(_X: "fd2af691fe4289ffbcb30885737a34d8f3f1113cbf71d48968da84cab7d0c262", _Y: "c37097edc6d6323142e0f310f0c2fb33766dbe10d07693d73d5d490c1891b8dc"),TorusNodePub(_X: "e078195f5fd6f58977531135317a0f8d3af6d3b893be9762f433686f782bec58", _Y: "843f87df076c26bf5d4d66120770a0aecf0f5667d38aa1ec518383d50fa0fb88"),TorusNodePub(_X: "a127de58df2e7a612fd256c42b57bb311ce41fd5d0ab58e6426fbf82c72e742f", _Y: "388842e57a4df814daef7dceb2065543dd5727f0ee7b40d527f36f905013fa96")
        ]
        
        let keyAssign = fd.keyAssign(endpoints: ["https://lrc-test-13-a.torusnode.com/jrpc", "https://lrc-test-13-b.torusnode.com/jrpc", "https://lrc-test-13-c.torusnode.com/jrpc", "https://lrc-test-13-d.torusnode.com/jrpc", "https://lrc-test-13-e.torusnode.com/jrpc"], torusNodePubs: nodePubKeys, verifier: "google", verifierId: self.tempVerifierId)
        
        print(keyAssign)
        keyAssign.done{ data in
            print("data", data.result)
            expectations.fulfill()
        }.catch{ err in
            print("keyAssign failed", err)
        }
        waitForExpectations(timeout: 20)
    }
    
    func testingPromise() {
        testingAnotherrPromise().then{ data -> Promise<String> in
            print(data, "ASqweqd")
            return Promise<String>.value("this is a randomValue")
        }
    }
    
    func testingAnotherrPromise()-> Promise<String>{
        let (tempPromise, seal) = Promise<String>.pending()
        
        seal.fulfill("ASDF")
        tempPromise.then{ data -> Promise<String> in
            print("ASDF", data)
            return Promise<String>.value(data + "qweqwe")
        }
        return tempPromise
        print(tempPromise)
    }
    
    func testGetPublicAddress(){
        let expectations = self.expectation(description: "testing get public address")
        let fd = Torus()
        
        let nodePubKeys : Array<TorusNodePub> = [TorusNodePub(_X: "4086d123bd8b370db29e84604cd54fa9f1aeb544dba1cc9ff7c856f41b5bf269", _Y: "fde2ac475d8d2796aab2dea7426bc57571c26acad4f141463c036c9df3a8b8e8"),TorusNodePub(_X: "1d6ae1e674fdc1849e8d6dacf193daa97c5d484251aa9f82ff740f8277ee8b7d", _Y: "43095ae6101b2e04fa187e3a3eb7fbe1de706062157f9561b1ff07fe924a9528"),TorusNodePub(_X: "fd2af691fe4289ffbcb30885737a34d8f3f1113cbf71d48968da84cab7d0c262", _Y: "c37097edc6d6323142e0f310f0c2fb33766dbe10d07693d73d5d490c1891b8dc"),TorusNodePub(_X: "e078195f5fd6f58977531135317a0f8d3af6d3b893be9762f433686f782bec58", _Y: "843f87df076c26bf5d4d66120770a0aecf0f5667d38aa1ec518383d50fa0fb88"),TorusNodePub(_X: "a127de58df2e7a612fd256c42b57bb311ce41fd5d0ab58e6426fbf82c72e742f", _Y: "388842e57a4df814daef7dceb2065543dd5727f0ee7b40d527f36f905013fa96")
        ]
        
        let getpublicaddress = fd.getPublicAddress(endpoints: ["https://lrc-test-13-a.torusnode.com/jrpc", "https://lrc-test-13-b.torusnode.com/jrpc", "https://lrc-test-13-c.torusnode.com/jrpc", "https://lrc-test-13-d.torusnode.com/jrpc", "https://lrc-test-13-e.torusnode.com/jrpc"], torusNodePubs: nodePubKeys, verifier: "google", verifierId: tempVerifierId, isExtended: true)
        
        print(getpublicaddress)
        getpublicaddress.done{ data in
            print("data", data)
            expectations.fulfill()
        }.catch{ err in
            print("getpublicaddress failed", err)
        }
        waitForExpectations(timeout: 10)
    }
    
    func testretreiveShares(){
        let expectations = self.expectation(description: "testing get public address")
        let fd = Torus()
        let verifierParams = ["verifier_id": tempVerifierId]
        let token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI1N2Y2YTU4MjhkMWU0YTNhNmEwM2ZjZDFhMjQ2MWRiOTU5M2U2MjQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI4NzY3MzMxMDUxMTYtaTBoajNzNTNxaWlvNWs5NXBycGZtajBocDBnbWd0b3IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI4NzY3MzMxMDUxMTYtaTBoajNzNTNxaWlvNWs5NXBycGZtajBocDBnbWd0b3IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDk1ODQzNTA5MTA3Mjc0NzAzNDkiLCJoZCI6InRvci51cyIsImVtYWlsIjoic2h1YmhhbUB0b3IudXMiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IkRxeFB5UjlCSldfWnB4ZzBjVktkQ2ciLCJub25jZSI6Im9VaVdhd1JrT0xlcWgzRndWdEx5cFVNUlpGWmhycCIsIm5hbWUiOiJTaHViaGFtIFJhdGhpIiwicGljdHVyZSI6Imh0dHBzOi8vbGg0Lmdvb2dsZXVzZXJjb250ZW50LmNvbS8tT19SUi1aYlQwZVUvQUFBQUFBQUFBQUkvQUFBQUFBQUFBQUEvQUFLV0pKTmVleHhiRHozcjFVVnBrWjVGbzdsYTNhMXZRZy9zOTYtYy9waG90by5qcGciLCJnaXZlbl9uYW1lIjoiU2h1YmhhbSIsImZhbWlseV9uYW1lIjoiUmF0aGkiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTU4NjI1NTQxMSwiZXhwIjoxNTg2MjU5MDExLCJqdGkiOiI3OWY5ZjBjZTIxNGUxOTE2ODQ4YzI2ODUxMmFmNGE1MDI1ZmY2NzA5In0.kTkM58lp5k6JjZJy8ZaZq8OdKz2RuHT966XizOrbJ8RG-teW9bH1vnZQlLVZU8m-Hlh5zNUdAyJXJ6w1IjgXCVTQ2bBB_6Zb-cM3jzjU7qxtaBg3OCHudOkMVkHRwwkub4NFjrqklzVoh43Umuinu16LYZO0_3Zl_wtHrcS3-1-qWvoC01jxis-Kfc2hpbq9BflflGrPwPn6xC1uAlh-zRawu3u7GidB_jx7jANXrEIvL_Y85ApQCYMsuEP2zx3NiGLzy3GW_FomulPuSKJb8LsGuRH4tLTsUT_ez4rjtZYJbwLPvl1MwitX8d6HMgaA8KGsRc4J4xRlXeShk4hgQA"
        
        let nodePubKeys : Array<TorusNodePub> = [TorusNodePub(_X: "4086d123bd8b370db29e84604cd54fa9f1aeb544dba1cc9ff7c856f41b5bf269", _Y: "fde2ac475d8d2796aab2dea7426bc57571c26acad4f141463c036c9df3a8b8e8"),TorusNodePub(_X: "1d6ae1e674fdc1849e8d6dacf193daa97c5d484251aa9f82ff740f8277ee8b7d", _Y: "43095ae6101b2e04fa187e3a3eb7fbe1de706062157f9561b1ff07fe924a9528"),TorusNodePub(_X: "fd2af691fe4289ffbcb30885737a34d8f3f1113cbf71d48968da84cab7d0c262", _Y: "c37097edc6d6323142e0f310f0c2fb33766dbe10d07693d73d5d490c1891b8dc"),TorusNodePub(_X: "e078195f5fd6f58977531135317a0f8d3af6d3b893be9762f433686f782bec58", _Y: "843f87df076c26bf5d4d66120770a0aecf0f5667d38aa1ec518383d50fa0fb88"),TorusNodePub(_X: "a127de58df2e7a612fd256c42b57bb311ce41fd5d0ab58e6426fbf82c72e742f", _Y: "388842e57a4df814daef7dceb2065543dd5727f0ee7b40d527f36f905013fa96")
        ]
        
        let retreiveShares = fd.retreiveShares(endpoints: ["https://lrc-test-13-a.torusnode.com/jrpc", "https://lrc-test-13-b.torusnode.com/jrpc", "https://lrc-test-13-c.torusnode.com/jrpc", "https://lrc-test-13-d.torusnode.com/jrpc", "https://lrc-test-13-e.torusnode.com/jrpc"], verifier: "google", verifierParams: verifierParams, idToken: token)
        //
        //        print(getpublicaddress)
        //        getpublicaddress.done{ data in
        //            print("data", data)
        //            expectations.fulfill()
        //        }.catch{ err in
        //            print("getpublicaddress failed", err)
        //        }
        waitForExpectations(timeout: 10)
    }
    
    func testdecodeShares(){
        
        // privatekey a615f79a8a1fc577bfb04ae7a7c2a381a3b081ec2fecf3df56e40893f4c5c7fd
        //
//        JSONRPCresponse(id: 10, jsonrpc: "2.0", result: Optional(["keys": [["Metadata": ["mode": "AES256", "iv": "9622119b0055207f0b761220d1c26e19", "mac": "5a32452eb60370575247c229e552c882b06c016523ae5c992d1dc57aa5779875", "ephemPublicKey": "041dc8c20a131b632c8ec82dd593c9bfa12b5b521ca5176067bbd731025d3db5669b995434e90a7999b945c2c558584478b2133cfa170b48ea5f738f218f02a1a6"], "Verifiers": ["google": ["shubham@tor.us"]], "Index": "5", "Share": "YzU0MTE1ZDUwMTFjNGJjMGQ5MDQ0MjcyMDY2NTQwODU0OTgzNjllYzI5OWJhYWZkNWYyOTNiYWU0MDZhNTQ3NDU5YTUwOTg1MDI2ZjY4NDBhZWNlZDFiODI4NGZiODUz", "Threshold": 1, "PublicKey": ["Y": "59f673821f9885e1cc53b6c3e80e802900dd4cbdd663dc97f9e3f83f55bbd768", "X": "bc5b761516115b97c9fde7d763e8f78694bcaca245020db064adfaca79a2281f"]]]]), error: nil, message: nil) 0
        
//        JSONRPCresponse(id: 10, jsonrpc: "2.0", result: Optional(["keys": [["Threshold": 1, "Verifiers": ["google": ["shubham@tor.us"]], "Index": "5", "Share": "ZDU4ZmNiMTc1MTBkYzIxNDU4NjQ5NmFlZDM0ZTAwZDE0MjBkYWU1N2NiMjc2ZDBjMzAzZmQyMTFmNGZhOGU2ODYxOTlmMjc4ODA2ZTdiZWU5MjRmZjJjNjczNmI2MjE3", "PublicKey": ["X": "bc5b761516115b97c9fde7d763e8f78694bcaca245020db064adfaca79a2281f", "Y": "59f673821f9885e1cc53b6c3e80e802900dd4cbdd663dc97f9e3f83f55bbd768"], "Metadata": ["ephemPublicKey": "046c00a4f0e3df4a49ada329190aac32efe0441b3e1383bbafcac2b00bc62c08b3728cf54895926dbc1088dd3927b58de91e8a7e4c6b17abaea1aeb853e9b6119d", "iv": "62d9f5ebe4a954ac090b427c0082e35f", "mac": "e45404bf988248186f03bebc95a928231d4a302f8154e5138f76a974b899c19e", "mode": "AES256"]]]]), error: nil, message: nil) 2
        
//        JSONRPCresponse(id: 10, jsonrpc: "2.0", result: Optional(["keys": [["Metadata": ["mode": "AES256", "mac": "09469f91a61148e4cc8a13d3023890e3a2039bed4ef0d24311f8441eb1bfd261", "iv": "0a041a50c1950c7a3268fff1b70c32ca", "ephemPublicKey": "04b5e2bb9a2c5025445dad60ff64f4bc4ea2217e92bb406e14077e7fb2b7d98c6256e32a39bf5215340240df018059abee0503716c972bedd868d5c366e3a409d3"], "Share": "ZTE1OTkyN2E0MjgxZTY4NzQ0MWYyZTBmZjU5ZjNmM2YxZDIxMjEwZjhhYWIwYzQ0MWZiYjkxOGFhMjg3NGVmODY2MTAxZGM0ZTVjYTVhYzhlMDg0NzQyNzBkYzA0OTU4", "Index": "5", "Threshold": 1, "PublicKey": ["X": "bc5b761516115b97c9fde7d763e8f78694bcaca245020db064adfaca79a2281f", "Y": "59f673821f9885e1cc53b6c3e80e802900dd4cbdd663dc97f9e3f83f55bbd768"], "Verifiers": ["google": ["shubham@tor.us"]]]]]), error: nil, message: nil) 4
        
        let iv1 = "d0940684def51afbfeea3b1892d6e8a6".hexa
        let share1 = "fc933106fc13ad9c5e9d2c3678d8170bbf2ae90948ef5979cf0e42b1a24ffa5326bb86a35a2c2d4b391f19fba30644e8".hexa
        
        
        let key1 = "1e75e044afdaf4509e46d8d9907439d75e263fc2baffe597a7f31e94c0fc7e05".hexa
        // print(share1)
        
        do{
            
            let aes = try! AES(key: key1, blockMode: CBC(iv: iv1), padding: .pkcs7)
            let encrypt = try! aes.encrypt(share1)
            print("encrypt", encrypt.hexa)
            
            
            let decrypt = try! aes.decrypt(share1)
            print("decrypt", decrypt)
            
        }catch CryptoSwift.AES.Error.dataPaddingRequired{
            print("padding error")
        }
    }
    
    func privateKeyToPublicKey4(privateKey: Data) -> secp256k1_pubkey? {
        if (privateKey.count != 32) {return nil}
        var publicKey = secp256k1_pubkey()
        let result = privateKey.withUnsafeBytes { (a: UnsafeRawBufferPointer) -> Int32? in
            if let pkRawPointer = a.baseAddress, a.count > 0 {
                let privateKeyPointer = pkRawPointer.assumingMemoryBound(to: UInt8.self)
                let res = secp256k1_ec_pubkey_create(torus_utils_swiftTests.context!, UnsafeMutablePointer<secp256k1_pubkey>(&publicKey), privateKeyPointer)
                return res
            } else {
                return nil
            }
        }
        guard let res = result, res != 0 else {
            return nil
        }
        return publicKey
    }
    
    func ecdh(pubKey: secp256k1_pubkey, privateKey: Data) -> secp256k1_pubkey? {
        var pubKey2 = pubKey
        if (privateKey.count != 32) {return nil}
        let result = privateKey.withUnsafeBytes { (a: UnsafeRawBufferPointer) -> Int32? in
            if let pkRawPointer = a.baseAddress, a.count > 0 {
                let privateKeyPointer = pkRawPointer.assumingMemoryBound(to: UInt8.self)
                let res = secp256k1_ec_pubkey_tweak_mul(torus_utils_swiftTests.context!, UnsafeMutablePointer<secp256k1_pubkey>(&pubKey2), privateKeyPointer)
                return res
            } else {
                return nil
            }
        }
        guard let res = result, res != 0 else {
            return nil
        }
        return pubKey2
    }
    
    func testECDH() {
        
        // print(array32toTuple("a4abdc1e2adf241d444ec328059989dea9ed5498384e1040324cc748653df20db3da34d4607bfd0b1ca3f1e52666cb169b9766466c76a0b2c8373b070997637a".hexa))
        
        var testArr = "b5e2bb9a2c5025445dad60ff64f4bc4ea2217e92bb406e14077e7fb2b7d98c6256e32a39bf5215340240df018059abee0503716c972bedd868d5c366e3a409d3".hexa
        var newtest = testArr.prefix(32)
        newtest.reverse()
        //        print(newtest)
        
        var newTest2 = testArr.suffix(32)
        newTest2.reverse()
        
        newtest.append(contentsOf: newTest2)
        //print(newtest)
        
        
        var ephemPubKey = secp256k1_pubkey.init(data: array32toTuple(Array(newtest)))
        var sharedSecret = ecdh(pubKey: ephemPubKey, privateKey: Data.init(hexString: "a615f79a8a1fc577bfb04ae7a7c2a381a3b081ec2fecf3df56e40893f4c5c7fd")!)
        var sharedSecretData = sharedSecret!.data
        var sharedSecretPrefix = tupleToArray(sharedSecretData).prefix(32)
        var reversedSharedSecret = sharedSecretPrefix.reversed()
        print(reversedSharedSecret.hexa)
        //        print(tupleToArray(sharedSecretData).)
        
        // let prefix = sharedSecretData.prefix(32)
        //        print("sharedSecretData", sharedSecretData)
        var newXValue = reversedSharedSecret.hexa
        
        
        var hash = SHA2(variant: .sha512).calculate(for: newXValue.hexa).hexa
        let AesEncryptionKey = hash.prefix(64)
        let iv1 = "0a041a50c1950c7a3268fff1b70c32ca".hexa
        let share1 = "ZTE1OTkyN2E0MjgxZTY4NzQ0MWYyZTBmZjU5ZjNmM2YxZDIxMjEwZjhhYWIwYzQ0MWZiYjkxOGFhMjg3NGVmODY2MTAxZGM0ZTVjYTVhYzhlMDg0NzQyNzBkYzA0OTU4".fromBase64()!.hexa
        // print("hash", hash)
        
        do{
            let aes = try! AES(key: AesEncryptionKey.hexa, blockMode: CBC(iv: iv1), padding: .pkcs7)
            //let encrypt = try! aes.encrypt(share1)
            // print("encrypt", encrypt.hexa)
            
            
            let decrypt = try! aes.decrypt(share1)
            print("decrypt", decrypt.hexa)
            
        }catch CryptoSwift.AES.Error.dataPaddingRequired{
            print("padding error")
        }
        print(BigUInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16))
        // print(sharedSecret, tupleToArray(sharedSecretData).hexa)
    }
    
    func testLagrangeInterpolation(){
        // Share1 0b2334aa653297de5ec3e3ff404861f8b495da6daeb82a3f471323acf016c652 1
        // Share2 9948c1666b858b7d675af89be0e5dc494469fc8ae41eff20a7ad35829cd7d1c1 3
        // Share3 c0fdab1afc6ec93551dea560950525c892dc978469b34ae90658fd7996c0d7f9 5
        
        // print(BigInt(8).inverse(BigInt(21)))
        // print(BigInt("10").power(BigInt(1), modulus: BigInt(7)))
        //print(BigInt("0b2334aa653297de5ec3e3ff404861f8b495da6daeb82a3f471323acf016c652", radix: 16))
        
        let expectations = self.expectation(description: "testing get public address")
        
        let shareList = [BigInt(1): BigInt("0b2334aa653297de5ec3e3ff404861f8b495da6daeb82a3f471323acf016c652", radix: 16), BigInt(3): BigInt("9948c1666b858b7d675af89be0e5dc494469fc8ae41eff20a7ad35829cd7d1c1", radix: 16), BigInt(5): BigInt("c0fdab1afc6ec93551dea560950525c892dc978469b34ae90658fd7996c0d7f9", radix: 16)]
        //print(shareList)
        
        let secp256k1N = BigInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16);
        var secret = BigInt("0");
        //print(secret)
        let serialQueue = DispatchQueue(label: "lagrange.serial.queue")
        let semaphore = DispatchSemaphore(value: 1)
        
        for (i, share) in shareList {
            semaphore.wait()

            serialQueue.async{
                
                //print(i, share)
                var upper = BigInt(1);
                var lower = BigInt(1);
                for (j, _) in shareList {
                    if (i != j) {
                        // print(j, i)
                        var negateJ = j
                        negateJ = negateJ*BigInt(-1)
                        upper = upper*negateJ
                        
                        upper = upper.modulus(secp256k1N!)
                        
                        var tempi = i
                        tempi = tempi-j;
                        var temp = tempi
                        
                        temp = temp.modulus(secp256k1N!);
                        lower = (lower*temp).modulus(secp256k1N!);
                        
                        print("i \(i) j \(j) tempi \(tempi) upper \(upper) lower \(lower)")
                    }
                }
                var delta = (upper*(lower.inverse(secp256k1N!)!)).modulus(secp256k1N!);
                print("delta", delta, "inverse of lower", lower.inverse(secp256k1N!)!)
                delta = (delta*share!).modulus(secp256k1N!)
                secret = (secret+delta).modulus(secp256k1N!)
                
                print("secret is", secret.serialize().hexa.suffix(64), "\n")
                let publicKey = SECP256K1.privateToPublic(privateKey: secret.serialize().suffix(32), compressed: false)?.suffix(64) // take last 64
                
                // Split key in 2 parts, X and Y
                let publicKeyHex = publicKey?.toHexString()
                let pubKeyX = publicKey?.prefix(publicKey!.count/2).toHexString()
                let pubKeyY = publicKey?.suffix(publicKey!.count/2).toHexString()
                
                print("publicKey", pubKeyX, pubKeyY)
                semaphore.signal()
            }
            
        }

        waitForExpectations(timeout: 15)
        
    }
    
    func tupleToArray(_ tuple: Any) -> [UInt8] {
        // var result = [UInt8]()
        let tupleMirror = Mirror(reflecting: tuple)
        let tupleElements = tupleMirror.children.map({ $0.value as! UInt8 })
        return tupleElements
    }
    
    func array32toTuple(_ arr: Array<UInt8>) -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8){
        return (arr[0] as UInt8, arr[1] as UInt8, arr[2] as UInt8, arr[3] as UInt8, arr[4] as UInt8, arr[5] as UInt8, arr[6] as UInt8, arr[7] as UInt8, arr[8] as UInt8, arr[9] as UInt8, arr[10] as UInt8, arr[11] as UInt8, arr[12] as UInt8, arr[13] as UInt8, arr[14] as UInt8, arr[15] as UInt8, arr[16] as UInt8, arr[17] as UInt8, arr[18] as UInt8, arr[19] as UInt8, arr[20] as UInt8, arr[21] as UInt8, arr[22] as UInt8, arr[23] as UInt8, arr[24] as UInt8, arr[25] as UInt8, arr[26] as UInt8, arr[27] as UInt8, arr[28] as UInt8, arr[29] as UInt8, arr[30] as UInt8, arr[31] as UInt8, arr[32] as UInt8, arr[33] as UInt8, arr[34] as UInt8, arr[35] as UInt8, arr[36] as UInt8, arr[37] as UInt8, arr[38] as UInt8, arr[39] as UInt8, arr[40] as UInt8, arr[41] as UInt8, arr[42] as UInt8, arr[43] as UInt8, arr[44] as UInt8, arr[45] as UInt8, arr[46] as UInt8, arr[47] as UInt8, arr[48] as UInt8, arr[49] as UInt8, arr[50] as UInt8, arr[51] as UInt8, arr[52] as UInt8, arr[53] as UInt8, arr[54] as UInt8, arr[55] as UInt8, arr[56] as UInt8, arr[57] as UInt8, arr[58] as UInt8, arr[59] as UInt8, arr[60] as UInt8, arr[61] as UInt8, arr[62] as UInt8, arr[63] as UInt8)
    }
    
    var allTests = [
        ("testretreiveShares", testretreiveShares),
        ("testingPromise", testingPromise),
        ("testECDH", testECDH),
        ("testdecodeShares", testdecodeShares),
        ("testLagrangeInterpolation", testLagrangeInterpolation),
        //        ("testKeyLookup", testKeyLookup),
        //        ("testKeyAssign", testKeyAssign),
        ("testGetPublicAddress", testGetPublicAddress)
    ]
}

extension StringProtocol {
    var hexa: [UInt8] {
        var startIndex = self.startIndex
        //print(startIndex, count)
        return (0..<count/2).compactMap { _ in
            let endIndex = index(after: startIndex)
            defer { startIndex = index(after: endIndex) }
            // print(startIndex, endIndex)
            return UInt8(self[startIndex...endIndex], radix: 16)
        }
    }
}

extension Sequence where Element == UInt8 {
    var data: Data { .init(self) }
    var hexa: String { map { .init(format: "%02x", $0) }.joined() }
}

extension Data {
    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        for i in 0 ..< length {
            let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var byte = UInt8(bytes, radix: 16) {
                data.append(&byte, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
