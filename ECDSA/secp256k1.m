//
//  CKScep256k1.m
//  CKScep256k1
//
//  Created by 仇弘扬 on 2017/8/17.
//  Copyright © 2017年 askcoin. All rights reserved.
//

#import "secp256k1.h"
#import <secp256k1/secp256k1.h>
#import "NSData+HexString.h"

@implementation Secp256k1
+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression
{
	secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
	
	const unsigned char *prvKey = (const unsigned char *)privateKeyData.bytes;
	secp256k1_pubkey pKey;
	
	int result = secp256k1_ec_pubkey_create(context, &pKey, prvKey);
	if (result != 1) {
		return nil;
	}
	
	int size = isCompression ? 33 : 65;
	unsigned char *pubkey = malloc(size);
	
	size_t s = size;
	
	result = secp256k1_ec_pubkey_serialize(context, pubkey, &s, &pKey, isCompression ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED);
	if (result != 1) {
		return nil;
	}
	
	secp256k1_context_destroy(context);
	
	NSMutableData *data = [NSMutableData dataWithBytes:pubkey length:size];
	free(pubkey);
	return data;
}

+ (NSData *)compactSignData:(NSData *)msgData withPrivateKey:(NSData *)privateKeyData
{
	secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
	
	const unsigned char *prvKey = (const unsigned char *)privateKeyData.bytes;
	const unsigned char *msg = (const unsigned char *)msgData.bytes;
	
	unsigned char *siga = malloc(64);
	secp256k1_ecdsa_signature sig;
	int result = secp256k1_ecdsa_sign(context, &sig, msg, prvKey, NULL, NULL);
	
	result = secp256k1_ecdsa_signature_serialize_compact(context, siga, &sig);
	
	if (result != 1) {
		return nil;
	}
	
	secp256k1_context_destroy(context);
	
	NSMutableData *data = [NSMutableData dataWithBytes:siga length:64];
	free(siga);
	return data;
}

+ (NSInteger)verifySignedData:(NSData *)sigData withMessageData:(NSData *)msgData usePublickKey:(NSData *)pubKeyData
{
	secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY | SECP256K1_CONTEXT_SIGN);
	
	const unsigned char *sig = (const unsigned char *)sigData.bytes;
	const unsigned char *msg = (const unsigned char *)msgData.bytes;
	
	const unsigned char *pubKey = (const unsigned char *)pubKeyData.bytes;
	
	secp256k1_pubkey pKey;
	int pubResult = secp256k1_ec_pubkey_parse(context, &pKey, pubKey, pubKeyData.length);
	if (pubResult != 1) return -3;
	
	secp256k1_ecdsa_signature sig_ecdsa;
	int sigResult = secp256k1_ecdsa_signature_parse_compact(context, &sig_ecdsa, sig);
	if (sigResult != 1) return -4;
	
	int result = secp256k1_ecdsa_verify(context, &sig_ecdsa, msg, &pKey);
	
	secp256k1_context_destroy(context);
	return result;
}

@end
