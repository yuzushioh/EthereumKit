//
//  secp256k1.m
//  secp256k1
//
//  Created by yuzushioh on 2018/02/14.
//  Copyright © 2018 yuzushioh.
//

#import "Internal.h"
#import <openssl/sha.h>
#import <openssl/ripemd.h>
#import <openssl/hmac.h>
#import <openssl/ec.h>

@implementation Secp256k1

+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression {
    BN_CTX *ctx = BN_CTX_new();
    EC_KEY *key = EC_KEY_new_by_curve_name(NID_secp256k1);
    const EC_GROUP *group = EC_KEY_get0_group(key);
    
    BIGNUM *prv = BN_new();
    BN_bin2bn(privateKeyData.bytes, (int)privateKeyData.length, prv);
    
    EC_POINT *pub = EC_POINT_new(group);
    EC_POINT_mul(group, pub, prv, nil, nil, ctx);
    EC_KEY_set_private_key(key, prv);
    EC_KEY_set_public_key(key, pub);
    
    NSMutableData *result;
    if (isCompression) {
        EC_KEY_set_conv_form(key, POINT_CONVERSION_COMPRESSED);
        unsigned char *bytes = NULL;
        int length = i2o_ECPublicKey(key, &bytes);
        result = [NSMutableData dataWithBytesNoCopy:bytes length:length];
    } else {
        result = [NSMutableData dataWithLength:65];
        BIGNUM *n = BN_new();
        EC_POINT_point2bn(group, pub, POINT_CONVERSION_UNCOMPRESSED, n, ctx);
        BN_bn2bin(n, result.mutableBytes);
        BN_free(n);
    }
    
    BN_free(prv);
    EC_POINT_free(pub);
    EC_KEY_free(key);
    BN_CTX_free(ctx);
    
    return result;
}

@end

@implementation CryptoHash

+ (NSData *)sha256:(NSData *)data {
    NSMutableData *result = [NSMutableData dataWithLength:SHA256_DIGEST_LENGTH];
    SHA256(data.bytes, data.length, result.mutableBytes);
    return result;
}

+ (NSData *)sha256sha256:(NSData *)data {
    return [self sha256:[self sha256:data]];
}

+ (NSData *)ripemd160:(NSData *)data {
    NSMutableData *result = [NSMutableData dataWithLength:RIPEMD160_DIGEST_LENGTH];
    RIPEMD160(data.bytes, data.length, result.mutableBytes);
    return result;
}

+ (NSData *)sha256ripemd160:(NSData *)data {
    return [self ripemd160:[self sha256:data]];
}

+ (NSData *)hmacsha512:(NSData *)data key:(NSData *)key {
    unsigned int length = SHA512_DIGEST_LENGTH;
    NSMutableData *result = [NSMutableData dataWithLength:length];
    HMAC(EVP_sha512(), key.bytes, (int)key.length, data.bytes, data.length, result.mutableBytes, &length);
    return result;
}

@end

@implementation PKCS5
+ (NSData *)PBKDF2:(NSData *)password salt:(NSData *)salt iterations:(NSInteger)iterations keyLength:(NSInteger)keyLength {
    NSMutableData *result = [NSMutableData dataWithLength:keyLength];
    PKCS5_PBKDF2_HMAC(password.bytes, (int)password.length, salt.bytes, (int)salt.length, (int)iterations, EVP_sha512(), (int)keyLength, result.mutableBytes);
    return result;
}
@end
