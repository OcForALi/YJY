//
//  YJYOrderPayOffController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/9.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"


@interface YJYOrderPayOffController : YJYViewController

@property (assign, nonatomic) BOOL isModifyPayOff;
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSArray<NSString*> *settDateArray;
@property (strong, nonatomic)  GetOrderInfoRsp *orderInfoRsp;

@property (copy, nonatomic) YJYDidDoneBlock didDoneBlock;
@end
