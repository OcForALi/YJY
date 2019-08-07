//
//  YJYOrdersController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrdersController.h"
#import "YJYOrderListController.h"


@interface YJYOrdersController ()<UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *pageView;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation YJYOrdersController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrdersController *)[UIStoryboard storyboardWithName:@"YJYOrder" viewControllerIdentifier:NSStringFromClass(self)];
}

#pragma mark - Maunal
#define WLScreenW  [UIScreen mainScreen].bounds.size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupControllers];
    [self setUpScrollView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectOneIndex:) name:kYJYTabBarIndexSelectNotification object:nil];

}
- (void)setupControllers {

    self.viewControllers = [NSMutableArray array];
    
    NSArray *types =  @[@(OrderListTypeAll),@(OrderListTypeProcess),@(OrderListTypeFinish)];
    
    for (NSInteger i = 0; i < types.count; i++) {
        
        YJYOrderListController *vc = [YJYOrderListController instanceWithStoryBoard];
        
        CGFloat offsetX = i * WLScreenW;
        vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        vc.orderListType = [types[i] integerValue];
        [self.contentScrollView addSubview:vc.view];

        
        [self.viewControllers addObject:vc];
        [self addChildViewController:vc];
    }
    [self itemAction:[self.headerView viewWithTag:0+10] manual:NO];

}

// 初始化UIScrollView
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
    
    if (manual) {
        OrderListType type = sender.tag - 10;
        [self.contentScrollView setContentOffset:CGPointMake(type * WLScreenW, 0) animated:YES];
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self itemAction:[self.headerView viewWithTag:index + 10] manual:NO];

}

- (void)selectOneIndex:(id)sender {
    
    [self itemAction:self.oneButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderListUpdateNotification object:nil];

    });

    
}

@end
