//
//  YJYOrderAdditionCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderAdditionCell.h"

@implementation YJYOrderAdditionCell

- (void)setExtraItem:(ExtraItemVO *)extraItem {
    
    _extraItem = extraItem;
    //医疗服务
    self.nameLabel.text = extraItem.service;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", extraItem.totalCostStr];
    self.numberLabel.text = [NSString stringWithFormat:@"%@次", @(extraItem.serviceTimes)];
    
    self.otherInfoLabel.hidden = (extraItem.insureFlag != 1);
   
}



@end
