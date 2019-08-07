//
//  YJYCashOutController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYCashOutController.h"

@interface YJYCashOutSuccessController : YJYViewController

@property (copy, nonatomic) NSString *charge;
@property (copy, nonatomic) NSString *balance;

@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
+ (instancetype)instanceWithStoryBoard;

@end

@implementation YJYCashOutSuccessController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYCashOutSuccessController *)[UIStoryboard storyboardWithName:@"YJYCharge" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.balanceLabel.text = [NSString stringWithFormat:@"钱包余额 %@ 元",self.balance];
    self.chargeLabel.text = [NSString stringWithFormat:@"%@元",self.charge];
}
- (IBAction)confirmAction:(id)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.presentingViewController) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
    });
}
@end

@interface YJYCashOutController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *cashOutLabel;
@property (strong, nonatomic) GetUserAccountRsp *rsp;
@end

@implementation YJYCashOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetworkData];
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    [self.cashOutLabel becomeFirstResponder];
    
}
- (void)loadNetworkData {
    
    [YJYNetworkManager requestWithUrlString:APPGetUserAccount message:nil controller:self command:APP_COMMAND_AppgetUserAccount success:^(id response) {
        
        self.rsp = [GetUserAccountRsp parseFromData:response error:nil];
        self.balanceLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.accountStr];
        [self.balanceLabel sizeToFit];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (IBAction)outMoneyDidChangeAction:(UITextField *)sender {
    
    NSRange dotRange =  [self.cashOutLabel.text rangeOfString:@"."];
    NSInteger length = dotRange.location + 3;
    
    if ([self.cashOutLabel isFirstResponder] && self.cashOutLabel.text.length > length) {
        self.cashOutLabel.text = [self.cashOutLabel.text substringToIndex:length];
        return;
    }
    
}

- (IBAction)cashOutAction:(id)sender {
    
    
    if (!self.cashOutLabel.text || [self.cashOutLabel.text floatValue] == 0) {
        [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"请重新输入提现金额" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        return;
    }

    [SYProgressHUD show];
    
    WithdrawReq *req = [WithdrawReq new];
    req.fee = [self.cashOutLabel text];
    
    [YJYNetworkManager requestWithUrlString:Appwithdraw message:req controller:self command:APP_COMMAND_Appwithdraw success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"7个工作日内金额退还至原支付账户"];
        CGFloat levelMoney =  (CGFloat)(self.rsp.account+self.rsp.present)/100 - [req.fee floatValue];
        
        
        YJYCashOutSuccessController *vc = [YJYCashOutSuccessController instanceWithStoryBoard];
        vc.balance = [NSString stringWithFormat:@"%.2f",levelMoney];
        vc.charge = req.fee;

        
        [[UIWindow currentViewController] presentViewController:vc animated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
