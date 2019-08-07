//
//  YJYVersionManager.h
//  YJYEnterprice
//
//  Created by wusonghe on 2017/2/28.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJYVersionManager : NSObject

typedef void(^DidVersionUpdated)(id response);

+ (void)checkVersion:(DidVersionUpdated)didVersionUpdated;

@end
