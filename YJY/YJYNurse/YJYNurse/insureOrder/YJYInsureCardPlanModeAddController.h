//
//  YJYInsureCardPlanModeAddController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/20.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYInsureCardPlanModeAddDidDoneBlock)(NSArray *tendDetailsM);

@interface YJYInsureCardPlanModeAddController : YJYViewController
@property (strong, nonatomic) InsureOrderTendDetailBO *insureOrderTendDetailBO;
@property (copy, nonatomic) YJYInsureCardPlanModeAddDidDoneBlock didDoneBlock;

@end
