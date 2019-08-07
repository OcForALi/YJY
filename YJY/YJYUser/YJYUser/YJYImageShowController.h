//
//  YJYImageShowController.h
//  YJYUser
//
//  Created by wusonghe on 2017/9/16.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYImageShowDidLoadedBlock)(UIImage *image);


@interface YJYImageShowController : YJYViewController


@property (copy, nonatomic) NSString *imgurl;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) YJYImageShowDidLoadedBlock didLoadedBlock;
@end
