//
//  IDCardNumberValidator.h
//  IDCardNumber-Validation-Demo
//
//  Created by Vincent on 2/26/16.
//  No Comment © 2016 Vincent. All rights reserved.
//

//1 身份证无效，不是合法的身份证号码
//2 身份证号码长度应该为15位或18位

//3 身份证生日无效
//4 身份证生日不在有效范围
//5 身份证月份无效
//6 身份证日期无效
//7 身份证地区编码错误
//身份证输入错误的情况下，性别和年龄那一项都置为空。

#import <Foundation/Foundation.h>

@interface IDCardNumberValidator : NSObject

@property (copy, nonatomic) NSString *identifierID;
@property (assign, nonatomic) uint32_t sex;
@property (assign, nonatomic) uint32_t age;

@property (assign, nonatomic) BOOL isValidated;
@property (assign, nonatomic) BOOL isBirthday;
@property (assign, nonatomic) BOOL isBeyondBirthday;
@property (assign, nonatomic) BOOL isMouth;
@property (assign, nonatomic) BOOL isDay;
@property (assign, nonatomic) BOOL isZoneCode;

+ (instancetype)validateIDCardNumber:(NSString *)idNumber;

@end
