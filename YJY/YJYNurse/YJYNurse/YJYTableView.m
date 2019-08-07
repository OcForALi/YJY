//
//  YJYTableView.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/11.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableView.h"

@interface YJYTableView()


@property (assign, nonatomic) BOOL isSecondReload;
@property (assign, nonatomic) BOOL isNoData;


@end

@implementation YJYTableView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

//- (void)setNoDataTitle:(NSString *)noDataTitle {
//    
//    _noDataTitle = noDataTitle;
//    [self.reloadButton setTitle:noDataTitle forState:0];
//}

- (void)setNoShow:(BOOL)noShow {
    
    _noShow = noShow;
    
    self.emptyImageView.hidden = noShow;
    self.reloadButton.hidden = noShow;

    
}

#define kEmptyImageViewW  161
#define kEmptyImageViewH  161
- (void)setup {
    
    
    self.tableFooterView = [[UIView alloc]init];

    
    
    self.noDataImage = [UIImage imageNamed:@"app_none_data"];
    self.errorImage = [UIImage imageNamed:@"app_network_failed"];
    
    self.emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kEmptyImageViewW, kEmptyImageViewH)];
    self.emptyImageView.center = CGPointMake(self.emptyView.center.x, self.emptyView.center.y - 30);
    [self.emptyView addSubview:self.emptyImageView];
    
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reloadButton setTitle:@"无数据" forState:0];
    [self.reloadButton setTitleColor:[UIColor darkGrayColor] forState:0];
    self.reloadButton.frame = CGRectMake(0, self.emptyImageView.frame.size.height + self.emptyImageView.frame.origin.y + 30, self.frame.size.width, 30);
    self.reloadButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.reloadButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadButton setTitleColor:APPDarkGrayCOLOR forState:0];

    [self.emptyView addSubview:self.reloadButton];

    self.backgroundView = self.emptyView;
    self.backgroundView.hidden = YES;
    self.separatorColor = APPNurseGray10COLOR;

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.emptyImageView.center = CGPointMake(self.emptyView.center.x,  self.emptyImageView.center.y);

    self.reloadButton.center = CGPointMake(self.emptyView.center.x, self.emptyImageView.center.y + self.emptyImageView.frame.size.height - 40 + self.reloadButtonY);
    
}

- (UIView *)emptyView {

    if (!_emptyView) {
        
        _emptyView = [[UIView alloc]initWithFrame:self.backgroundView.bounds];
        _emptyView.center = self.center;
        _emptyView.backgroundColor = [UIColor clearColor];
    }
    
    return _emptyView;
    
}

- (void)buttonAction:(UIButton *)sender {
    
    if (self.reloadDidSelect) {
        self.reloadDidSelect();
    }
    
}

#pragma mark - reload



- (void)reloadAllData {
    
    self.isNoData = YES;
    self.emptyImageView.image = self.noDataImage;
    NSString *error = self.noDataTitle ? self.noDataTitle : @"无数据";
    [self.reloadButton setTitle:error forState:0];
    [self reloadAllDataAndView];
}

- (void)reloadErrorData {
    
    self.isNoData = NO;
    self.emptyImageView.image = self.errorImage;
    NSString *error = self.errorTitle ? self.errorTitle : @"网络错误";
    [self.reloadButton setTitle:error forState:0];

    [self reloadAllDataAndView];
    
}

- (void)reloadAllDataAndView {


    
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
    
    [SYProgressHUD hide];
    [self reloadData];
    self.isSecondReload = YES;
    
    NSUInteger count = [self numberOfRowsInSection:0];
    
    if (count > 0 && count < NSIntegerMax) {
        
        self.backgroundView.hidden = YES;
        
    }else if (count == 0 && self.isSecondReload){
        
        self.backgroundView.hidden = NO;
        self.isSecondReload = NO;
        
    }
    
    [self reloadData];
}


@end
