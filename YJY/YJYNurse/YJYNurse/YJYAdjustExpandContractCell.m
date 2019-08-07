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
    
    self.isExpand = NO;
    NSString *expandTip = self.isExpand ? @"收起调整" : @"展开调整";
    self.serviceDesLabel.text = expandTip;
    
    self.priceList = [NSMutableArray array];
    self.tableView.separatorColor = APPNurseHugeGrayCOLOR;
    
}


- (void)setPriceList:(NSMutableArray<CompanyPriceVO *> *)priceList {
    
    _priceList = priceList;
    [self.tableView reloadData];
    
}
- (CGFloat)cellHeight {
    
    CGFloat itemCellH = 90;
    
    NSInteger num = self.priceList.count;

    CGFloat itemCellHeaderH = (num == 0) ? 0 : 46;
    itemCellHeaderH += (self.adjustExpandType == YJYAdjustExpandTypeVoprc ? 46 : 0);
    
    if (self.isExpand) {
        return num * itemCellH + itemCellHeaderH  + 10;
    }
    return itemCellHeaderH;
}
#pragma mark - Action

- (IBAction)expandAction:(id)sender {
    
    self.isExpand = !self.isExpand;
    
    
    NSString *expandTip = self.isExpand ? @"收起调整" : @"展开调整";
    
    
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
        
        price.number = number;
        [self.priceList replaceObjectAtIndex:indexPath.row withObject:price];
        
        if (self.didSelectPriceBlock) {
            self.didSelectPriceBlock(price);
        }
    };

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


@end
