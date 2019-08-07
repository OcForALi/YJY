//
//  YJYOrderServiceItemsCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderServiceItemsCell.h"

@interface YJYOrderServiceItemsCell ()


@end

@implementation YJYOrderServiceItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.expandView.didExpandBlock = ^{
        
        if (self.didExpandBlock) {
            self.didExpandBlock();
        }
    };
}

- (void)setPriceNameArray:(NSMutableArray<NSString *> *)priceNameArray {

    _priceNameArray = priceNameArray;
    self.expandView.priceNameArray = priceNameArray;
    self.expandView.expandType = OrderItemsExpandTypePrice;
}

- (CGFloat)cellHeight {
    
    return [self.expandView cellHeight];
}

@end
