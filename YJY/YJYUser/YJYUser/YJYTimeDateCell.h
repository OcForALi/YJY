//
//  YJYTimeDateCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderTimeData;

@interface YJYTimeDateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) OrderTimeData *orderTimeData;

@end
