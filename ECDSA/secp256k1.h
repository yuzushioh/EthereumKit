//
//  CKScep256k1.h
//  CKScep256k1
//
//  Created by 仇弘扬 on 2017/8/17.
//  Copyright © 2017年 askcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Secp256k1 : NSObject
+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression;
+ (NSData *)compactSignData:(NSData *)msgData withPrivateKey:(NSData *)privateKeyData;

/**
 用公钥验证签名

 @param sigData 签名的数据
 @param msgData 原数据
 @param pubKeyData 公钥
 @return 1 OK；0 不正确；-3 公钥读取失败；-4 签名读取失败
 */
+ (NSInteger)verifySignedData:(NSData *)sigData withMessageData:(NSData *)msgData usePublickKey:(NSData *)pubKeyData;
@end
