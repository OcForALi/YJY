//
//  YJYTimePicker.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimePickerDidSelectBlock)(TimeData *currentTimeData,OrderTimeData *orderTimeData);

@interface YJYTimePicker : UIView

@property (copy, nonatomic) TimePickerDidSelectBlock timePickerDidSelectBlock;

+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;
- (void)loadNetwork;

/// 订单类型 1-机构 2-居家
@property (assign, nonatomic) NSInteger orderType;

@end
