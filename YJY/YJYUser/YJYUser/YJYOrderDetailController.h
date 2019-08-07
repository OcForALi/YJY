//
//  YJYOrderDetailController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface YJYOrderDetailController : YJYViewController

typedef void(^DetailDidActionBlock)();
typedef void(^YJYOrderDetailDidPayBlock)();

@property (strong, nonatomic) OrderVO *order;
@property (strong, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL isPrivate;
@property (assign, nonatomic) BOOL fromBooking;
@property (copy, nonatomic) DetailDidActionBlock detailDidActionBlock;
+ (instancetype)instanceWithStoryBoard;

@end
