//
//  YJYAdjustExpandContractCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAdjustExpandContractCell.h"
#import "YJYOrderAddServicesCell.h"
@interface YJYAdjustExpandContractCell()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YJYAdjustExpandContractCell

- (void)awakeFromNib {
    [super awakeFromNib];


}

- (void)setPriceList:(NSMutableArray<CompanyPriceVO *> *)priceList {
    
    _priceList = priceList;
    [self.tableView reloadData];
    
}
- (CGFloat)cellHeight {
    
    CGFloat itemCellH = 44;
    
    NSInteger num = 0;
    num = self.priceList.count;

    CGFloat itemCellHeaderH = (num == 0) ? 0 : 46;
    
    if (self.isExpand) {
        return num * itemCellH + itemCellHeaderH;
    }
    return itemCellHeaderH;
}
#pragma mark - Action

- (IBAction)expandAction:(id)sender {
    
    self.isExpand = !self.isExpand;
    
    
    NSString *expandTip = self.isExpand ? @"收起" : @"展开";
    
    
    self.serviceDesLabel.text = expandTip;
    
    
    [self.tableView reloadData];
    
    if (self.didExpandBlock) {
        self.didExpandBlock();
    }
    
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.priceList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYOrderAddServicesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAddServicesCell"];

    CompanyPriceVO *price = self.priceList[indexPath.row];
    cell.price = price;
    
    cell.didNumberChangeBlock = ^(NSInteger number) {
        
        price.number = (uint32_t)number;
        [self.priceList replaceObjectAtIndex:indexPath.row withObject:price];
        
        if (self.didSelectPriceBlock) {
            self.didSelectPriceBlock(price);
        }
    };
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}


@end
