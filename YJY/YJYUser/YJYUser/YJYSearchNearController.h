//
//  YJYSearchNearController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/1.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HospitalDidSelectBlock)(OrgDistanceModel *org);



@interface YJYSearchNearController : YJYViewController

+ (instancetype)instanceWithStoryBoard;



@property (copy, nonatomic) HospitalDidSelectBlock hospitalDidSelectBlock;

@end
