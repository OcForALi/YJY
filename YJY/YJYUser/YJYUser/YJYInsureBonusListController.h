//
//  YJYInsureBonusListController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/12.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureBonusListController : YJYTableViewController
@property (assign, nonatomic) uint32_t tabType;
@property (strong, nonatomic) InsureAccountVO *account;
@property (copy, nonatomic) NSString *orderId;

+ (instancetype)instanceWithStoryBoard;
@end
