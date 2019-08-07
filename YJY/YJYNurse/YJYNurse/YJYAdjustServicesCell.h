//
//  YJYAdjustServicesCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYAdjustServicesCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray<OrderItemVO3*> *serviceListArray;
- (CGFloat)cellHeight;
@property (copy, nonatomic) YJYDidDoneBlock didDoneBlock;
@end
