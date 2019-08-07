//
//  YJYPersonEditController.h
//  YJYUser
//
//  Created by wusonghe on 2017/9/1.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PersonEditDidDoneBlock)(KinsfolkVO *kinsfolk);

@interface YJYPersonEditController : YJYViewController


+ (instancetype)instanceWithStoryBoard;
@property (assign, nonatomic) BOOL firstAdd;
@property(nonatomic, readwrite) uint32_t kinsType;
@property (strong, nonatomic) KinsfolkVO *kinsfolk;
@property (copy, nonatomic) PersonEditDidDoneBlock didDoneBlock;

@end
