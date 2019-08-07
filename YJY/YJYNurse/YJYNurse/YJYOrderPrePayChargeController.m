//
//  YJYOrderPrePayChargeController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/9/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPrePayChargeController.h"
#import "YJYOrderQRController.h"

@interface YJYOrderPrePayChargeController ()
@property (weak, nonatomic) IBOutlet UITextField *chargeTextField;

@end

@implementation YJYOrderPrePayChargeController



+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPrePayChargeController *)[UIStoryboard storyboardWithName:@"YJYOrderPrePayCharge" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];
    
    
}

- (IBAction)enterAction:(id)sender {
    
    
    NSString *title = [NSString stringWithFormat:@"是否确认充值:%@元预付款",self.chargeTextField.text];
    
    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            return;
        }
        
        RechargePrepayFeeReq *req = [RechargePrepayFeeReq new];
        req.prepayFee = self.chargeTextField.text;
        req.orderId = self.orderId;
        req.payType = 5;
        
        [YJYNetworkManager requestWithUrlString:SAASAPPRechargePrepayFee message:req controller:self command:APP_COMMAND_SaasapprechargePrepayFee success:^(id response) {
            
            
            [SYProgressHUD showSuccessText:@"操作成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }];
    
    
}

@end
