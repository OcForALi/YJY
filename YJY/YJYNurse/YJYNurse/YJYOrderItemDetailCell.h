//
//  YJYOrderItemDetailCell.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJYOrderItemsExpandView.h"


typedef void(^YJYOrderItemDetailCellDidDetailBlock)(BOOL isExpand);
typedef void(^YJYOrderItemDetailCellDidChangeBlock)(OrderItemVO *orderItem);

//护士：确定服务
//护士长：关闭服务

typedef void(^YJYOrderItemDetailCellDidDoneAndCloseBlock)(OrderItemVO *orderItem);

typedef void(^YJYOrderItemDetailCellDidAddAndModifyBlock)(OrderItemVO *orderItem);


@interface YJYOrderItemDetailCell : UITableViewCell

@property (strong, nonatomic) GetOrderInfoRsp *orderInfoRsp;
@property(nonatomic, strong) NSMutableArray<OrderItemVO*> *orderItemArray;
@property (copy, nonatomic) YJYOrderItemDetailCellDidDetailBlock didExpandBlock;
@property (copy, nonatomic) YJYOrderItemDetailCellDidChangeBlock didChangeBlock;
@property (copy, nonatomic) YJYOrderItemDetailCellDidDoneAndCloseBlock didDoneAndCloseBlock;
@property (copy, nonatomic) YJYOrderItemDetailCellDidAddAndModifyBlock didAddAndModifyBlock;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (CGFloat)cellHeight;
@end
