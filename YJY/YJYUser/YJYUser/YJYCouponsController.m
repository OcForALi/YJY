//
//  YJYCouponController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYCouponsController.h"


#define YJYCouponCellID @"YJYCouponCell"
@interface YJYCouponCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

@implementation YJYCouponCell


@end


@interface YJYCouponsController ()

@property (strong, nonatomic) NSMutableArray *coupons;

@end

@implementation YJYCouponsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshNetworkingData];
    }];
    
    self.tableView.tableFooterView =  [[UIView alloc]init];
    
}
- (void)refreshNetworkingData {

    [self.tableView.mj_header endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    YJYCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:YJYCouponCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 125;
}

@end
