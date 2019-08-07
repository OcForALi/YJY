//
//  IDCardNumberValidator.m
//  IDCardNumber-Validation-Demo
//
//  Created by Vincent on 2/26/16.
//  No Comment © 2016 Vincent. All rights reserved.
//

#import "IDCardNumberValidator.h"

@interface IDCardNumberValidator()



@end

@implementation IDCardNumberValidator
/// 验证身份证号码
+ (instancetype)validateIDCardNumber:(NSString *)idNumber {
    
    
    NSString *regex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X)$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:idNumber]) return nil;
    
    NSArray *proviceCodes = @[@"11", @"12", @"13", @"14", @"15",
                              @"21", @"22", @"23",
                              @"31", @"32", @"33", @"34", @"35", @"36", @"37",
                              @"41", @"42", @"43", @"44", @"45", @"46",
                              @"50", @"51", @"52", @"53", @"54",
                              @"61", @"62", @"63", @"64", @"65",
                              @"71", @"81", @"82", @"91"];
    
    IDCardNumberValidator *validator = [IDCardNumberValidator new];

//        NSString *zoneCode = [idNumber substringWithRange:NSMakeRange(0, 6)];
    NSString *brithday = [idNumber substringWithRange:NSMakeRange(6, 8)];
    NSInteger year = [[idNumber substringWithRange:NSMakeRange(6, 4)] integerValue];
    NSInteger month = [[idNumber substringWithRange:NSMakeRange(10, 2)] integerValue];
    NSInteger day = [[idNumber substringWithRange:NSMakeRange(12, 2)] integerValue];
    NSString *code = [idNumber substringWithRange:NSMakeRange(0, 2)];
    NSInteger gender = [[idNumber substringWithRange:NSMakeRange(16, 1)] integerValue];
   
    
    validator.isValidated = [self validate18DigitsIDCardNumber:idNumber];
    validator.isBirthday = [self validateBirthDate:brithday];
    validator.isBeyondBirthday = [self validateBirthDate:brithday];
    validator.isMouth = (month >= 1 && month <= 12);
    validator.isDay = (day >= 1 && day <= 31);
    validator.isZoneCode = [proviceCodes containsObject:code];
    
    
    NSInteger nowYear = [NSDate year:[NSDate date]];
    validator.age = (uint32_t)(nowYear - year);
    if (fmod(gender, 2))
        validator.sex = 1;
    else
        validator.sex = 2;
   

    return validator;
    
}



/// 18位身份证号码验证。6位行政区划代码 + 8位出生日期码(yyyyMMdd) + 3位顺序码 + 1位校验码
+ (BOOL)validate18DigitsIDCardNumber:(NSString *)idNumber {
    NSString *birthday = [idNumber substringWithRange:NSMakeRange(6, 8)];
    if (![self validateBirthDate:birthday]) return NO;
    
    // 验证校验码
    int weight[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    
    int sum = 0;
    for (int i = 0; i < 17; i ++) {
        sum += [idNumber substringWithRange:NSMakeRange(i, 1)].intValue * weight[i];
    }
    int mod11 = sum % 11;
    NSArray<NSString *> *validationCodes = [@"1 0 X 9 8 7 6 5 4 3 2" componentsSeparatedByString:@" "];
    NSString *validationCode = validationCodes[mod11];
    
    return [idNumber hasSuffix:validationCode];
}

/// 验证出生年月日(yyyyMMdd)
+ (BOOL)validateBirthDate:(NSString *)birthDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [dateFormatter dateFromString:birthDay];
    return date != nil;
}


@end
