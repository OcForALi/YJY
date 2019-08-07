//
//  YJYTimeDateCell.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTimeDateCell.h"

@implementation YJYTimeDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (!self.orderTimeData) {
        return;
    }
    if (selected) {
        
        self.dateLabel.textColor = APPHEXCOLOR;
    }else {
        
        if (!self.orderTimeData.status) {
            self.dateLabel.textColor = APPGrayCOLOR;
            self.userInteractionEnabled = NO;
        }else {
            self.dateLabel.textColor = APPDarkGrayCOLOR;
            self.userInteractionEnabled = YES;
        }
        
    }

}

- (void)setOrderTimeData:(OrderTimeData *)orderTimeData {

    _orderTimeData = orderTimeData;
    self.dateLabel.text = orderTimeData.time;
    
    
}

@end
