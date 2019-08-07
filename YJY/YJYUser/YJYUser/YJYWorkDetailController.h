//
//  YJYWorkDetailController.h
//  YJYUser
//
//  Created by wusonghe on 2018/2/26.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYWorkDetailController : YJYTableViewController


@property(nonatomic, readwrite) NSString *orderId;

/// 1-护工 2-护士
@property(nonatomic, readwrite) uint32_t hgType;

@end
