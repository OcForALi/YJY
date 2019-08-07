//
//  YJYMyOrderView.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/30.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderCurrent;


typedef void(^OrderViewDidSelectBlock)(OrderCurrent *order);
@interface YJYMyOrderView : UIView

@property (strong, nonatomic) OrderCurrent *order;
@property (copy, nonatomic) OrderViewDidSelectBlock orderViewDidSelectBlock;

+ (instancetype)instancetypeWithXIB;

@end
