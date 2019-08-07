//
//  YJYHWeightController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HWeightDidDismissBlock)(NSInteger weight, NSInteger height);

@interface YJYHWeightController : YJYViewController
@property (assign, nonatomic) NSInteger weight;
@property (assign, nonatomic) NSInteger height;

@property (copy, nonatomic) HWeightDidDismissBlock dismissBlcok;
@end
