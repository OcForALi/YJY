//
//  YJYOrderPayOffCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/9.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPayOffCell.h"


@interface YJYOrderPayOffItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (strong, nonatomic) OrderItemVO2 *orderItem;
@end

@implementation YJYOrderPayOffItemCell

- (void)setOrderItem:(OrderItemVO2 *)orderItem {

    _orderItem = orderItem;
    self.serviceLabel.text = orderItem.service;
    self.unitPriceLabel.text = orderItem.priceDesc;
    self.feeLabel.text = [NSString stringWithFormat:@"%@元",orderItem.totalCostStr];

    self.startLabel.text = orderItem.serviceStartDate;
    self.endLabel.text = orderItem.serviceEndDate;
    self.dayLabel.text = [NSString stringWithFormat:@"%@",@(orderItem.serviceDays)];

    
}

@end

@interface YJYOrderPayOffCell()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation YJYOrderPayOffCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.orderSettlPayListArray = [NSMutableArray array];
}

- (CGFloat)cellHeight {

    if (self.orderSettlPayListArray.count == 0) {
        return 0;
    }
    
    return (self.orderSettlPayListArray.count + 1)* 55 + 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderSettlPayListArray.count + 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YJYOrderPayOffItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderPayOffItemCell"];
    if (indexPath.row == 0) {
        
        if (self.payOffType == YJYOrderPayOffTypeService) {
            
            cell.serviceLabel.text = @"服务项";
            cell.startLabel.text = @"开始时间";
            cell.endLabel.text = @"结束时间";
            cell.unitPriceLabel.text = @"单价";
            cell.feeLabel.text = @"费用合计";
            
        }else {
        
            cell.serviceLabel.text = @"服务项";
            cell.dayLabel.text = @"服务次/天数";
            cell.unitPriceLabel.text = @"单价";
            cell.feeLabel.text = @"费用合计";
        
        }
        
    }else {
        cell.orderItem = self.orderSettlPayListArray[indexPath.row-1];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
