//
//  YJYOrderHomeServicesController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"
typedef void(^YJYOrderHomeServicesDidSelectBlock)(IndexServiceItem *item);

@interface YJYOrderHomeServicesController : YJYViewController
@property (copy, nonatomic) YJYOrderHomeServicesDidSelectBlock didSelectBlock;
@end
