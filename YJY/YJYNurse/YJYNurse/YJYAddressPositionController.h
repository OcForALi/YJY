//
//  YJYAddressPositionController.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/7.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserAddressVO;

typedef void(^AddressDidSavedBlock)(UserAddressVO *address);

@interface YJYAddressPositionController : YJYViewController

@property (copy, nonatomic) AddressDidSavedBlock addressDidSavedBlock;
@property (strong, nonatomic) UserAddressVO *address;
@property (assign, nonatomic) BOOL isEdit;


+ (instancetype)instanceWithStoryBoard;
@end
