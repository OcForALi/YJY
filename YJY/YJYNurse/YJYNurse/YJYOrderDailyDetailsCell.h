//
//  YJYOrderDailyDetailsCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/20.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJYOrderDailyDetailsToCellDetailBlock)(SettlementVO *orderItem);
typedef void(^YJYOrderDailyDetailsToDetailBlock)();


@interface YJYOrderDailyDetailsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet YJYTableView *tableView;

@property (nonatomic, strong) NSMutableArray<SettlementVO*> *orderItemArray;
@property (strong, nonatomic) GetOrderInfoRsp *orderInfoRsp;
@property (copy, nonatomic) YJYOrderDailyDetailsToCellDetailBlock toCellDetailBlock;
@property (copy, nonatomic) YJYOrderDailyDetailsToDetailBlock toDetailBlock;

@property (assign, nonatomic) BOOL isHiddenCheckButton;

- (CGFloat)cellHeight;
- (NSMutableArray<SettlementVO*> *)selectedOrderItemArray;
@end
