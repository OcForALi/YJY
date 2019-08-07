//
//  YJYAdjustAddServiceCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAdjustAddServiceCell.h"

@interface YJYAdjustAddServiceItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//@property (strong, nonatomic) CompanyPriceVO companyPriceVO;
@property (strong, nonatomic) OrderItemVO2 *orderItemVO2;
@end

@implementation YJYAdjustAddServiceItemCell


- (void)setOrderItemVO2:(OrderItemVO2 *)orderItemVO2 {
    
    _orderItemVO2 = orderItemVO2;
    
    self.titleLabel.text = orderItemVO2.service;
    self.dayLabel.text = [NSString stringWithFormat:@"%@天",@(orderItemVO2.serviceDays)];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",orderItemVO2.serviceDays * orderItemVO2.price * 0.01];;
}




@end

#pragma mark - YJYAdjustAddServiceCell

@interface YJYAdjustAddServiceCell()<UITableViewDataSource,UITableViewDelegate>



@end


@implementation YJYAdjustAddServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.extraListArray = [NSMutableArray array];
}

- (void)setExtraListArray:(NSMutableArray<OrderItemVO2 *> *)extraListArray {
    
    _extraListArray = extraListArray;
    [self.tableView reloadData];
    if (self.didReloadBlock) {
        self.didReloadBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.extraListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYAdjustAddServiceItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYAdjustAddServiceItemCell"];
    cell.orderItemVO2 = self.extraListArray[indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (CGFloat)cellHeight {
    
    return self.extraListArray.count * 46 + (self.extraListArray.count > 0 ? 10 : 0);
}

@end
