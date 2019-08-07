//
//  YJYChargeSuccessController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/14.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidEnterBlock)();
typedef void(^DidDismissBlock)();

@interface YJYChargeSuccessController : YJYViewController

@property (assign, nonatomic) BOOL isCharge;

@property (copy, nonatomic) NSString *balance;
@property (copy, nonatomic) NSString *charge;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@property (copy, nonatomic) DidEnterBlock didEnterBlock;
@property (copy, nonatomic) DidDismissBlock didDismissBlock;
@property (strong, nonatomic) UIViewController *presentVC;
+ (instancetype)instanceWithStoryBoard;

@end
