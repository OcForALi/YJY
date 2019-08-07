//
//  YJYOrderSettleController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/27.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYOrderSettleController : YJYViewController

@property (strong, nonatomic) OrderVO *order;
@property (strong, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL isToRoot;
@end
 
