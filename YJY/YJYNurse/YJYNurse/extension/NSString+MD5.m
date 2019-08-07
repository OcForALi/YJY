//
//  NSString+MD5.m
//  ServerProtocol
//
//  Created by zzg4321 on 12-11-20.
//  No Comment (c) 2012年 zzg4321. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
- (NSString*)MD5
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH ];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH ; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
@end
