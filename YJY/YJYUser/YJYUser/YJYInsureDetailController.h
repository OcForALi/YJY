//
//  YJYInsureDetailController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYInsureDetailController : YJYViewController
@property (copy, nonatomic) NSString *insreNO;
@property (copy, nonatomic) NSString *insureNO;
@property (copy, nonatomic) NSString *orderId;

@property (assign, nonatomic) BOOL isProcess;
+ (instancetype)instanceWithStoryBoard;
@end
