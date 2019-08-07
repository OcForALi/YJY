//
//  YJYPayOffComfireAddController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef NS_ENUM(NSInteger, YJYPrimeType) {
    
    YJYPrimeTypeNone = 4,
    YJYPrimeTypeEmployeeFamily = 5,
    YJYPrimeTypeEmployee = 6,
};

@interface YJYPayOffComfireAddController : YJYViewController

@property (assign, nonatomic) YJYOrderState orderState;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *affirmTime;

@end
