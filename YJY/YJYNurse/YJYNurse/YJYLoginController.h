//
//  YJYLoginController.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/21.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSuccessLoginComplete)(id response);


@interface YJYLoginController : YJYViewController

@property (copy, nonatomic) DidSuccessLoginComplete didSuccessLoginComplete;
@property (assign, nonatomic) BOOL isEnterprise;

+ (instancetype)presentLoginVCWithInVC:(UIViewController *)vc;


@end
