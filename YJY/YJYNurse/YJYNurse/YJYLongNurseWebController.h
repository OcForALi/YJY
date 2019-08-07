//
//  YJYLongNurseWebController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/16.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYWebController.h"

typedef void(^YJYLongNurseWebDidComfire)(NSDictionary *dict);

@interface YJYLongNurseWebController : YJYWebController
@property (copy, nonatomic) YJYLongNurseWebDidComfire didComfire;
@end
