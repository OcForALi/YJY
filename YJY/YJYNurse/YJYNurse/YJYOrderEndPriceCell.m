//
//  YJYOrderEndPriceCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/7/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderEndPriceCell.h"

@interface YJYOrderEndPriceCell()

@property (strong, nonatomic) OrderItemVO2 *orderItem;

@end

@implementation YJYOrderEndPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderItem:(OrderItemVO2 *)orderItem index:(NSInteger)index{

    if (index > 0) {
        
        _orderItem = orderItem;
        self.nameLabel.text = orderItem.service ? orderItem.service : @"未知服务";
        
        self.startLabel.text = orderItem.serviceStartDate;
        self.endLabel.text = orderItem.serviceEndDate;
        self.unitPriceLabel.text = orderItem.priceDesc;
        self.totalLabel.text = [NSString stringWithFormat:@"%@元",orderItem.totalCostStr];
        
        self.nameLabel.textColor = APPNurseDarkGrayCOLOR;
        self.startLabel.textColor = APPNurseDarkGrayCOLOR;
        self.endLabel.textColor = APPNurseDarkGrayCOLOR;
        self.unitPriceLabel.textColor = APPNurseDarkGrayCOLOR;
        self.totalLabel.textColor = APPNurseDarkGrayCOLOR;

    }else {
    
        
        self.nameLabel.text =@"服务项";
        self.startLabel.text = @"开始时间";
        self.endLabel.text = @"结束时间";
        self.unitPriceLabel.text = @"单价";
        self.totalLabel.text = @"费用合计";

        
        self.nameLabel.textColor = APPDarkGrayCOLOR;
        self.startLabel.textColor = APPDarkGrayCOLOR;
        self.endLabel.textColor = APPDarkGrayCOLOR;
        self.unitPriceLabel.textColor = APPDarkGrayCOLOR;
        self.totalLabel.textColor = APPDarkGrayCOLOR;

    
    }
}


@end
