//
//  YJYAdjustRebateView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYAdjustRebateViewDidComfireBlock)();
typedef void(^YJYAdjustRebateViewDidCancelBlock)();

@interface YJYAdjustRebateView : UIView

@property (strong, nonatomic) NSString *orderId;


+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;

@property (copy, nonatomic) YJYAdjustRebateViewDidCancelBlock didCancelBlock;
@property (copy, nonatomic) YJYAdjustRebateViewDidComfireBlock didComfireBlock;

@end
