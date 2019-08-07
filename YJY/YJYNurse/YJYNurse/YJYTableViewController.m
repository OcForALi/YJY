//
//  YJYTableViewController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYTableViewController ()
@property (assign, nonatomic) BOOL isSecondReload;

@end

@implementation YJYTableViewController

#define kEmptyImageViewW  161
#define kEmptyImageViewH  161

+ (instancetype)instanceWithStoryBoard {

    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //app_network_failed
    //app_none_data
    
    self.noDataImage = [UIImage imageNamed:@"app_none_data"];
    self.errorImage = [UIImage imageNamed:@"app_network_failed"];
    self.emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kEmptyImageViewW, kEmptyImageViewH)];
    self.emptyImageView.center = self.emptyView.center;
    
    
    [self.emptyView addSubview:self.emptyImageView];

    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 80)];
    self.descriptionLabel.center = CGPointMake(self.emptyView.center.x,  self.emptyView.center.y);
    self.descriptionLabel.textColor = APPGrayCOLOR;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    [self.emptyView addSubview:self.descriptionLabel];


    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reloadButton setTitle:@"无数据" forState:0];
    [self.reloadButton setTitleColor:[UIColor darkGrayColor] forState:0];
    self.reloadButton.frame = CGRectMake(0, 0, self.emptyView.frame.size.width, 40);
    self.reloadButton.center = CGPointMake(self.emptyView.center.x, self.emptyView.center.y - self.reloadButton.frame.size.height - 20);

    self.reloadButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.reloadButton setTitleColor:APPGrayCOLOR forState:0];

    [self.emptyView addSubview:self.reloadButton];

    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundView = self.emptyView;
    self.tableView.backgroundView.hidden = YES;
    self.tableView.separatorColor = APPNurseGray10COLOR;
   
    
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title = @"";
    self.navigationItem.backBarButtonItem = backIetm;
    
    
    self.emptyImageView.center = CGPointMake(self.emptyView.center.x,  self.emptyView.center.y);
    

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarNotAlphaWithBlackTint];

//    self.tableView.backgroundView.hidden = YES;

}

- (void)viewDidLayoutSubviews {

    
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *) ){
        if (!self.isNaviError) {
            self.isNaviError = !(![self.parentViewController isKindOfClass:[YJYNavigationController class]] &&
                                 ![self.parentViewController isKindOfClass:[YJYTableViewController class]]);
        }
     
        
        if (self.isNaviError) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        }
    }
    
    if (!self.isLayout) {
        
        self.isLayout = YES;
    }
  
    
    
    
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    
    
}

- (void)setDataShowType:(NoDataShowType)dataShowType {
    
    _dataShowType = dataShowType;
    
    BOOL NoShowImgButton = (dataShowType == NoDataShowTypeImgButton);
    
    self.descriptionLabel.hidden = NoShowImgButton;
    self.emptyImageView.hidden = !NoShowImgButton;
}

- (void)setDescTitle:(NSString *)descTitle {
    
    _descTitle = descTitle;
    self.descriptionLabel.attributedText = [descTitle attributedStringWithLineSpacing:10];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

- (UIView *)emptyView {
    
    if (!_emptyView) {
        
        _emptyView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _emptyView.center = self.view.center;
        _emptyView.backgroundColor = [UIColor clearColor];
    }
    
    return _emptyView;
    
}
#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
//    return 1;
    
    NSUInteger count =  [self.tableView numberOfRowsInSection:0];

    if (count > 0 && count < NSIntegerMax) {

        self.tableView.backgroundView.hidden = YES;
        return 1;
    }else if (count == 0 && self.isSecondReload){

        self.tableView.backgroundView.hidden = NO;
        self.isSecondReload = NO;

        return 0;
    }else {
        self.tableView.backgroundView.hidden = YES;
        return 1;
    }
    
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.allowsMultipleSelection &&
        [[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return nil;
    }
    return indexPath;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}
#pragma mark - Reload

- (void)reloadAllData {
    
    self.emptyImageView.image = self.noDataImage;
    NSString *error = self.noDataTitle ? self.noDataTitle : @"无数据";
    [self.reloadButton setTitle:error forState:0];
    self.descriptionLabel.hidden = (self.dataShowType == 0);
    [self reloadAllDataAndView];
}

- (void)reloadErrorData {
    
    self.emptyImageView.image = self.errorImage;
    NSString *error = self.errorTitle ? self.errorTitle : @"网络错误";
    self.descriptionLabel.hidden = YES;
    [self.reloadButton setTitle:error forState:0];
    [self reloadAllDataAndView];

}

- (void)reloadAllDataAndView {
    
    
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    [SYProgressHUD hide];
    [SYProgressHUD hideToLoadingView:self.view];
    if (self.reloadButton.spinner.isAnimating) {
        [self.reloadButton stopActivityIndicatorVisibilityWithIsClear:NO];
    }
    [self.tableView reloadData];
    self.isSecondReload = YES;
    [self.tableView reloadData];
    
}
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if ([URL.absoluteString containsString:@"http"]) {
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = URL.absoluteString;
        vc.title = @"护理易";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



@end
