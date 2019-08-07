//
//  YJYinfoCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYinfoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end
