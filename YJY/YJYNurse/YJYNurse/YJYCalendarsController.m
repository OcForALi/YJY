//
//  YJYCalendarsController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/12.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYCalendarsController.h"
#import "YJYMyCalendarController.h"
#import "YJYCalendarView.h"

@interface YJYCalendarsController ()<UIScrollViewDelegate>
//header

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *selectedDate;
@property (weak, nonatomic) IBOutlet UILabel *todayDate;
@property (strong, nonatomic) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

//buttons
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *selectedButton;

//contentScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

//datas
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) OrderListItem *currentOrderListItem;
@property (strong, nonatomic) YJYMyCalendarController *currentViewController;
@property (assign, nonatomic) YJYRoleType roleType;

@property (assign, nonatomic) CGFloat extraWidth;



@end

@implementation YJYCalendarsController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYCalendarsController *)[UIStoryboard storyboardWithName:@"YJYCalendars" viewControllerIdentifier:NSStringFromClass(self)];
}

#pragma mark - Maunal
#define WLScreenW  [UIScreen mainScreen].bounds.size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentDate = [NSDate date];
    self.todayDate.text = [NSString stringWithFormat:@"今天是%@",[NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD]];
    self.selectedDate.text = [NSString stringWithFormat:@"%@",[NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD]];
    
    [self setupHeaderItems];
    [self setupControllers];
    [self setUpScrollView];
    [self setupIndex];
}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];

}
- (void)setupIndex {
    NSArray *items = [[YJYRoleManager sharedInstance] calendarsListItems];
    
    for (NSInteger i = 0; i < items.count; i++) {
        CalendarListItem *item = items[i];
        if (item.type == self.index) {
            [self itemAction:self.buttons[i] manual:YES];
            break;
        }
    }
}

- (void)setupHeaderItems{
    
    
    for (UIView *subView in self.headerScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSArray *items = [[YJYRoleManager sharedInstance]calendarsListItems];
    
    self.extraWidth = items.count > 4 ? 20 : 0;
    CGFloat width = self.view.frame.size.width/items.count + self.extraWidth;
    CGFloat height = self.headerScrollView.frame.size.height;
    
    
    self.buttons = [NSMutableArray array];
    for (NSUInteger i = 0; i < items.count; i ++) {
        
        CalendarListItem *item = items[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 0, width, height);
        [button setTitle:item.title forState:0];
        
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
        [button setTitleColor:APPNurseGray30COLOR forState:UIControlStateNormal];
        [button setTitleColor:APPHEXCOLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.buttons addObject:button];
        
        if (i == 0) {
            button.selected = YES;
            self.selectedButton = button;
        }
        
        [self.headerScrollView addSubview:button];
    }
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-3, width, 3)];
    self.lineView.backgroundColor = APPHEXCOLOR;
    [self.headerScrollView addSubview:self.lineView];
    
    self.headerScrollView.delegate = self;
    [self.headerScrollView setContentSize:CGSizeMake(items.count * width, height)];
    self.currentOrderListItem = items[0];
}
- (void)setupControllers {
    
    
    for (UIViewController *childViewController in self.childViewControllers) {
        [childViewController removeFromParentViewController];
    }
    
    self.viewControllers = [NSMutableArray array];
    
    NSArray *items = [[YJYRoleManager sharedInstance] calendarsListItems];
    
    
    for (NSInteger i = 0; i < items.count; i++) {
        
        YJYMyCalendarController *vc = [YJYMyCalendarController instanceWithStoryBoard];
        vc.listItem = items[i];

        CGFloat offsetX = i * WLScreenW;
        vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        [self.contentScrollView addSubview:vc.view];
        
        
        [self.viewControllers addObject:vc];
        [self addChildViewController:vc];
    }
}

- (void)setUpScrollView
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSUInteger count = self.childViewControllers.count;
    self.contentScrollView.contentSize = CGSizeMake(count * WLScreenW, 0);
    
    
}



- (IBAction)itemAction:(UIButton *)sender {
    
    [self itemAction:sender manual:YES];
}


- (void)itemAction:(UIButton *)sender manual:(BOOL)manual {
    
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    self.currentOrderListItem = [[YJYRoleManager sharedInstance]orderListItems][sender.tag];
    self.currentViewController = self.viewControllers[sender.tag];
    
    NSInteger index  = sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.lineView.frame = CGRectMake(self.lineView.frame.size.width * index, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
        
        if (self.extraWidth > 0) {
            self.headerScrollView.mj_offsetX = (self.extraWidth + 3) * index;
            
        }
    }];
    
    if (manual) {
        [self.contentScrollView setContentOffset:CGPointMake(index * WLScreenW, 0) animated:YES];
    }
    
    
}




- (IBAction)showCalendar:(id)sender {
    
    YJYCalendarView *calendarView = [YJYCalendarView instancetypeWithXIB];
    calendarView.frame = self.view.frame;
    calendarView.selectedDate = self.currentDate;
    [calendarView layoutSubviews];
    [calendarView showInView:nil];
    
    calendarView.didConfirmBlock = ^(NSDate *date) {
        
        NSString *dataString = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
        self.selectedDate.text = dataString;
        [self.selectedDate sizeToFit];
        self.currentDate = date;
    };
    
}
- (void)setCurrentDate:(NSDate *)currentDate {
    
    _currentDate = currentDate;
    self.currentViewController.currentDate = currentDate;
    
}

@end
