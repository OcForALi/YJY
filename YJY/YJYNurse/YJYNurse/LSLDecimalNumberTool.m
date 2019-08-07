//
//  LSLDecimalNumberTool.m
//  YJYNurse
//
//  Created by wusonghe on 2018/7/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "LSLDecimalNumberTool.h"

@implementation LSLDecimalNumberTool

+ (float)floatWithdecimalNumber:(double)num {
    return [[self decimalNumber:num] floatValue];
}

+ (double)doubleWithdecimalNumber:(double)num {
    return [[self decimalNumber:num] doubleValue];
}

+ (NSString *)stringWithDecimalNumber:(double)num {
    return [[self decimalNumber:num] stringValue];
}

+ (NSDecimalNumber *)decimalNumber:(double)num {
    NSString *numString = [NSString stringWithFormat:@"%lf", num];
    return [NSDecimalNumber decimalNumberWithString:numString];
}


@end
