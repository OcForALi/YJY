//
//  YJYMineViewController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYMineViewController.h"
#import "YJYMineDataController.h"
#import "YJYNotificationController.h"
#import "YJYSettingViewController.h"
@interface YJYMineViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;

@property (weak, nonatomic) IBOutlet UILabel *notiView;

@end

@implementation YJYMineViewController

#pragma mark - Maunal
#define WLScreenW  [UIScreen mainScreen].bounds.size.width


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYMineViewController *)[UIStoryboard storyboardWithName:@"Main" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notiView.layer.cornerRadius = 10;
    self.notiView.hidden = YES;
    [self setupControllers];
    [self setUpScrollView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectMsgIndex:) name:kYJYMessageIndexSelectNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];
 
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self navigationBarAlphaWithWhiteTint];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];

    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - setup


- (void)selectMsgIndex {
    
    [self itemAction:[self.headerView viewWithTag:1+10] manual:NO];

}
- (void)setupControllers {
    
    self.viewControllers = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 2; i++) {
        

        UIViewController *vc;
        if (i == 0) {
            YJYMineDataController *vc = [YJYMineDataController instanceWithStoryBoard];
            [(YJYMineDataController *)vc setAvatorView:self.avatorView];
            [self.viewControllers addObject:vc];
            CGFloat offsetX = i * WLScreenW;
            
            vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
            [self.contentScrollView addSubview:vc.view];
            
            
            [self addChildViewController:vc];

        }else {
            YJYNotificationController *vc =  [YJYNotificationController instanceWithStoryBoard];
            vc.didLoaded = ^(BOOL isNofi) {
                self.notiView.hidden = !isNofi;

            };
            [self.viewControllers addObject:vc];
            CGFloat offsetX = i * WLScreenW;
            
            vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
            [self.contentScrollView addSubview:vc.view];
            
            
            [self addChildViewController:vc];

            
        }
        
        
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
    
    if (manual) {
        NSInteger index  = sender.tag - 10;
        [self.contentScrollView setContentOffset:CGPointMake(index * WLScreenW, 0) animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.lineView.frame = CGRectMake(self.lineView.frame.size.width * index, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
            
        }];
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //   CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self itemAction:[self.headerView viewWithTag:index + 10] manual:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.lineView.frame = CGRectMake(self.lineView.frame.size.width * index, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
        
    }];
    
    
}
#pragma mark - Action

- (IBAction)toSettingAction:(id)sender {
    
    YJYSettingViewController *vc = [YJYSettingViewController instanceWithStoryBoard];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
