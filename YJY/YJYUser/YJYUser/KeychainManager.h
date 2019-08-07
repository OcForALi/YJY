//
//  KeychainManager.h
//  zhuazhua
//
//  Created by guohao on 15/4/30.
//  No Comment (c) 2015年 guohao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainManager : NSObject
//+ (NSString*)loadKeychainWithKey:(NSString*)key;
//+ (void)saveKeychainWithKey:(NSString*)key
//                      Value:(NSString*)value;
+ (BOOL)deleteKeychainWithKey:(NSString*)key;

+ (void)saveWithKey:(NSString*)key
              Value:(id)value;

+ (NSString*)getValueWithKey:(NSString*)key;
+ (void)deleteValueithKey:(NSString*)key;




@end
