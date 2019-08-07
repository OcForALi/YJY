//
//  YJYInterceptManager.h
//  YJYUser
//
//  Created by wusonghe on 2017/4/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^DoneBlock)();
typedef void(^DoneMsgBlock)(NSString *msg);

typedef void(^Success)(id response);
typedef void(^Failure)(NSError *error);

@interface YJYInterceptManager : NSObject
+ (void)interceptDidServiceNoExistWithSt:(NSString *)st adcode:(uint32_t)adcode islti:(BOOL)islti succuss:(Success)success failure:(Failure)failure;
@end
