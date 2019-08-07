//
//  YJYLoginManager.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJYLoginManager : NSObject

//login
+ (BOOL)isLogin;
+ (void)loginOut;
+ (void)loginInAndSaveSID:(NSString *)sid;
+ (NSString *)getSID;

@end
