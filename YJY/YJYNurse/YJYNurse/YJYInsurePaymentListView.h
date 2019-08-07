//
//  YJYInsurePaymentListView.h
//  YJYNurse
//
//  Created by wusonghe on 2018/4/18.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYInsurePaymentListViewDidDoneBlock)(id result);
typedef void(^YJYInsurePaymentListViewDidHidden)();

@interface YJYInsurePaymentListView : UIView

@property (strong, nonatomic) NSMutableArray *datasource;

@property (copy, nonatomic) YJYInsurePaymentListViewDidDoneBlock didDoneBlock ;
@property (copy, nonatomic) YJYInsurePaymentListViewDidHidden didHidden ;

+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;
@end
