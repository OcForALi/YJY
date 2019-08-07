//
//  YJYInsureCarePlanDetailController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/14.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef NS_ENUM(NSInteger, YJYInsureCarePlanDetailType) {
    
    
    YJYInsureCarePlanDetailTypeNormal,
    YJYInsureCarePlanDetailTypeAdd,
    YJYInsureCarePlanDetailTypeEdit,
};

typedef void(^YJYInsureCarePlanDetailDidDoneBlock)(uint64_t new_orderTendId);

@interface YJYInsureCarePlanDetailController : YJYViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) OrderTendVO *orderTendVO;
@property(nonatomic, readwrite) uint64_t orderTendId;

@property (assign, nonatomic) YJYInsureCarePlanDetailType detailType;

@property (assign, nonatomic) BOOL isEnter;

@property (copy, nonatomic) YJYInsureCarePlanDetailDidDoneBlock didDoneBlock;


//outdata
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *tendId;


@end
