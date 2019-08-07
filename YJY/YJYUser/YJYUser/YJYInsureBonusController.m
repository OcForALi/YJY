//
//  YJYInsureBonusController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/8.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureBonusController.h"
#import "YJYInsureBonusListController.h"

@interface YJYInsureBonusController ()
@property (weak, nonatomic) IBOutlet UILabel *beServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;


@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;


@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;


@end

@implementation YJYInsureBonusController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureBonusController *)[UIStoryboard storyboardWithName:@"YJYInsureDone" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //data
    [self reloadAccountData];
    [self setupControllers];
    [self setUpScrollView];
}

#pragma mark - data
- (void)reloadAccountData {
    
    self.beServiceLabel.text = [NSString stringWithFormat:@"被服务人: %@",self.account.kinsName] ;
    
    
    self.leftMoneyLabel.text = self.account.accountStr;
    [self.leftMoneyLabel sizeToFit];
    
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"服务中的长护险订单: %@ 单",@(self.account.orderNum)];
}
#pragma mark - Maunal
#define WLScreenW  [UIScreen mainScreen].bounds.size.width

- (void)setupControllers {
    
    self.viewControllers = [NSMutableArray array];
    
    NSArray *types =  @[@(0),@(1),@(2)];
    
    for (NSInteger i = 0; i < types.count; i++) {
        
        YJYInsureBonusListController *vc = [YJYInsureBonusListController instanceWithStoryBoard];
        vc.account = self.account;
        vc.orderId = self.orderId;
        CGFloat offsetX = i * WLScreenW;
        vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        vc.tabType = (u_int32_t)[types[i] integerValue];
        [self.contentScrollView addSubview:vc.view];
        
        
        [self.viewControllers addObject:vc];
        [self addChildViewController:vc];
    }
    [self itemAction:self.allButton manual:NO];
    
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
        [self.contentScrollView setContentOffset:CGPointMake((sender.tag-1) * WLScreenW, 0) animated:YES];
        
    }
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //   CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self itemAction:[self.headerView viewWithTag:index + 1] manual:NO];
    
    
    
}

@end
