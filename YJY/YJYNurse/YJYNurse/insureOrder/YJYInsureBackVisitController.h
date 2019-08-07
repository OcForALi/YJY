//
//  YJYInsureBackVisitController.h
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef void(^YJYInsureBackVisitDidDoneBlock)();
@interface YJYInsureBackVisitController : YJYViewController

@property (strong, nonatomic) InsureOrderVisitVO *insureOrderVisitVO;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;

@property (copy, nonatomic) YJYInsureBackVisitDidDoneBlock didDoneBlock;

/// id
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *visitId;
@end
