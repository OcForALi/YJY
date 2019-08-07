//
//  YJYLoginManager.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLoginManager.h"
#import "KeychainManager.h"


@implementation YJYLoginManager

+ (BOOL)isLogin {

    return ([KeychainManager getValueWithKey:SID] != nil);
}
+ (void)loginOut {

    [KeychainManager saveWithKey:SID Value:nil];
    [KeychainManager saveWithKey:kUserphone Value:nil];
    [KeychainManager saveWithKey:kUsername Value:nil];
    [KeychainManager saveWithKey:kUserheadimg Value:nil];
    
}
+ (void)loginInAndSaveSID:(NSString *)sid{

    [KeychainManager saveWithKey:SID Value:sid];

}

+ (NSString *)getSID {

    return [KeychainManager getValueWithKey:SID];

}


@end
