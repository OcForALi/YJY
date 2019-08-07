//
//  YJYAdjustServiceListCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAdjustServiceListCell.h"

@interface YJYAdjustServiceItemCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) OrderItemVO2 *orderItemVO2;

@end

@implementation YJYAdjustServiceItemCell

- (void)setOrderItemVO2:(OrderItemVO2 *)orderItemVO2 {
    
    _orderItemVO2 = orderItemVO2;
    self.createTimeLabel.text = orderItemVO2.serviceStartDate;
    self.endTimeLabel.text = orderItemVO2.serviceEndDate;
    self.dayLabel.text = [NSString stringWithFormat:@"%@天",@(orderItemVO2.basicServiceDays)];
    self.priceLabel.text = orderItemVO2.priceDesc;

}

@end

#pragma mark - YJYAdjustServiceListCell
@interface YJYAdjustServiceListCell()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic)  NSMutableArray<OrderItemVO2*> *serviceListArray;

@end

@implementation YJYAdjustServiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    
}

- (void)setOrderItemVO3:(OrderItemVO3 *)orderItemVO3 {
    _orderItemVO3 = orderItemVO3;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",orderItemVO3.totalCostStr];
    self.titleLabel.text = orderItemVO3.service;
    self.serviceListArray = orderItemVO3.serviceListArray;

    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.serviceListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYAdjustServiceItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYAdjustServiceItemCell"];
    cell.orderItemVO2 = self.serviceListArray[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}




@end
