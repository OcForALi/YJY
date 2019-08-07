//
//  YJYInsureOrderRelationController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYInsureOrderContactUpdateDidDoneBlock)();

@interface YJYInsureOrderContactUpdateController : YJYViewController

@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (copy, nonatomic) YJYInsureOrderContactUpdateDidDoneBlock didDoneBlock;

@end
