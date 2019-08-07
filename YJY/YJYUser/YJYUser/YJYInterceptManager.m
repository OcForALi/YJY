
//
//  YJYInterceptManager.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInterceptManager.h"

@implementation YJYInterceptManager



+ (void)interceptDidServiceNoExistWithSt:(NSString *)st adcode:(uint32_t)adcode islti:(BOOL)islti succuss:(Success)success failure:(Failure)failure {
    
    [SYProgressHUD show];
    
    
    GetPriceReq *req = [GetPriceReq new];
    req.st =  (uint32_t)[st integerValue];
    req.adcode = adcode;
    req.islti = islti;
    
    
    [YJYNetworkManager requestWithUrlString:APPGetPrice message:req controller:nil command:APP_COMMAND_AppgetPrice success:^(id response) {
        
        GetPriceRsp *rsp = [GetPriceRsp parseFromData:response error:nil];
        if (rsp.familyPriceVolistArray.count > 0) {
            [SYProgressHUD hide];
            success(nil);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
