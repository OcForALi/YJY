//
//  YJYOrgPickerCell.m
//  YJYNurse
//
//  Created by wusonghe on 2018/6/21.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYOrgPickerCell.h"

@implementation YJYOrgPickerCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
}

- (void)setOrgDistanceModel:(OrgDistanceModel *)orgDistanceModel {
    
    _orgDistanceModel = orgDistanceModel;
    self.titleLabel.text = orgDistanceModel.orgVo.orgName;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
