//
//  KeychainManager.m
//  zhuazhua
//
//  Created by guohao on 15/4/30.
//  No Comment (c) 2015年 guohao. All rights reserved.
//

#import "KeychainManager.h"

@implementation KeychainManager

+ (void)saveWithKey:(NSString*)key
              Value:(id)value {

    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString*)getValueWithKey:(NSString*)key{

    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}
+ (void)deleteValueithKey:(NSString*)key {

    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:key];
}
+ (void)saveKeychainWithKey:(NSString*)key
                      Value:(NSString*)value{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = key;
    NSString *password = value;
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;//声明保存的类型：在这里是一个通用密码
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;//声明保存的安全性：在这里是当手机解锁时可以读取
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
        
        /*OSStatus sts =*/ SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
//        NSLog(@"saveKeychainWithKey--Error Code: %d", (int)sts);
    }else{
        keychainItem[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding]; //Our password
        /*OSStatus sts =*/ SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        
    }
}

+ (NSString*)loadKeychainWithKey:(NSString*)key{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = key;
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    //keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists.
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
//    NSLog(@"loadKeychainWithKey--Error Code: %d", (int)sts);
    
    if(sts == noErr){
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
        return password;
    }else{
        return nil;
    }
}

+ (BOOL)deleteKeychainWithKey:(NSString*)key{
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSString *username = key;
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists.
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
//        NSLog(@"deleteKeychainWithKey--Error Code: %d", (int)sts);
        if ((int)sts == 0) {
            return YES;
        }
    }
    
    return NO;
}
@end
