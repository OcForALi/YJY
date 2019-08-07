//
//  YJYWalletController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYWalletController.h"
#import "YJYCashOutController.h"
#import "YJYIDCardVerifyController.h"
#import "YJYBankManageController.h"
#import "YJYBankModifyController.h"

@interface YJYWalletController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *outMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *InMoneyButton;

@property (strong, nonatomic) GetUserAccountRsp *rsp;

@end

@implementation YJYWalletController



+ (instancetype)instanceWithStoryBoard {
    
    return (YJYWalletController *)[UIStoryboard storyboardWithName:@"YJYCharge" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.outMoneyButton.layer.cornerRadius = 4;
    self.outMoneyButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.outMoneyButton.layer.borderWidth  = 1;
    
    self.InMoneyButton.layer.cornerRadius = 4;
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    [YJYNetworkManager requestWithUrlString:APPGetUserAccount message:nil controller:self command:APP_COMMAND_AppgetUserAccount success:^(id response) {
        
        self.rsp = [GetUserAccountRsp parseFromData:response error:nil];
        
        NSString *balance = (self.rsp.accountStr.length == 0) ?@"0.00" :  self.rsp.totalAccount;
        self.balanceLabel.text = [NSString stringWithFormat:@"%@ 元",balance];

        
    } failure:^(NSError *error) {
        
    }];
    
    [YJYNetworkManager requestWithUrlString:APPGetUserInfo message:nil controller:nil command:APP_COMMAND_AppgetUserInfo success:^(id response) {
        
        GetUserInfoRsp *rsp = [GetUserInfoRsp parseFromData:response error:nil];
        self.user = rsp.userVo;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    
    if ([identifier isEqualToString:@"toCashOut"]) {
        
        
        
        if (self.user.hasCash && !self.user.isReal) {
            
            [UIAlertController showAlertInViewController:self withTitle:nil message:@"根据《非银行支付机构网络支付业务管理办法》要求，网上提现需实名认证" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"去实名" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    YJYIDCardVerifyController *vc = [YJYIDCardVerifyController instanceWithStoryBoard];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            return NO;
        }
        
        if (self.user.hasCash && self.user.bankNum == 0){
            YJYBankModifyController *vc = [YJYBankModifyController instanceWithStoryBoard];
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
        
        BOOL isBalance = (self.rsp.account > 0);
        if (!isBalance) {
            [SYProgressHUD showFailureText:@"提现金额为零"];
        }
        return isBalance;
       
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"toCashOut"]) {
        YJYCashOutController *cashoutVC = (YJYCashOutController *)segue.destinationViewController;
        cashoutVC.user = self.user;
    }
}

#pragma mark - 验证

- (IBAction)toBankManagerAction:(id)sender {
    
    if (!self.user.isReal) {
        
        [UIAlertController showAlertInViewController:self withTitle:nil message:@"根据《非银行支付机构网络支付业务管理办法》要求，网上提现需实名认证" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"去实名" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                YJYIDCardVerifyController *vc = [YJYIDCardVerifyController instanceWithStoryBoard];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    
    YJYBankManageController *vc = [YJYBankManageController instanceWithStoryBoard];
    vc.hasBankCard = self.user.bankNum > 0;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)toFAQAction:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = kBankFAQURL;
    vc.title = @"常见问题";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
