//
//  YJYOrderSettlPayCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/22.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJYOrderItemsExpandView.h"


@interface YJYOrderSettlPayCell : UITableViewCell


@property (strong, nonatomic) NSMutableArray<OrderItemVO2*> *orderSettlPayListArray;
@property (copy, nonatomic) YJYOrderItemsExpandBlock didExpandBlock;
@property (weak, nonatomic) IBOutlet YJYOrderItemsExpandView *expandView;
- (CGFloat)cellHeight;

@end
