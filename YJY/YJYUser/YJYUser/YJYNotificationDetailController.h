//
//  YJYNotificationDetailController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/6.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYNotificationDetailController : YJYTableViewController

@property(nonatomic, assign) uint32_t msgType;


+ (instancetype)instanceWithStoryBoard;

@end
