//
//  YJYOrderItemsExpandView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderItemsExpandView.h"
#import "YJYOrderServerCell.h"
#import "YJYOrderAdditionCell.h"
#import "YJYOrderEndPriceCell.h"


@interface YJYOrderItemsExpandView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *serviceDesLabel;
@property (strong, nonatomic) NSMutableArray *items;
@end

@implementation YJYOrderItemsExpandView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
      
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.items = [NSMutableArray array];

    self.isExpand = YES;
    self.priceNameArray = [NSMutableArray array];
    self.extraVolistArray = [NSMutableArray array];
    self.basisVolistArray = [NSMutableArray array];

    self.orderSettlPayListArray = [NSMutableArray array];

   
}
- (void)setPriceNameArray:(NSMutableArray<NSString *> *)priceNameArray {
    
    _priceNameArray = priceNameArray;
    self.items = priceNameArray;
    
    NSString *expandTip = self.isExpand ? @"收起" : @"展开";
    self.serviceDesLabel.text = expandTip;//[NSString stringWithFormat:@"%@%@项",expandTip,@(self.items.count)];
    [self.tableView reloadData];
}

- (void)setExtraVolistArray:(NSMutableArray<ExtraItemVO *> *)extraVolistArray {
    
    _extraVolistArray = extraVolistArray;
    self.items = extraVolistArray;
    
    NSString *expandTip = self.isExpand ? @"收起" : @"展开";
    self.serviceDesLabel.text  = expandTip;// [NSString stringWithFormat:@"%@%@项",expandTip,@(self.items.count)];
    [self.tableView reloadData];
}
- (void)setOrderSettlPayListArray:(NSMutableArray<OrderItemVO2 *> *)orderSettlPayListArray {
    
    _orderSettlPayListArray = orderSettlPayListArray;
    self.items = orderSettlPayListArray;
    
    NSString *expandTip = self.isExpand ? @"收起" : @"展开";
    self.serviceDesLabel.text = expandTip; // [NSString stringWithFormat:@"%@%@项",expandTip,@(self.items.count)];
    [self.tableView reloadData];

}

- (void)setBasisVolistArray:(NSMutableArray<ExtraItemVO *> *)basisVolistArray {
    
    _basisVolistArray = basisVolistArray;
    
    self.items = basisVolistArray;
    [self.tableView reloadData];
    
}

- (void)setItems:(NSMutableArray *)items {
    
    _items = items;
    
    CGFloat itemCellHeaderH = (items.count == 0) ? 0 : 46;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, itemCellHeaderH);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.expandType == OrderItemsExpandTypePrice) {
        return self.priceNameArray.count;

    }
    if (self.expandType == OrderItemsExpandTypeExtraVolist) {
        
        return self.extraVolistArray.count;
    }
    
    if (self.expandType == OrderItemsExpandTypeDailyList) {
        
        return self.extraVolistArray.count;
    }
    if (self.expandType == OrderItemsExpandTypeDailyItemList) {
        
        return self.basisVolistArray.count;
    }
    
    if (self.expandType == OrderItemsExpandTypeSettleDetail) {
        
        return self.orderSettlPayListArray.count + 1;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.expandType == OrderItemsExpandTypePrice) {

        YJYOrderServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderServerCell"];
        cell.service = self.priceNameArray[indexPath.row];
        cell.titleLabel.text = self.priceNameArray[indexPath.row];
        return cell;
        
    }
    
    if (self.expandType == OrderItemsExpandTypeExtraVolist) {
        
        YJYOrderAdditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAdditionCell"];
        cell.extraItem = self.extraVolistArray[indexPath.row];
        return cell;
       
    }
    
   
    
    if (self.expandType == OrderItemsExpandTypeDailyItemList) {
        
        YJYOrderAdditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAdditionCell"];
        cell.extraItem = self.basisVolistArray[indexPath.row];
        return cell;
        
    }
    if (self.expandType == OrderItemsExpandTypeDailyList) {
        
        YJYOrderAdditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAdditionCell"];
        cell.extraItem = self.extraVolistArray[indexPath.row];
        return cell;
        
    }
    if (self.expandType == OrderItemsExpandTypeSettleDetail) {
        
       
        YJYOrderEndPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderEndPriceCell"];
        
        OrderItemVO2 * orderItem;
        if (indexPath.row >= 1) {
            orderItem = self.orderSettlPayListArray[indexPath.row-1];
        }
        
        [cell setOrderItem:orderItem index:indexPath.row];
        
        return cell;
    }
    
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (self.expandType == OrderItemsExpandTypeExtraVolist ||
        self.expandType == OrderItemsExpandTypeDailyList) {
        
        ExtraItemVO *extraItem = self.extraVolistArray[indexPath.row];
        CGFloat height = [NSString heightWithText:extraItem.service font:[UIFont systemFontOfSize:12] width:80];
        
        return height + (44-12);
        
        
    }else if (self.expandType == OrderItemsExpandTypeDailyItemList) {
    
        ExtraItemVO *extraItem = self.basisVolistArray[indexPath.row];
        CGFloat height = [NSString heightWithText:extraItem.service font:[UIFont systemFontOfSize:12] width:80];
        
        return height + (44-12);
    
    } else{
    
        return 44;
    }
    
    
    
}



- (CGFloat)cellHeight {

    CGFloat itemCellH = 44;
    CGFloat itemCellHeaderH = (self.items.count == 0) ? 0 : 46;

    
    if (self.isExpand) {
        
        if (self.expandType == OrderItemsExpandTypePrice) {
            return self.priceNameArray.count * itemCellH + itemCellHeaderH;
            
        }
        
        if (self.expandType == OrderItemsExpandTypeExtraVolist) {
            
            CGFloat H = 0.0;
            for (NSInteger i = 0; i < self.extraVolistArray.count; i++) {
                CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                H +=height;
                
            }
           
            return H + itemCellHeaderH;
        
        }
        
        
        if (self.expandType == OrderItemsExpandTypeDailyItemList){
        
                
            CGFloat H = 0;
            for (NSInteger i = 0; i < self.basisVolistArray.count; i++) {
                CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                H +=height;
                
            }
            itemCellHeaderH = 46;
            return H + itemCellHeaderH  + itemCellHeaderH;// (self.basisVolistArray.count > 0 ? 46 : 0);;
        }
        
        if (self.expandType == OrderItemsExpandTypeDailyList){
            
            
            CGFloat H = 0;
            for (NSInteger i = 0; i < self.extraVolistArray.count; i++) {
                CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                H +=height;
                
            }
            itemCellHeaderH = 46;
            return H + itemCellHeaderH + itemCellHeaderH;// (self.extraVolistArray.count > 0 ? 46 : 0);
        }
        
        if (self.expandType == OrderItemsExpandTypeSettleDetail) {
            
            
            if (self.orderSettlPayListArray.count == 0) {
                return 0;
            }
            return (self.orderSettlPayListArray.count + 1) * itemCellH + itemCellHeaderH;
        }
    }
    
    
    return itemCellHeaderH;
}

#pragma mark - Action

- (IBAction)expandAction:(id)sender {
    
    self.isExpand = !self.isExpand;
    
    
    NSString *expandTip = self.isExpand ? @"收起" : @"展开";
    
    
    self.serviceDesLabel.text = expandTip;
    //[NSString stringWithFormat:@"%@%@项",expandTip,@(self.items.count)];

    
    [self.tableView reloadData];

    if (self.didExpandBlock) {
        self.didExpandBlock();
    }
    
}

@end
