//
//  YJYOrderPayOffDailyController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYOrderPayOffDailyController : YJYViewController
@property (strong, nonatomic) OrderVO *order;
@property (copy, nonatomic) NSString *settDate;
+ (instancetype)instanceWithStoryBoard;
@end
