//
//  YJYAdjustServiceListCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YJYAdjustServiceListCellDidReloadBlock)();

@interface YJYAdjustServiceListCell : UITableViewCell

@property (strong, nonatomic) OrderItemVO3 *orderItemVO3;
@property (copy, nonatomic) YJYAdjustServiceListCellDidReloadBlock didReloadBlock;
@end
