//
//  YJYInsureSelfIntroController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/5.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureSelfIntroController.h"
#import "YJYInsureChooseServiceController.h"

@interface YJYInsureSelfIntroController ()

@end

@implementation YJYInsureSelfIntroController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureSelf" viewControllerIdentifier:className];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"长护险自照服务";
    self.webView.frame = CGRectMake(0, 64, self.webView.frame.size.width, self.webView.frame.size.height - 64 - 60);
    self.urlString = kInsureserviceintro;
}

- (IBAction)done:(id)sender {
    
    [self toReviewApply];
}

- (void)toReviewApply {
    
    YJYInsureChooseServiceController *vc = [YJYInsureChooseServiceController instanceWithStoryBoard];
    vc.insureNo = self.insureNo;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
