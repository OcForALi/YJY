//
//  YJYAdjustRebateView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYInsureTimeChooseViewDidComfireBlock)(id result);
typedef void(^YJYInsureTimeChooseViewDidCancelBlock)();

@interface YJYInsureTimeChooseView : UIView

@property (strong, nonatomic) NSString *today;
@property (strong, nonatomic) NSString *receptionDay;


+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;

@property (copy, nonatomic) YJYInsureTimeChooseViewDidCancelBlock didCancelBlock;
@property (copy, nonatomic) YJYInsureTimeChooseViewDidComfireBlock didComfireBlock;

@end
