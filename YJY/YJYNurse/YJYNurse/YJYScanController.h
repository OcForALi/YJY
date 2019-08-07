//
//  YJYScanController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/8/2.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
#import <LBXScanViewController.h>

typedef void(^YJYScanDidResultBlock)(NSString *result);


@interface YJYScanController : LBXScanViewController

+ (instancetype)presentWithInVC:(UIViewController *)vc;
@property (copy, nonatomic) YJYScanDidResultBlock didResultBlock;
@end
