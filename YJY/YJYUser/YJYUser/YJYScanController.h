//
//  YJYScanController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <LBXScanViewController.h>

typedef void(^YJYScanDidResultBlock)(NSString *result);
typedef void(^YJYScanDidReplayBlock)();


@interface YJYScanController : LBXScanViewController

+ (instancetype)presentWithInVC:(UIViewController *)vc;
@property (strong, nonatomic) OrgDistanceModel *org;
@property (copy, nonatomic) YJYScanDidResultBlock didResultBlock;
@property (copy, nonatomic) YJYScanDidReplayBlock didReplayBlock;
@end
