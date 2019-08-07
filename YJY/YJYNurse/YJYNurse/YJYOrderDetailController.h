//
//  YJYOrderDetailController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/5/31.
//  No Comment © 2017年 samwuu. All rights reserved.
//

typedef void(^YJYOrderDetailDidDismiss)();

@interface YJYOrderDetailController : YJYViewController
@property (strong, nonatomic) OrderListVO *orderListVO;
@property (copy, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL fromCreate;
@property (assign, nonatomic) BOOL isToRoot;
@property (assign, nonatomic) BOOL isReSign;
@property (copy, nonatomic) YJYOrderDetailDidDismiss didDismiss;
@end
