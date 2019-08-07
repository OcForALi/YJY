//
//  YJYScanLoginController.m
//  LBXScanDemo
//
//  Created by lbxia on 15/11/17.
//  No Comment © 2015年 lbxia. All rights reserved.
//

#import "YJYScanLoginController.h"

@interface YJYScanLoginController ()


@end

@implementation YJYScanLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    ScanLoginReq *req = [ScanLoginReq new];
    req.accessToken = self.token;
    req.ops = 2;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPScanLogin message:req controller:self command:APP_COMMAND_SaasappscanLogin success:^(id response) {
   
        [SYProgressHUD showSuccessText:@"扫码成功,请点击登录"];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (IBAction)loginAction:(id)sender {
    
    
    
    ScanLoginReq *req = [ScanLoginReq new];
    req.accessToken = self.token;
    req.ops = 1;
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:SAASAPPScanLogin message:req controller:self command:APP_COMMAND_SaasappscanLogin success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"登录成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
   
        
    } failure:^(NSError *error) {
        


        
    }];
    
}


@end
