//
//  YJYImageShowController.h
//  YJYUser
//
//  Created by wusonghe on 2017/9/16.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYImageShowDidLoadedBlock)(UIImage *image);


@interface YJYImageShowController : YJYViewController


@property (copy, nonatomic) NSString *imgurl;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) BOOL isEdit;
@property (copy, nonatomic) YJYImageShowDidLoadedBlock didLoadedBlock;
- (void)setShowHighQualityImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
