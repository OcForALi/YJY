//
//  YJYMineModifyController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserVO;

typedef void(^MineModifyDidDoneBlock)(UserVO *user);

@interface YJYMineModifyController : YJYTableViewController

@property (strong, nonatomic) UserVO *user;
@property (copy, nonatomic) MineModifyDidDoneBlock mineModifyDidDoneBlock;

@end
