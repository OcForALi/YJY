//
//  YJYNewController.h
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYWebController.h"

@interface YJYNewController : YJYWebController

@property (strong, nonatomic)  Information *information;
/// 图片
@property(nonatomic, copy) NSString *imgURL;
@property(nonatomic,copy) NSString *text;
@property(nonatomic, copy) NSString *sketch;
@property(nonatomic, readwrite) uint64_t createTime;
@property(nonatomic, copy) NSString *description_p;
+ (instancetype)instanceWithStoryBoard;

@end
