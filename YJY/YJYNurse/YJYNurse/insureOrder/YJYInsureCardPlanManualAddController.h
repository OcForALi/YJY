//
//  YJYInsureCardPlanManualAddController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/20.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYInsureCardPlanManualDidDoneBlock)();

@interface YJYInsureCardPlanManualAddController : YJYViewController
@property (strong, nonatomic) InsureOrderTendDetailBO *insureOrderTendDetailBO;
@property (strong, nonatomic) GetOrderTendDetailRsp *tendDetailRsp;

@property (copy, nonatomic) YJYInsureCardPlanManualDidDoneBlock didDoneBlock;

@end
