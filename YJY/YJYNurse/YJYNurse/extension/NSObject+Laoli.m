//
//  NSObject+Laoli.m
//  DingBell
//
//  Created by 黄锡凯 on 2019/7/11.
//  Copyright © 2019 黄锡凯. All rights reserved.
//

#import "NSObject+Laoli.h"
#import <objc/runtime.h>

@implementation NSObject (Laoli)

- (NSDictionary *)conversionDict {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    Class cls = [self class];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *value = [self valueForKey:key];
        [dict setObject:value forKey:key];
    }
    
    return dict;
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    
    if (jsonData) jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

@end

