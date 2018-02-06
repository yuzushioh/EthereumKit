//
//  NSData+HexString.m
//  ASKSecp256k1
//
//  Created by 仇弘扬 on 2017/8/18.
//  Copyright © 2017年 askcoin. All rights reserved.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)

+ (NSData *)hexStringToData:(NSString *)hexString
{
	const char *chars = [hexString UTF8String];
	int i = 0;
	int len = (int)hexString.length;
	NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
	char byteChars[3] = {'\0','\0','\0'};
	unsigned long wholeByte;
	
	while (i<len) {
		byteChars[0] = chars[i++];
		byteChars[1] = chars[i++];
		wholeByte = strtoul(byteChars, NULL, 16);
		[data appendBytes:&wholeByte length:1];
	}
	
	return data;
}

- (NSString *)dataToHexString
{
	NSUInteger len = [self length];
	char *chars = (char *)[self bytes];
	NSMutableString *hexString = [[NSMutableString alloc] init];
	for (NSUInteger i = 0; i < len; i++) {
		[hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
	}
	return hexString;
}

@end
