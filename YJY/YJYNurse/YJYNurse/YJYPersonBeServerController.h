//
//  YJYPersonBeServerController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYPersonBeServerController : YJYTableViewController
@property(nonatomic, readwrite) uint64_t kinsId;
@property (copy, nonatomic) NSString *insureNo;
@property (copy, nonatomic) NSString *orderId;
@property (assign, nonatomic) uint32_t pgStatus;
@property (copy, nonatomic) NSString *securityAssess;
@end
