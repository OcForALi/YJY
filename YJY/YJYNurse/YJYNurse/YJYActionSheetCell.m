//
//  YJYTimeDayCell.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYActionSheetCell.h"

@implementation YJYActionSheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
    
        self.titleLabel.textColor = APPHEXCOLOR;
    }else {
        self.titleLabel.textColor = APPDarkGrayCOLOR;
    
    }
}


@end
