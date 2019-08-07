//
//  YJYTimeDayCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeData;

@interface YJYTimeDayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDesLabel;

@property (strong, nonatomic) TimeData *timeData;

@end
