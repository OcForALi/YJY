//
//  YJYLanguagesController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYLanguagesDidSelectBlock)(GPBUInt32Array *languageArray,NSString *lanString);
@interface YJYLanguagesController : YJYViewController
@property (copy, nonatomic) YJYLanguagesDidSelectBlock didSelectBlock;
@property (strong, nonatomic) GPBUInt32Array *languageArray;

@end
