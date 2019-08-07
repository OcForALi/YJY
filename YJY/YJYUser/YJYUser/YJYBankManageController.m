//
//  YJYBankManageController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/7.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBankManageController.h"
#import "YJYBankModifyController.h"

@interface YJYBankManageController ()
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cardActionButton;

@property (strong, nonatomic) UserBankVO *userBankVo;
@property (strong, nonatomic) UserBank *userBank;

@end

@implementation YJYBankManageController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBankManageController *)[UIStoryboard storyboardWithName:@"YJYBankCard" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardView.hidden = YES;
    
    self.cardActionButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.cardActionButton.layer.borderWidth  = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadBankList];

}

- (void)loadBankList {
    
    [YJYNetworkManager requestWithUrlString:APPListUserBank message:nil controller:self command:APP_COMMAND_ApplistUserBank success:^(id response) {
        
        ListBankRsp *rsp = [ListBankRsp parseFromData:response error:nil];
        self.userBankVo = rsp.bankListArray.firstObject;
        self.userBank = self.userBankVo.bank;
        [self loadUserBank];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadUserBank {

    self.cardnameLabel.text = self.userBank.bankName;
    self.cardTypeLabel.text = self.userBank.bankType == 0 ? @"储蓄卡" : @"信用卡";
    self.cardNumberLabel.text = [NSString stringWithFormat:@"****      ****      ****      %@",self.userBankVo.cardNostr];
    
    self.cardView.hidden = !self.userBank;
    [self.cardActionButton setTitle:self.hasBankCard ? @"修改银行卡" : @"添加银行卡" forState:0];
}

- (IBAction)addModifyBankAction:(id)sender {
    
    YJYBankModifyController *vc = [YJYBankModifyController instanceWithStoryBoard];
    vc.userBank = self.userBank;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end
