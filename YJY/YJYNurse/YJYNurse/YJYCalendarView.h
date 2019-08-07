//
//  YJYCalendarView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/5/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar.h>

typedef void(^YJYCalendarDidConfirmBlock)(id result);
typedef void(^YJYCalendarDidCancelBlock)();
@interface YJYCalendarView : UIView

@property (copy, nonatomic) YJYCalendarDidConfirmBlock didConfirmBlock;
@property (copy, nonatomic) YJYCalendarDidCancelBlock didCancelBlock;

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) FSCalendar *calendar;

@property (assign, nonatomic) BOOL disableBefore;

+ (instancetype)instancetypeWithXIB;
- (void)showInView:(UIView *)view;
- (void)hidden;
@end
