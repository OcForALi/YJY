//
//  YJYOrderItemsExpandView.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderItemsExpandType) {

    OrderItemsExpandTypePrice, //服务项
    OrderItemsExpandTypeExtraVolist, // 服务项目
    OrderItemsExpandTypeDailyList, // 每日明细附加
    OrderItemsExpandTypeDailyItemList, // 每日明细服务项
    OrderItemsExpandTypeSettleDetail, //结算详情
};

typedef void(^YJYOrderItemsExpandBlock)();

@interface YJYOrderItemsExpandView : UIView


@property (strong, nonatomic) NSMutableArray<NSString*> *priceNameArray;
@property (strong, nonatomic) NSMutableArray<ExtraItemVO*> *extraVolistArray;
@property (strong, nonatomic) NSMutableArray<OrderItemVO2*> *orderSettlPayListArray;

@property (strong, nonatomic) NSMutableArray<ExtraItemVO*> *basisVolistArray;

@property (assign, nonatomic) OrderItemsExpandType expandType;
@property (copy, nonatomic) YJYOrderItemsExpandBlock didExpandBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL isExpand;

- (CGFloat)cellHeight;


@end


