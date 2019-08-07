//
//  YJYInsureAddReviewController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYInsureAddReviewDidDoneBlock)();

@interface YJYInsureAddReviewController : YJYViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (copy, nonatomic) YJYInsureAddReviewDidDoneBlock didDoneBlock;

@end
