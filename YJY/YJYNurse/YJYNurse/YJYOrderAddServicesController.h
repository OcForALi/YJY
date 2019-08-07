//
//  YJYOrderAddServicesController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

typedef void(^DidEditServicesBlock)();

@interface YJYOrderAddServicesController : YJYViewController

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *affirmTime;

@property (assign, nonatomic) BOOL isShowCalendar;
@property (assign, nonatomic) BOOL isInsure;



@property (copy, nonatomic) DidEditServicesBlock didEditServicesBlock;


@end
