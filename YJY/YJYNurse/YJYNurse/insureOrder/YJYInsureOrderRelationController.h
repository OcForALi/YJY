//
//  YJYInsureOrderRelationController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYInsureOrderRelationDidDoneBlock)();

@interface YJYInsureOrderRelationController : YJYViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (copy, nonatomic) YJYInsureOrderRelationDidDoneBlock didDoneBlock;
@end
