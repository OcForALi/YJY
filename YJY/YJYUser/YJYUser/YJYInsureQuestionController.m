//
//  YJYInsureQuestionController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureQuestionController.h"
#import "YJYInsureApplyController.h"
#import "YJYInsureDetailController.h"

@interface YJYInsureQuestionController ()

@end

@implementation YJYInsureQuestionController

#define kCallInsureAssessHandle @"callInsureAssessHandle"
#define kInitTest @"initTest"
#define kAssessId @"assessId"
- (void)viewDidLoad {
    
    

    
    NSMutableString *urlM = [NSMutableString stringWithString:kInsureQuestionURL];
    [urlM appendFormat:@"?idcard=%@",self.idCardNO];
    
    if (self.insureNo) {
        [urlM appendFormat:@"&insureNO=%@",self.insureNo];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(dismiss)];
    }
    
    self.urlString = urlM;
    [super viewDidLoad];
    self.title = @"自理能力自评";
    
}


- (void)configureBridge {

    
    [super configureBridge];
    
    [self.bridge registerHandler:kCallInsureAssessHandle handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(@{@"data":@"200"});
        
        if (self.isFromDetail) {
            
            if (self.didScoreDone) {
                self.didScoreDone(data);
            }
            
            [self.navigationController  popViewControllerAnimated:YES];
        }else {
            YJYInsureDetailController *vc = [YJYInsureDetailController instanceWithStoryBoard];
            vc.insreNO = self.insureNo;
            vc.isProcess = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [SYProgressHUD showSuccessText:@"申请成功"];
        }
    }];
    
}


- (void)refresh {
    
    [self toReload];
}

- (void)loadTitle:(NSString *)title {
    
    self.title = @"生活能力自评";
    
}
- (void)dismiss {

    [UIAlertController showAlertInViewController:self withTitle:@"是否取消自评" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
