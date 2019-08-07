//
//  YJYOrderEndServiceController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/24.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYOrderEndServiceDidDoneBlock)();
@interface YJYOrderEndServiceController : YJYViewController

@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *affirmTime;
@property(nonatomic, readwrite) NSString *hgName;
@property (copy, nonatomic) YJYOrderEndServiceDidDoneBlock didDoneBlock;
@end
