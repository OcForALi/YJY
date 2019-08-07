//
//  YJYBookBranchController.h
//  YJYUser
//
//  Created by wusonghe on 2017/8/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYBookBranchDidSelectBlock)(BranchModel *branch);


@interface YJYBookBranchController : YJYViewController
@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (copy, nonatomic) YJYBookBranchDidSelectBlock didSelectBlock;
@end
