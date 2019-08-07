//
//  YJYBranchPickerCell.h
//  YJYNurse
//
//  Created by wusonghe on 2018/6/21.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYBranchPickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) BranchModel *branch;
@end
