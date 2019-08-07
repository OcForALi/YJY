//
//  YJYAddressesController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressesDidSelectBlock)(UserAddressVO *address);
@interface YJYAddressesController : YJYViewController

@property (copy, nonatomic) AddressesDidSelectBlock didSelectBlock;

+ (instancetype)instanceWithStoryBoard;
@property (assign, nonatomic) BOOL isApply;

@end
