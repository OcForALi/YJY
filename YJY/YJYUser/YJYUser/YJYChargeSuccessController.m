//
//  YJYChargeSuccessController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/14.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYChargeSuccessController.h"
#import "YJYTabController.h"
@interface YJYChargeSuccessController ()
@property (weak, nonatomic) IBOutlet UIImageView *bigLogoView;
@property (weak, nonatomic) IBOutlet UIImageView *chargeLogoView;
@property (weak, nonatomic) IBOutlet UILabel *chargeSuccessLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceLabelBottomConstraint; //175 300

@end

@implementation YJYChargeSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    self.bigLogoView.hidden = self.isCharge;

    self.chargeLogoView.hidden = !self.isCharge;
    self.chargeSuccessLabel.hidden = !self.isCharge;

  //  self.balanceLabelBottomConstraint.constant = self.isCharge ? 300 : 175;

    
    [self loadNetworkData];
    
    NSString *needPay = [YJYPaymentManager sharedInstance].payResult;
    self.chargeLabel.text = [NSString stringWithFormat:@"成功支付%@元",needPay];
    [YJYPaymentManager sharedInstance].payResult = 0;
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}



+ (instancetype)instanceWithStoryBoard {
    
    return (YJYChargeSuccessController *)[UIStoryboard storyboardWithName:@"YJYCharge" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)loadNetworkData {
    
    [YJYNetworkManager requestWithUrlString:APPGetUserAccount message:nil controller:self command:APP_COMMAND_AppgetUserAccount success:^(id response) {
        
        GetUserAccountRsp *rsp = [GetUserAccountRsp parseFromData:response error:nil];
        self.balanceLabel.text = [NSString stringWithFormat:@"用户余额 %@ 元",rsp.totalAccount];
       
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        [SYProgressHUD hide];
    }];
}

- (IBAction)confirmAction:(id)sender {
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.presentingViewController) {
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.didDismissBlock) {
                    self.didDismissBlock();
                }
            }];
            
            
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];

            
        }
    });
    
 //   [self dismissViewControllerAnimated:YES completion:nil];
}

@end
