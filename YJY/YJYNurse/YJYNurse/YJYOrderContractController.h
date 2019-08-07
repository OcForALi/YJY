//
//  YJYOrderContractController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/10.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYWebController.h"
typedef void(^YJYOrderContractDidDoneBlock)();
typedef void(^YJYOrderContractDidReturnImage)(NSString *imageID,NSString *imageURL);


@interface YJYOrderContractController : YJYWebController

@property (copy, nonatomic) YJYOrderContractDidDoneBlock didDoneBlock;
@property (copy, nonatomic) YJYOrderContractDidDoneBlock didSkipBlock;
@property (copy, nonatomic) YJYOrderContractDidReturnImage didReturnImage;

@property (copy, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL isSetup;
@property (assign, nonatomic) BOOL isDenySkip;
@property (assign, nonatomic) BOOL isReSign;
///0 = 新增 1 = 更改
@property (nonatomic ,assign) NSInteger newOrAltered;

@end
