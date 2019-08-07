//
//  YJYInsureBonusListController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/12.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureBonusListController : YJYTableViewController
@property (assign, nonatomic) uint32_t tabType;
@property (copy, nonatomic) NSString *orderId;

+ (instancetype)instanceWithStoryBoard;
@end
