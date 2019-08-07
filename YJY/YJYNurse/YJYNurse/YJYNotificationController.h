//
//  YJYNotificationController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/2.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef void(^YJYNotificationDidLoaded)(BOOL isNofi);
@interface YJYNotificationController : YJYTableViewController

@property (assign, nonatomic) BOOL isFromPush;
@property (copy, nonatomic) YJYNotificationDidLoaded didLoaded;
@end
