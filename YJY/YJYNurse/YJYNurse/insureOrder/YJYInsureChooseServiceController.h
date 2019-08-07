//
//  YJYInsureChooseServiceController.h
//  YJYUser
//
//  Created by wusonghe on 2018/2/7.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureChooseServiceController : YJYTableViewController

@property (copy, nonatomic) NSString *insureNo;
@property (copy, nonatomic) NSString *orderId;
@property(nonatomic, readwrite) uint32_t serviceType;

@end
