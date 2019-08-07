//
//  YJYOrderHospitalNurseController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef void(^OrderDidFinishBlock)(NSString *orderId);

@interface YJYOrderHospitalNurseController : YJYViewController


@property (copy, nonatomic) NSString *st;
@property (assign, nonatomic) uint32_t islti;
@property (nonatomic, assign) uint32_t bonus;


@property (copy, nonatomic) OrderDidFinishBlock orderDidFinishBlock;


+ (instancetype)instanceWithStoryBoard;

@end
