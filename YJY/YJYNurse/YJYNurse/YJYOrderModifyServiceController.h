//
//  YJYOrderModifyServiceController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//


typedef void(^YJYOrderModifyServiceDidDoneBlock)();

@interface YJYOrderModifyServiceController : YJYViewController


//data
@property (strong, nonatomic) OrderVO *order;
@property (strong, nonatomic) NSArray *priceName;
@property (assign, nonatomic) BOOL showPhone;

@property (copy, nonatomic) YJYOrderModifyServiceDidDoneBlock didDoneBlock;
@end
