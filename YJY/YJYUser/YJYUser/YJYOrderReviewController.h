//
//  YJYOrderReviewController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYOrderReviewController : YJYViewController
@property (strong, nonatomic) OrderVO *order;
@property (assign, nonatomic) BOOL isEdit;
+ (instancetype)instanceWithStoryBoard;
@end