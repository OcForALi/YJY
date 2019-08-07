//
//  YJYInsurePaidController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/22.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYInsurePaidController : YJYViewController

@property (strong, nonatomic) GetInsureRsp *rsp;
@property (copy, nonatomic) NSString *insureNo;
@property (copy, nonatomic) NSString *depositFee;
@property (copy, nonatomic) NSString *purse;
@property (assign, nonatomic) BOOL usePurse;

+ (instancetype)instanceWithStoryBoard;
@end
