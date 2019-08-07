//
//  YJYOrderReceiveMoneyController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/22.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
typedef void(^YJYOrderReceiveMoneyDidDoneBlock)();

@interface YJYOrderReceiveMoneyController : YJYViewController

@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSArray<NSString*> *settDateArray;
@property(nonatomic, readwrite) uint32_t workType;
@property (copy, nonatomic) YJYOrderReceiveMoneyDidDoneBlock didDoneBlock;

@end
