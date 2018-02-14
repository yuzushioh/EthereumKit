//
//  secp256k1.m
//  secp256k1
//
//  Created by 仇弘扬 on 2017/8/17.
//  Copyright © 2017年 askcoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "secp256k1.h"

@implementation Secp256k1

+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression {
    NSString* str = @"teststring";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

@end
