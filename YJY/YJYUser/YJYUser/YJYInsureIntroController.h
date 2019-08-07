//
//  YJYInsureIntroController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/14.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
typedef void(^OrderDidFinishBlock)(NSString *orderId);

@interface YJYInsureIntroController : YJYWebController
@property (copy, nonatomic) NSString *st;
@property (assign, nonatomic) uint32_t adcode;

@property (copy, nonatomic) OrderDidFinishBlock orderDidFinishBlock;
@property (copy, nonatomic) NSString *titleDes;

+ (instancetype)instanceWithStoryBoard;
@end
