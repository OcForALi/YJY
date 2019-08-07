//
//  YJYOrderPayoffController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/27.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYOrderPayoffController : YJYViewController

@property (strong, nonatomic) OrderVO *order;
@property (strong, nonatomic) NSArray<NSString*> *settDateArray;

+ (instancetype)instanceWithStoryBoard;
@end
