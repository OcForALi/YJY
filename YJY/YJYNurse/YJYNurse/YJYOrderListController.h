//
//  YJYOrderListController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/5/20.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"
typedef void(^DidEndScrollBlock)();


@interface YJYOrderListController : YJYTableViewController


@property (strong, nonatomic) OrderListItem *listItem;
@property (copy, nonatomic) DidEndScrollBlock didEndScrollBlock;


@end
