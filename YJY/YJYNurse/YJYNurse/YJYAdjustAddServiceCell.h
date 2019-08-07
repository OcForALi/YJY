//
//  YJYAdjustAddServiceCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYAdjustAddServiceCellDidReloadBlock)();


@interface YJYAdjustAddServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray<OrderItemVO2*> *extraListArray;
@property (copy, nonatomic) YJYAdjustAddServiceCellDidReloadBlock didReloadBlock;
- (CGFloat)cellHeight;

@end
