//
//  YJYOrdersController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrdersController.h"
#import "YJYOrderListController.h"
#import "YJYBranchPicker.h"
#import "AppDelegate.h"

@interface YJYOrdersController ()<UIScrollViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *buttons;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

//datas
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) OrderListItem *currentOrderListItem;
@property (assign, nonatomic) YJYRoleType roleType;

@property (assign, nonatomic) CGFloat extraWidth;

@property (strong, nonatomic) IBOutlet UIView *rightItemView;

@property (strong, nonatomic) IBOutlet UIView *bigHeaderView;
@property (strong, nonatomic) IBOutlet UIView *optionView;
@property (strong, nonatomic) IBOutlet UILabel *filterTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *filterTimeDirectionImageView;
@property (strong, nonatomic) IBOutlet UILabel *filterBranchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *filterDirectionImageView;


@property (nonatomic, strong) OrgDistanceModel *currentOrgDistanceModel;
@property (nonatomic, strong) BranchModel *currentBranch;
@property (nonatomic, assign) uint32_t currentSortType;

@property (assign, nonatomic) BOOL onlyBranch;

@property (nonatomic ,strong) UIView *failedOrdersView;
@property (nonatomic ,strong) UILabel *notOrderLabel;
@property (nonatomic ,strong) UIButton *retryOrderButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewhConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigHeaderConstrainth;


@end

@implementation YJYOrdersController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrdersController *)[UIStoryboard storyboardWithName:@"Main" viewControllerIdentifier:NSStringFromClass(self)];
}

- (UIButton *)retryOrderButton{
    
    if (_retryOrderButton == nil) {
        _retryOrderButton = [[UIButton alloc] init];
        _retryOrderButton.frame = CGRectMake(self.view.frame.size.width - 140, 10, 80, 20);
        [_retryOrderButton setTitle:@"再次发布" forState:UIControlStateNormal];
        [_retryOrderButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _retryOrderButton.backgroundColor = [UIColor clearColor];
        [_retryOrderButton addTarget:self action:@selector(retryOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _retryOrderButton;
}

- (void)retryOrder{
    
    self.failedOrdersView.hidden = YES;
    [YJYAppDelegate timeAction];
    
}

- (UILabel *)notOrderLabel{
    
    if (_notOrderLabel == nil) {
        _notOrderLabel = [[UILabel alloc] init];
        _notOrderLabel.frame = CGRectMake(20, 10, 200, 20);
        _notOrderLabel.textColor = [UIColor whiteColor];
        _notOrderLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _notOrderLabel;
}

- (UIView *)failedOrdersView{
    
    if (_failedOrdersView == nil) {
        _failedOrdersView = [[UIView alloc] init];
        _failedOrdersView.frame = CGRectMake(20, self.view.frame.size.height-100, self.view.frame.size.width-40, 40);
        _failedOrdersView.layer.cornerRadius = 10;
        _failedOrdersView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    
    
    return _failedOrdersView;
}

#pragma mark - Maunal
#define WLScreenW  [UIScreen mainScreen].bounds.size.width
#define kBigHeaderH 160
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"请输入姓名/住院号/订单号";
    
    self.currentOrderListItem = [OrderListItem new];
    self.currentOrderListItem.type = 0;
    
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:APPSaasF4Color];
        searchField.layer.cornerRadius = 14.0f;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderUpdateNotification object:self.searchBar.text userInfo:@{@"type":@(self.currentOrderListItem.type)}];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:kYJYWorkBenchChangeOrderListNotification object:nil];
  
    self.bigHeaderView.frame = CGRectMake(0, -64, self.bigHeaderView.frame.size.width, self.bigHeaderView.frame.size.height);
    
    [self setupHiddenOptionView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.roleType != [YJYRoleManager sharedInstance].roleType) {
        
        [self setupHeaderItems];
        [self setupControllers];
        [self setUpScrollView];
        
        self.roleType = [YJYRoleManager sharedInstance].roleType;
        self.searchBar.text = self.key;
        if (self.searchBar.text) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderUpdateNotification object:self.searchBar.text userInfo:@{@"type":@(self.currentOrderListItem.type)}];
            
        }
        
    }
    
    [self.view addSubview:self.failedOrdersView];
    [self.view bringSubviewToFront:self.failedOrdersView];
    
    NSArray *array = [NSArray array];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"] isKindOfClass:[NSArray class]]) {
        array = [[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"];
    }
    
    if (array.count > 0) {
        
        self.notOrderLabel.text = [NSString stringWithFormat:@"有%ld条订单发布失败",array.count];
        self.failedOrdersView.hidden = NO;
        
    }else{
        self.failedOrdersView.hidden = YES;
    }
    
    [self.failedOrdersView addSubview:self.notOrderLabel];
    [self.failedOrdersView addSubview:self.retryOrderButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    [self.headerView yjy_setBottomShadow];

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setupHiddenOptionView {
//
//    if ([[YJYSettingManager sharedInstance].env isEqualToString:DEV]) {
//        self.optionViewhConstraint.constant = 0;
//        self.optionView.hidden = YES;
//        self.bigHeaderConstrainth.constant = kBigHeaderH-60;
//    }
    
    
}
//baritem
- (void)setupRightItemView {
    
//    self.rightItemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    self.rightItemView.backgroundColor = [UIColor clearColor];
//
//    self.filterBranchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
//    self.filterBranchLabel.font = [UIFont systemFontOfSize:16];
//    self.filterBranchLabel.textAlignment = NSTextAlignmentRight;
//    self.filterBranchLabel.textColor = APPHEXCOLOR;
//    self.filterBranchLabel.text = @"全部科室";
//    [self.rightItemView addSubview:self.filterBranchLabel];
//
//    self.filterDirectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 15, 10)];
//    self.filterDirectionImageView.image = [UIImage imageNamed:@"app_up_icon"];
//    self.filterDirectionImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.rightItemView addSubview:self.filterDirectionImageView];
//
//
//    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
//        ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker && ([YJYRoleManager sharedInstance].hgType == 2))) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightItemView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toFilter)];
//        [self.rightItemView addGestureRecognizer:tap];
//    }else {
//
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
//
//    }
}

//订单项
- (void)setupHeaderItems{
    
    
    for (UIView *subView in self.headerScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSArray *items = [YJYRoleManager isZizhao] ? [[YJYRoleManager sharedInstance] orderInsureListItems] : [[YJYRoleManager sharedInstance]orderListItems];
    
    self.extraWidth = items.count > 4 ? 20 : 0;
    CGFloat width = self.view.frame.size.width/items.count + self.extraWidth;
    CGFloat height = self.headerScrollView.frame.size.height;
    

    self.buttons = [NSMutableArray array];
    for (NSUInteger i = 0; i < items.count; i ++) {
        
        OrderListItem *item = items[i];
        
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
    
    NSArray *items =  [YJYRoleManager isZizhao] ? [[YJYRoleManager sharedInstance] orderInsureListItems] : [[YJYRoleManager sharedInstance]orderListItems];

    
    for (NSInteger i = 0; i < items.count; i++) {
        
        YJYOrderListController *vc = [YJYOrderListController instanceWithStoryBoard];
        
        CGFloat offsetX = i * WLScreenW;
        vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        vc.listItem = items[i];
        vc.didEndScrollBlock = ^{
            
            [self.searchBar resignFirstResponder];
            
        };
        self.searchBar.delegate = self;
        [self.contentScrollView addSubview:vc.view];
        
        
        [self.viewControllers addObject:vc];
        [self addChildViewController:vc];
    }
    
}

- (void)setupIndex {
    
 
    NSArray *items = [[YJYRoleManager sharedInstance]orderInsureListItems];
    
    for (NSInteger i = 0; i < items.count; i++) {
        OrderListItem *item = items[i];
        if (item.type == self.index) {
            [self itemAction:self.buttons[i] manual:YES];
            break;
        }
    }
}

// 初始化UIScrollView
- (void)setUpScrollView
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSUInteger count = self.childViewControllers.count;
    self.contentScrollView.contentSize = CGSizeMake(count * WLScreenW, 0);
    
    
}

#pragma mark - network

- (void)loadOrg {
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    req.isAll = NO;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        [SYProgressHUD hide];
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        if (rsp.orgListArray.count <= 1) {
            self.currentOrgDistanceModel = rsp.orgListArray.firstObject;
            [self loadBranchData];

        }else {
            
            self.onlyBranch = NO;
            self.filterBranchLabel.text = @"全部科室";
            self.currentOrgDistanceModel = [OrgDistanceModel new];
            self.currentBranch = [BranchModel new];
            [self setupOnlyBranch];
            [self postNotification];

        }
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"加载失败"];
        
    }];
}

- (void)loadBranchData {
    
    
    
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    req.isAll = NO;
    
    if (self.currentOrgDistanceModel.orgVo.orgId) {
        req.orgId =  self.currentOrgDistanceModel.orgVo.orgId;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        NSArray *currentBranchListArray = [[rsp.map objectForKey:self.currentOrgDistanceModel.orgVo.orgId] branchListArray];
        
        if (currentBranchListArray.count <= 1) {
            
            self.onlyBranch = YES;
            self.currentBranch = currentBranchListArray.firstObject;
            self.filterBranchLabel.text = self.currentBranch.branchName;
        }else {
            self.onlyBranch = NO;
        }
        
        
       
        [self setupOnlyBranch];
        [self postNotification];
        
       
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)setupOnlyBranch {
    self.filterDirectionImageView.hidden = self.onlyBranch;
    self.filterBranchLabel.frame = CGRectMake(self.onlyBranch ? 20 : 0, 0, 70, 30);
    
}
- (void)postNotification {
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    if (self.currentOrgDistanceModel) {
        [dictM addEntriesFromDictionary:@{@"currentOrgDistanceModel":self.currentOrgDistanceModel}];
    }
    if (self.currentBranch) {
        [dictM addEntriesFromDictionary:@{@"currentBranch":self.currentBranch}];
    }
    if (self.currentSortType > 0) {
        [dictM addEntriesFromDictionary:@{@"currentSortType":@(self.currentSortType)}];

    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderListFilterNotification object:nil userInfo:dictM];
    
}

#pragma mark - NSNotification

- (void)receiveNotification:(NSNotification *)notification {
    
    NSString *str = notification.object;
    if ([YJYRoleManager isZizhao]) {
        
        for (NSInteger i=0; i< [[YJYRoleManager sharedInstance]orderInsureListItems].count; i++) {
            OrderListItem *item = [[YJYRoleManager sharedInstance]orderInsureListItems][i];
            if ([item.title isEqualToString:str]) {
                self.currentOrderListItem = item;
                [self itemAction:self.buttons[i] manual:YES];

                break;
            }
            
        }
        
    }
    
}

#pragma mark - Action

- (IBAction)itemAction:(UIButton *)sender {
    
    [self itemAction:sender manual:YES];
}


- (void)itemAction:(UIButton *)sender manual:(BOOL)manual {
    
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    if ([YJYRoleManager isZizhao]) {
        
        self.currentOrderListItem = [[YJYRoleManager sharedInstance]orderInsureListItems][sender.tag];
    }else {
        
        self.currentOrderListItem = [[YJYRoleManager sharedInstance]orderListItems][sender.tag];
        
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderUpdateNotification object:self.searchBar.text userInfo:@{@"type":@(self.currentOrderListItem.type)}];

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




- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderUpdateNotification object:searchText userInfo:@{@"type":@(self.currentOrderListItem.type)}];

}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.headerScrollView) {
        
        NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        if (index < _buttons.count) {
            
            [self itemAction:self.buttons[index] manual:YES];
            
            
        }
        
    }
   
}

#pragma mark - Action

- (IBAction)toChooseTime:(id)sender {
//    1.下单时间排序 2-床号排序
    NSMutableArray *datasource = [NSMutableArray arrayWithArray:@[@"下单时间",@"床号"]];
    YJYActionSheet *actionSheet  = [YJYActionSheet instancetypeWithXIBWithDatasource:datasource withTitle:@""];
    actionSheet.frame = self.view.bounds;
    
    actionSheet.didComfireBlock = ^(id result) {
        
        self.filterTimeLabel.text = result;
        if ([result isEqualToString:@"下单时间"]) {
            self.currentSortType = 1;
        }else if ([result isEqualToString:@"床号"]) {
            self.currentSortType = 2;

        }
        [self postNotification];

        
    };
    [actionSheet showInView:nil];
}

- (IBAction)toFilter:(id)sender {
    
    if (self.onlyBranch) {
        return;
    }
    
    YJYBranchPicker *branchPicker = [YJYBranchPicker instancetypeWithXIB];
    branchPicker.currentOrg = self.currentOrgDistanceModel;
    branchPicker.currentBranch = self.currentBranch;
    
    self.filterDirectionImageView.image = [UIImage imageNamed:@"app_down_icon"];

    branchPicker.didCancelBlock = ^{
        self.filterDirectionImageView.image = [UIImage imageNamed:@"app_up_icon"];

    };
    
    branchPicker.didDoneBlock = ^(OrgDistanceModel *currentOrgDistanceModel, BranchModel *currentBranch,BOOL isSingle) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.currentOrgDistanceModel = currentOrgDistanceModel;
            self.currentBranch = currentBranch;
            
            if (self.currentOrgDistanceModel.orgVo.orgId == 0 && self.currentBranch.id_p == 0) {
                self.filterBranchLabel.text = @"全部医院";
            }else if (self.currentOrgDistanceModel.orgVo.orgId > 0 && self.currentBranch.id_p == 0) {
                
                self.filterBranchLabel.text = self.currentOrgDistanceModel.orgVo.orgName;
                if (isSingle) {
                    self.filterBranchLabel.text = @"全部科室";
                }
                
            }else if (self.currentOrgDistanceModel.orgVo.orgId > 0 && self.currentBranch.id_p > 0) {
                
                self.filterBranchLabel.text = self.currentBranch.branchName;
                
            }
            
            
            [self postNotification];
        });
        
        

        
    };
    [branchPicker showInView:nil];
    
    
}

@end
