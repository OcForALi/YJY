//
//  YJYInsureBonusController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/8.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureBonusController : YJYViewController
@property (strong, nonatomic) OrderVO *order;
@property (copy, nonatomic) NSString *orderId;
+ (instancetype)instanceWithStoryBoard;
@end
