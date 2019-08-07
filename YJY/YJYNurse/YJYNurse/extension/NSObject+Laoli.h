//
//  NSObject+Laoli.h
//  DingBell
//
//  Created by 黄锡凯 on 2019/7/11.
//  Copyright © 2019 黄锡凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Laoli)

/**
 *  转换字典
 *
 *  @return 字典
 */
- (NSDictionary *)conversionDict;

/**
 *  字典转换Json
 *
 *  @param dict 字典
 *  @return JsonString
 */
- (NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 *  JsonString转换字典
 *
 *  @param jsonString Json
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
