//
//  YJYAdjustServicesCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAdjustServicesCell.h"
#import "YJYAdjustServiceListCell.h"

@interface YJYAdjustServicesCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation YJYAdjustServicesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.separatorColor = APPNurseHugeGrayCOLOR;

    // Initialization code
}

- (void)setServiceListArray:(NSMutableArray<OrderItemVO3 *> *)serviceListArray {
    
    _serviceListArray = serviceListArray;
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.serviceListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYAdjustServiceListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYAdjustServiceListCell"];
    cell.orderItemVO3 = self.serviceListArray[indexPath.row];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self preCellHeightWithIndexPath:indexPath];
}


- (CGFloat)preCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    
    OrderItemVO3 *orderItemVO3 =  self.serviceListArray[indexPath.row];
    CGFloat header = orderItemVO3.serviceListArray.count == 0 ? 0 : 92 + 10;
    
    return orderItemVO3.serviceListArray.count * 46 + header ;
}

- (CGFloat)cellHeight {
    
    CGFloat H = 0;
    for (NSInteger i = 0; i < self.serviceListArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        H += [self preCellHeightWithIndexPath:indexPath];
    }
    
    return H + (self.serviceListArray.count > 0 ? 5 : 0);
}
@end
