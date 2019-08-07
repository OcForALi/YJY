//
//  YJYBankModifyController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/7.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBankModifyController.h"

@interface YJYBankModifyController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardBankTextField;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation YJYBankModifyController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBankModifyController *)[UIStoryboard storyboardWithName:@"YJYBankCard" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.userBank ? @"修改银行卡" : @"增加银行卡";
    [self.doneButton setTitle:self.userBank ? @"确认修改" : @"确认增加" forState:0];
    self.doneButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.doneButton.layer.borderWidth  = 1;
    
    if (self.userBank) {
        self.nameTextField.text = self.userBank.cardholderName;
        self.cardNumTextField.text = self.userBank.cardNo;
        self.cardBankTextField.text = self.userBank.bankBranch;

    }
}

- (IBAction)done:(id)sender {
    
    
    NSString *url = self.userBank ? APPUpdateUserBank : APPAddUserBank;
    APP_COMMAND command = self.userBank ? APP_COMMAND_AppupdateUserBank : APP_COMMAND_AppaddUserBank;
    
    NSString *tipString = !self.userBank ? @"增加成功" : @"修改成功";
    
    AddUserBankReq *req = [AddUserBankReq new];
    req.cardholderName = self.nameTextField.text;
    req.cardNo = self.cardNumTextField.text;
    req.bankBranch = self.cardBankTextField.text;
    
    [YJYNetworkManager requestWithUrlString:url message:req controller:self command:command success:^(id response) {
        
        [SYProgressHUD showSuccessText:tipString];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

@end
