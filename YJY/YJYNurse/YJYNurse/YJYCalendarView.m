//
//  YJYCalendarView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYCalendarView.h"

@interface YJYCalendarView()<FSCalendarDelegate,FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet UIView *calenderContainView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end



@implementation YJYCalendarView

+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2;
    self.cancelButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.cancelButton.layer.borderWidth = 1;
    
    self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.height/2;
    self.confirmButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.confirmButton.layer.borderWidth = 1;
    
    [self setupFSCalendar];

//
}


- (void)setupFSCalendar {

    
    self.calendar = [[FSCalendar alloc] initWithFrame:self.calenderContainView.bounds];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    
    self.calendar.appearance.selectionColor = APPHEXCOLOR;
    self.calendar.appearance.headerTitleColor = APPHEXCOLOR;
    self.calendar.appearance.weekdayTextColor = APPHEXCOLOR;
    self.calendar.appearance.todayColor = APPHEXCOLOR;

    self.calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:16];
    
    [self.calenderContainView addSubview:self.calendar];

}

- (void)setSelectedDate:(NSDate *)selectedDate {
    
    _selectedDate = selectedDate;
    self.calendar.today = self.selectedDate;
    self.calendar.currentPage = self.selectedDate;
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.calendar.frame = CGRectMake(0, 0, self.frame.size.width, self.calenderContainView.bounds.size.height) ;
}

#pragma mark - show & hide
#define kActionViewHeight 400
- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.5);
    self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
- (IBAction)closeAction:(id)sender {
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    [self hidden];
}
- (IBAction)confirmAction:(id)sender {
    
    if (self.didConfirmBlock) {
        self.didConfirmBlock(self.selectedDate);
    }
    self.calendar.currentPage = self.selectedDate;
//    self.calendar.selectedDate = self.selectedDate;
    

    [self hidden];

   
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {

    if (self.disableBefore && [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:- 3600 * 24]] < 0) {
        
        return NO;
    }else {
    
        return YES;
    }
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
   
    self.selectedDate = date;

}


@end
