//
//  NSString+Extension.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/24.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (NSAttributedString *)attributedStringWithLineSpacing:(CGFloat)lineSpacing;
+ (NSInteger)numberOfLinesWithLabel:(UILabel *)label;
+ (NSInteger)numberOfLinesWithText:(NSString *)text
                              font:(UIFont *)font
                             width:(CGFloat)width;
+ (CGFloat)heightWithText:(NSString *)text
                     font:(UIFont *)font
                    width:(CGFloat)width;

+ (NSString *)yjy_ContactStringWithContact:(NSString *)contact
                                     phone:(NSString *)phone;
+ (NSString *)yjy_PhoneNumberStringWithOrigin:(NSString *)origin;
@end
