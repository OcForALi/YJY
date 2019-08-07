//
//  YJYBranchPickerCell.m
//  YJYNurse
//
//  Created by wusonghe on 2018/6/21.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYBranchPickerCell.h"

@implementation YJYBranchPickerCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.titleLabel.textColor = selected ? APPHEXCOLOR : APPNurseDarkGrayCOLOR;
}

- (void)setBranch:(BranchModel *)branch {
    
    _branch = branch;
    self.titleLabel.text = branch.branchName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
