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
