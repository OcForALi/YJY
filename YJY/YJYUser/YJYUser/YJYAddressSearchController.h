//
//  YJYAddressSearchController.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

typedef void(^AddressDidSearchBlock)(UserAddressVO *address);

@interface YJYAddressSearchController : YJYTableViewController
@property (copy, nonatomic) AddressDidSearchBlock addressDidSearchBlock;
@end
