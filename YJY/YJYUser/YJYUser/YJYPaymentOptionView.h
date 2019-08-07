//
//  YJYPaymentOptionView.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YJYPaymentOption) {

    YJYPaymentOptionPocket,
    YJYPaymentOptionWechat,
    YJYPaymentOptionAlipay,

};


typedef void(^YJYPaymentOptionBlock)(YJYPaymentOption option);

@interface YJYPaymentOptionView : UIView

@property (copy, nonatomic) YJYPaymentOptionBlock paymentOptionBlock;

///使用钱包
@property(nonatomic, assign) BOOL usePurse;
///钱包余额
@property(nonatomic, copy) NSString *purse;

+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;

@end
