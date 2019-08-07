//
//  YJYOrdersController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLongNursesController.h"
#import "YJYLongNurseListController.h"


@interface YJYLongNursesController ()<UIScrollViewDelegate,UISearchBarDelegate>


@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) UIButton *selectedButton;

//header
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *buttons;



@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) ReviewListItem *currentReviewListItem;
@property (assign, nonatomic) YJYRoleType roleType;

@end

@implementation YJYLongNursesController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLongNursesController *)[UIStoryboard storyboardWithName:@"YJYLongNurse" viewControllerIdentifier:NSStringFromClass(self)];
}

#pragma mark - Maunal
#define WLScreenW  [UIScreen mainScreen].bounds.size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:APPSaasF4Color];
        searchField.layer.cornerRadius = 10.0f;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.roleType != [YJYRoleManager sharedInstance].roleType) {
        
        [self setupHeaderItems];
        [self setupControllers];
        [self setUpScrollView];
    }
    
    self.roleType = [YJYRoleManager sharedInstance].roleType;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.headerView yjy_setBottomShadow];
    
}


- (void)setupHeaderItems{
    
    
    for (UIView *subView in self.headerScrollView.subviews) {
        [subView removeFromSuperview];
    }

    NSArray *items = [[YJYRoleManager sharedInstance]longNurseListItems];
    CGFloat width = self.view.frame.size.width/items.count;
    CGFloat height = self.headerScrollView.frame.size.height;
    
    self.buttons = [NSMutableArray array];
    for (NSInteger i = 0; i < items.count; i ++) {
        
        ReviewListItem *item = items[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 0, width, height);
        [button setTitle:item.title forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
        
        [button setTitleColor:APPNurseGrayCOLOR forState:UIControlStateNormal];
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
    [self.headerScrollView setContentSize:CGSizeMake(items.count * width, height)];
    
}
- (void)setupControllers {
    
    
    for (UIViewController *childViewController in self.childViewControllers) {
        [childViewController removeFromParentViewController];
    }
    
    self.viewControllers = [NSMutableArray array];
    
    NSArray *items = [[YJYRoleManager sharedInstance]longNurseListItems];
    
    for (NSInteger i = 0; i < items.count; i++) {
        
        YJYLongNurseListController *vc = [YJYLongNurseListController instanceWithStoryBoard];
        CGFloat offsetX = i * WLScreenW;
        vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        vc.listItem = items[i];
        vc.actionType = self.actionType;
        vc.didEndScrollBlock = ^{
            
            [self.searchBar resignFirstResponder];
            
        };
        [self.contentScrollView addSubview:vc.view];
        
        
        [self.viewControllers addObject:vc];
        [self addChildViewController:vc];
    }
    self.currentReviewListItem = items[0];
    
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
    self.currentReviewListItem = [[YJYRoleManager sharedInstance]longNurseListItems][sender.tag];
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYAssessUpdateNotification object:self.searchBar.text userInfo:nil];

    NSInteger index  = sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.lineView.frame = CGRectMake(self.lineView.frame.size.width * index, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
        self.headerScrollView.mj_offsetX = (index > 3) ? index * 2 : 0;

    }];
    if (manual) {
        [self.contentScrollView setContentOffset:CGPointMake(index * WLScreenW, 0) animated:YES];

    }
    
}




- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {

    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYAssessUpdateNotification object:searchText userInfo:nil];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;

    if (index < _buttons.count) {
        
        [self itemAction:self.buttons[index] manual:YES];

    }
    

    
    
}

@end
