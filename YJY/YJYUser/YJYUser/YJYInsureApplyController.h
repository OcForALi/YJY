//
//  YJYInsureApplyController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYInsureApplyController : YJYViewController

@property (copy, nonatomic) NSString *kinsfolkId;
@property (strong, nonatomic) KinsfolkVO *kinsfolk;
@property (assign, nonatomic) uint64_t assessId;
@property (assign, nonatomic) uint64_t score;

+ (instancetype)instanceWithStoryBoard;

@end
