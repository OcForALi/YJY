//
//  YJYOrderSettlPayCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/22.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderSettlPayCell.h"

@implementation YJYOrderSettlPayCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.expandView.didExpandBlock = ^{
        
        if (self.didExpandBlock) {
            self.didExpandBlock();
        }
    };
}

- (void)setOrderSettlPayListArray:(NSMutableArray<OrderItemVO2 *> *)orderSettlPayListArray {
    
    _orderSettlPayListArray = orderSettlPayListArray;
    self.expandView.orderSettlPayListArray = orderSettlPayListArray;
    self.expandView.expandType = OrderItemsExpandTypeSettleDetail;

}


- (CGFloat)cellHeight {
    
    return [self.expandView cellHeight];
}

@end
