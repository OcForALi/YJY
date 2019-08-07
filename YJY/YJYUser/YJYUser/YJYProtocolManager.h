//
//  YJYProtocolManager.h
//  YJYUser
//
//  Created by wusonghe on 2017/3/27.
//  Copyright © 2017年 samwuu. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YJYProtocolFromType) {

    YJYProtocolFromTypeNormal,
    YJYProtocolFromTypePush,
};

@interface YJYProtocolManager : NSObject

+ (id)viewControllerWithProtocol:(NSString *)protocol;
+ (void)pushViewControllerFrom:(UIViewController *)fromVC url:(NSString *)url type:(YJYProtocolFromType)type;

@end
