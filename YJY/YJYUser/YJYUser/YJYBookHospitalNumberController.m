//
//  YJYBookHospitalNumberController.m
//  YJYUser
//
//  Created by wusonghe on 2017/10/24.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBookHospitalNumberController.h"
#import "YJYBookHospitalController.h"

@interface YJYBookHospitalNumberController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@end

@implementation YJYBookHospitalNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.numberTextField becomeFirstResponder];
}

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBookHospitalNumberController *)[UIStoryboard storyboardWithName:@"YJYBookHospital" viewControllerIdentifier:NSStringFromClass(self)];
}

- (IBAction)toNext:(id)sender {
    
    if (self.numberTextField.text.length != 10) {
         [UIAlertController showAlertInViewController:self withTitle:@"请输入10位住院号" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    GetUserInfoByOrgNOReq *req = [GetUserInfoByOrgNOReq new];
    req.orgId = self.org.orgVo.orgId;
    req.orgNo = self.numberTextField.text;
    
    [YJYNetworkManager requestWithUrlString:APPGetUserInfoByOrgNO message:req controller:self command:APP_COMMAND_AppgetUserInfoByOrgNo success:^(id response) {
        
        GetUserInfoByOrgNORsp *rsp = [GetUserInfoByOrgNORsp parseFromData:response error:nil];
        if (rsp.rspFlag != 0) {
            
            ///// 0-成功返回 1-第三方系统异常，可以直接去下单页 10-格式错误，提示报错 11-未查询到用户信息

            if (rsp.rspFlag == 1) {
                rsp.errorMsg  = @"未查询到该陪护人的住院信息，是否继续下单?";
            }
            [UIAlertController showAlertInViewController:self withTitle:rsp.errorMsg message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"重新输入" destructiveButtonTitle:rsp.rspFlag > 1 ? nil : @"继续下单" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    YJYBookHospitalController *vc  = [YJYBookHospitalController instanceWithStoryBoard];
                    vc.hospitalNumber = self.numberTextField.text;
                    vc.currentOrg = self.org;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                
                
            }];
        }else {
            
            YJYBookHospitalController *vc  = [YJYBookHospitalController instanceWithStoryBoard];
            vc.hospitalBra = rsp.bra;
            vc.isHis = YES;
            vc.hospitalNumber = self.numberTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
       
        
    } failure:^(NSError *error) {
        
    }];
    
 
    
    
}

@end
