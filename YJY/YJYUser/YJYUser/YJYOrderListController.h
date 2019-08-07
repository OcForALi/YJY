//
//  YJYOrderListController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef NS_ENUM(NSInteger ,OrderListType) {

    OrderListTypeAll = 10,
    OrderListTypeProcess = 11,
    OrderListTypeFinish = 12
    
};

@interface YJYOrderListController : YJYTableViewController

@property (assign, nonatomic) OrderListType orderListType;
+ (instancetype)instanceWithStoryBoard;
- (void)loadNetworkData;
@end
