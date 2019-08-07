//
//  YJYLoginController.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYLoginController.h"
#import "YJYWeakTimerManager.h"
#import "AppInterface.pbobjc.h"
#import "YJYNetworkManager.h"
#import "KeychainManager.h"
#import "YJYNavigationController.h"
#import "YJYWebController.h"
#import "YJYUserAgreementController.h"
@interface YJYLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger currentCountDown;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTextFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;


@property (assign, nonatomic) BOOL isKeyboarding;
@property (assign, nonatomic) BOOL isToNext;
///Constraint

#define kPhoneDefaultTop ((IS_IPHONE_5 || IS_IPHONE_4) ? 250 : 300)
#define kPhoneActivedTop 10

@end

@implementation YJYLoginController


+ (instancetype)presentLoginVCWithInVC:(UIViewController *)vc {

    
    YJYLoginController *loginVC = [self instanceWithStoryBoard];
    
    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:loginVC];
    
    [vc presentViewController:nav animated:YES completion:nil];
    
    return loginVC;
    
}


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLoginController *)[UIStoryboard storyboardWithName:@"YJYLogin" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_white_icon" highImage:@"back_white_icon" target:self action:@selector(backAction:)];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    self.phoneNumTextField.delegate = self;
    self.authCodeTextField.delegate = self;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.imageHeightConstraint.constant = kPhoneDefaultTop;
    self.phoneTextFieldConstraint.constant = kPhoneDefaultTop;
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(250, 250, 250, 0)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [IQKeyboardManager sharedManager].enable = NO;

    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    
    

    [IQKeyboardManager sharedManager].enable = YES;

    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Action

- (void)verifyEnable {

    
    if (self.phoneNumTextField.text.length != 11 || !self.authCodeTextField.text) {
        
        self.nextButton.enabled = NO;
        
    }else if (self.phoneNumTextField.text.length == 11 && [NSString isMobileNumber:self.phoneNumTextField.text] && self.authCodeTextField.text.length > 0) {
        
        self.nextButton.enabled = YES;

    }else{
    
        self.nextButton.enabled = YES;

    }

    
    
}


- (IBAction)comfireAction:(UIButton *)sender {
    
   
    [SYProgressHUD show];
    

    
    LoginReq *loginReq = [LoginReq new];
    loginReq.phone = self.phoneNumTextField.text;
    loginReq.code = self.authCodeTextField.text;
    loginReq.source = self.isEnterprise ? Source_Company : Source_User;
    loginReq.jpushId = [KeychainManager getValueWithKey:kJPushToken];
    
    [YJYNetworkManager requestWithUrlString:Login message:loginReq controller:self command:APP_COMMAND_Login success:^(id response) {
        
        if (!response) {
            return;
        }
        
        if (self.didSuccessLoginComplete) {
            self.didSuccessLoginComplete(response);
        }
        
        
        [KeychainManager saveWithKey:kUserphone Value:self.phoneNumTextField.text];
        
        
        [YJYNetworkManager requestWithUrlString:GetRongToken message:nil controller:self command:APP_COMMAND_GetRongToken success:^(id response) {
            
            if (response) {
                
                RongTokenRsp *rsp = [RongTokenRsp new];
                [rsp mergeFromData:response extensionRegistry:nil];
                
                [KeychainManager saveWithKey:kUserRongToken Value:rsp.rongToken];
                
                
                [SYProgressHUD showSuccessText:@"登录成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderListUpdateNotification object:nil];
                [self backAction:nil];
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
      
        
        
        
        
    } failure:^(NSError *error) {
        
        

        
    }];
    
    
    
}
- (IBAction)sendAuthCodeAction:(UIButton *)sender {
    
    if (self.phoneNumTextField.text.length == 0) {
        
        [SYProgressHUD showFailureText:@"手机不能为空"];
        return;
    }
    
    if (self.phoneNumTextField.text.length != 11) {
        [SYProgressHUD showFailureText:@"手机号输入错误"];
        return;
    }
    sender.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    sender.spinner.color = APPHEXCOLOR;
    [sender updateActivityIndicatorVisibility];

    GetVerifyCodeReq *codeReq = [GetVerifyCodeReq new];
    codeReq.phone = self.phoneNumTextField.text;
    codeReq.purpose = @"Login";
    codeReq.source = 0;
    
    [YJYNetworkManager requestWithUrlString:GetSMSCode message:codeReq controller:self command:APP_COMMAND_GetSmscode success:^(id response) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self beginCountdown];
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)beginCountdown {
    
    [_authCodeButton stopActivityIndicatorVisibility];
    _authCodeButton.enabled = NO;

    _currentCountDown = 60;
    _timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
        
        
        if (_timer && _currentCountDown == 0 ) {
            [_timer invalidate];
             _timer = nil;
             [_authCodeButton setTitle:@"获取验证码" forState:0];
             _authCodeButton.enabled = YES;
            
            return;
        }
        
        _currentCountDown -=1;
        [_authCodeButton setTitle:[NSString stringWithFormat:@"剩余%d秒",(int)_currentCountDown] forState:UIControlStateNormal];
        
    } userInfo:@"fire" repeats:YES];
    
    [_timer fire];
}
- (IBAction)backAction:(id)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        self.authCodeTextField.text = @"";

    });
}

- (IBAction)toAgreementAction:(id)sender {
    

    
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        YJYUserAgreementController *vc = [YJYUserAgreementController new];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    
}


#pragma mark - UITextField


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    
    [self verifyEnable];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view layoutIfNeeded];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if ([textField isEqual:self.authCodeButton]) {
        [self comfireAction:nil];
    }
    
    return YES;
}



#pragma mark - UIKeyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (self.isKeyboarding) {
        return;
    }
    self.isKeyboarding = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7" alpha:1]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"share_back_icon" highImage:@"share_back_icon" target:self action:@selector(backAction:)];

  
    self.title = @"登录";
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];

    [UIView animateWithDuration:animationDuration animations:^{
        self.phoneTextFieldConstraint.constant = kPhoneActivedTop;

        self.logoImageView.alpha = 0;
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {

    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    if (!self.isKeyboarding || self.isToNext) {
        self.isToNext = YES;
        return;
    }
    self.isKeyboarding = NO;
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_white_icon" highImage:@"back_white_icon" target:self action:@selector(backAction:)];
    self.title = @"";
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
   

    
    [UIView animateWithDuration:animationDuration animations:^{
        self.phoneTextFieldConstraint.constant = kPhoneDefaultTop;
        self.logoImageView.alpha = 1;
        [self.navigationController.navigationBar lt_setBackgroundColor:kColorAlpha(250, 250, 250, 0)];
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {

    }];
}

@end
