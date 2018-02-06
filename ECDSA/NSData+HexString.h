//
//  NSData+HexString.h
//  ASKSecp256k1
//
//  Created by 仇弘扬 on 2017/8/18.
//  Copyright © 2017年 askcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexString)
- (NSString *)dataToHexString;
+ (NSData *)hexStringToData:(NSString *)hexString;
@end
