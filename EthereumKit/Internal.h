//
//  secp256k1.h
//  secp256k1
//
//  Created by yuzushioh on 2018/02/14.
//  Copyright © 2018 yuzushioh.
//

#import <Foundation/Foundation.h>

@interface Secp256k1 : NSObject
+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression;
@end

@interface CryptoHash : NSObject

+ (NSData *)sha256:(NSData *)data;
+ (NSData *)ripemd160:(NSData *)data;
+ (NSData *)hmacsha512:(NSData *)data key:(NSData *)key;

@end

@interface PKCS5 : NSObject
+ (NSData *)PBKDF2:(NSData *)password salt:(NSData *)salt iterations:(NSInteger)iterations keyLength:(NSInteger)keyLength;
@end
