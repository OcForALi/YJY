//
//  YJYInsureListController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/11/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"
typedef void(^YJYInsureListDidEndScrollBlock)();

@interface YJYInsureListController : YJYTableViewController

@property (strong, nonatomic) InsureListItem *listItem;
@property (copy, nonatomic) YJYInsureListDidEndScrollBlock didEndScrollBlock;

@end
