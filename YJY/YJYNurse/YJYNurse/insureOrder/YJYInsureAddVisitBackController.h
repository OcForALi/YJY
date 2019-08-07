//
//  YJYInsureAddVisitBackController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/16.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYInsureAddVisitBackDidDoneBlock)();

@interface YJYInsureAddVisitBackController : YJYViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) InsureOrderVisitVO *insureOrderVisitVO;
@property (copy, nonatomic) YJYInsureAddVisitBackDidDoneBlock didDoneBlock;

@end
