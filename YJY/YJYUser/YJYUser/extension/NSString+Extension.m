//
//  NSString+Extension.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/24.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSAttributedString *)attributedStringWithLineSpacing:(CGFloat)lineSpacing{
    
    
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc]initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedString;
}
+ (NSInteger)numberOfLinesWithLabel:(UILabel *)label {

    NSString *text = label.text;
    UIFont *font = label.font;
    CGSize size = [text boundingRectWithSize:CGSizeMake(label.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    NSInteger lines = (NSInteger)(size.height / font.lineHeight);
    
    return lines;
   
    
}

+ (NSInteger)numberOfLinesWithText:(NSString *)text
                              font:(UIFont *)font
                             width:(CGFloat)width{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    double height = ceil(size.height);
    NSInteger lines = (NSInteger)(height / font.lineHeight);
    
    return lines;
    
    
}
+ (NSString *)yjy_ContactStringWithContact:(NSString *)contact
                                     phone:(NSString *)phone {
    
    if (phone.length == 0 && contact.length == 0) {
        return @"无";
    }
    NSString *space = contact.length > 0 ? @"  " : @"";
    NSString *htmltext =  [NSString stringWithFormat:@"%@%@%@",contact,space,[self yjy_PhoneNumberStringWithOrigin:phone]];
    
    if (phone.length > 0 && contact.length == 0) {
        htmltext =  [NSString stringWithFormat:@"%@",[self yjy_PhoneNumberStringWithOrigin:phone]];
        
    }
    
    return htmltext;
}

+ (NSString *)yjy_PhoneNumberStringWithOrigin:(NSString *)origin {
    
    return [NSString stringWithFormat:@"<a href='tel:%@'>%@</a>",origin,origin];
    
}


@end
