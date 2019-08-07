//
//  YJYTimeDayCell.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTimeDayCell.h"

@implementation YJYTimeDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    if (selected) {
    
        self.dayDesLabel.textColor = APPHEXCOLOR;
    }else {
        self.dayDesLabel.textColor = APPDarkGrayCOLOR;
    
    }
}

-(void)setTimeData:(TimeData *)timeData {
    
    _timeData = timeData;
    self.dayLabel.text = timeData.alias;
    self.dayDesLabel.text = timeData.dayStr;
    
   
}

@end
