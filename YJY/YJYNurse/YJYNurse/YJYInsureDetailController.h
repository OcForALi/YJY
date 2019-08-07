//
//  YJYAddInsureDetailController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/10/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
typedef void(^YJYInsureCreateDidDismissBlock)();

@interface YJYInsureDetailController : YJYViewController


@property (strong, nonatomic) NSString *insureNo;
@property (strong, nonatomic) NSString *insreNO;

@property (assign, nonatomic) BOOL hasToBackRoot;

@property (copy, nonatomic) YJYInsureCreateDidDismissBlock didDismissBlock;

@end
