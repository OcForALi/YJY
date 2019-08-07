//
//  YJYLongNurseListController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/5/23.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"
#import "YJYLongNurseDetailController.h"

typedef void(^DidEndScrollBlock)();

@interface YJYLongNurseListController : YJYTableViewController
@property (strong, nonatomic) ReviewListItem *listItem;
@property (copy, nonatomic) DidEndScrollBlock didEndScrollBlock;
@property (assign, nonatomic) YJYLongNurseActionType actionType;

@end
