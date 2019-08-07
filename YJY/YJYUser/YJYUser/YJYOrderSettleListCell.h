//
//  YJYOrderSettleListCell.h
//  YJYUser
//
//  Created by wusonghe on 2017/8/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYOrderSettleListCellDidDetailAction)(SettlementVO *settlement);


@interface YJYOrderSettleListCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray<SettlementVO*> *voListArray;
@property (strong, nonatomic) OrderVO *order;
@property (copy, nonatomic) YJYOrderSettleListCellDidDetailAction didDetailAction;

- (NSArray *)settDateArray;
- (CGFloat)cellHeight;
@end
