//
//  YJYTimeDayCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYActionSheetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) NSString *title;

@end
