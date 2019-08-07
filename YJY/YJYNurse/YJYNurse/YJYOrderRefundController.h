//
//  YJYOrderRefundController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/11/1.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYOrderRefundDidDoneBlock)();

@interface YJYOrderRefundController : YJYViewController

@property (strong, nonatomic) OrderVO *orderVo;
@property (strong, nonatomic)  GetOrderInfoRsp *orderInfoRsp;
@property (assign, nonatomic) BOOL isDudao;
@property (copy, nonatomic) YJYOrderRefundDidDoneBlock didDoneBlock;
@end
