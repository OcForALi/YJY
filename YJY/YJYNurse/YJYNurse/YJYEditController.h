//
//  YJYEditController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/8.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef void(^DidEditBlock)(NSString *text);

@interface YJYEditController : YJYTableViewController

@property (copy, nonatomic) NSString *originString;
@property (copy, nonatomic) DidEditBlock didEditBlock;

@end
