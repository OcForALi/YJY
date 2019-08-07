//
//  YJYMineController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYMineController.h"
#import "SSPhotoPickerManager.h"
#import "YJYMineModifyController.h"
#import "YJYWalletController.h"
#import "YJYNavigationController.h"
#import "YJYIDCardVerifyController.h"

@interface YJYMineController ()

@property (assign, nonatomic) CGFloat firstRowHeight;
@property (strong, nonatomic) UserVO *user;


@property (weak, nonatomic) IBOutlet UIButton *avatorButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *unreadNumButton;

@property (weak, nonatomic) IBOutlet UILabel *hadVerifyTipLabel;
@end

@implementation YJYMineController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYMineController *)[UIStoryboard storyboardWithName:@"YJYUser" viewControllerIdentifier:NSStringFromClass(self)];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.avatorButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatorButton updateActivityIndicatorVisibility];

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.avatorButton setImage:[UIImage imageNamed:@"mine_profile_place"] forState:0];
    [self reloadNetworkingData];
    

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)reloadNetworkingData {

    [YJYNetworkManager requestWithUrlString:APPGetUserInfo message:nil controller:nil command:APP_COMMAND_AppgetUserInfo success:^(id response) {
        
        GetUserInfoRsp *rsp = [GetUserInfoRsp parseFromData:response error:nil];
        self.user = rsp.userVo;
        [self updateData];
        [self.avatorButton stopActivityIndicatorVisibility];

        
    } failure:^(NSError *error) {
        
        [self.avatorButton stopActivityIndicatorVisibility];

    }];
    
}

- (void)updateData {

    NSString *username = (self.user.name.length > 0) ? self.user.name : self.user.phone;
    
    [KeychainManager saveWithKey:kUsername Value:username];
    [KeychainManager saveWithKey:kUserheadimg Value:self.user.headImgURL];
    
    
    self.hadVerifyTipLabel.text = self.user.isReal ? @"已实名认证" : @"未进行实名认证";
    
    
    [self reloadData];

}

- (void)reloadData {
    
    [self.nicknameLabel setText:self.user.name];

    [self.phoneLabel setText:self.user.phone];
    [self.avatorButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.user.headImgURL]];
  
    self.unreadNumButton.layer.cornerRadius = 8;
    self.unreadNumButton.hidden = (self.user.msgNum <= 0);
    [self.unreadNumButton setTitle:[NSString stringWithFormat:@"%@",@(self.user.msgNum)] forState:0];
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {

    if (![KeychainManager getValueWithKey:SID]) {
        YJYNavigationController *navi = [[YJYNavigationController alloc]initWithRootViewController:[YJYLoginController instanceWithStoryBoard]];
        [self presentViewController:navi animated:YES completion:nil];
        return NO;
    }
    
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ToMineDetail"]) {
        YJYMineModifyController *modifyController = (YJYMineModifyController *)[segue destinationViewController];
        modifyController.user = self.user;
        modifyController.mineModifyDidDoneBlock = ^ (UserVO *user) {
        
            self.user = user;
            [self updateData];
            
        };
    }else if ([segue.identifier isEqualToString:@"ToCharge"]) {
    
        YJYWalletController *walletVC = (YJYWalletController *)[segue destinationViewController];
        walletVC.user = self.user;
    
    }
    
}


@end
