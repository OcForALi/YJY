//
//  YJYLoginController.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/21.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLoginController.h"
#import "YJYWeakTimerManager.h"
#import "AppInterface.pbobjc.h"
#import "YJYNetworkManager.h"
#import "KeychainManager.h"
#import "YJYWebController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "YJYUserAgreementController.h"
@interface YJYLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger currentCountDown;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;



@property (assign, nonatomic) BOOL isKeyboarding;
@property (assign, nonatomic) BOOL isToNext;
///Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTopConstraint;

#define kPhoneDefaultTop ((IS_IPHONE_5 || IS_IPHONE_4) ? 240 : 300)
#define kPhoneChangeTop ((IS_IPHONE_5 || IS_IPHONE_4) ? 80 : 100)


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
    
    
    self.phoneNumTextField.attributedPlaceholder = [self placeholderWithText:@"输入手机号码"];
    self.passwordField.attributedPlaceholder = [self placeholderWithText:@"输入验证码/登录密码"];
    
    
    self.phoneNumTextField.delegate = self;
    self.passwordField.delegate = self;
    
    
    [self.passwordField setSecureTextEntry:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.phoneTopConstraint.constant = kPhoneDefaultTop;

}

- (NSMutableAttributedString *)placeholderWithText:(NSString *)text {

    NSString *holderText = text;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor lightGrayColor]
                        range:NSMakeRange(0, text.length)];
    
    return placeholder;
    

}




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];


    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Action



- (void)verifyEnable {

    
    if (self.phoneNumTextField.text.length != 11 || !self.passwordField.text) {
        
    
        
    }else if (self.phoneNumTextField.text.length == 11 && [NSString isMobileNumber:self.phoneNumTextField.text] && self.passwordField.text.length > 0) {
        
//        self.nextButton.enabled = YES;

    }else{
    
//        self.nextButton.enabled = YES;

    }
    
    

    
    
}


- (IBAction)comfireAction:(UIButton *)sender {
    
    if (self.phoneNumTextField.text.length != 11) {
        
        [SYProgressHUD showInfoText:@"请输入正确手机号码"];
        return;
        
    }
    [SYProgressHUD show];
    

    LoginReq *loginReq = [LoginReq new];
    loginReq.phone = self.phoneNumTextField.text;
    loginReq.code = self.passwordField.text;
    loginReq.source = Source_Company;
    loginReq.jpushId = [KeychainManager getValueWithKey:kJPushToken];
    
    
    if (self.passwordField.text.length >= 6) {
        loginReq.code = [self.passwordField.text MD5];
    }
    
    [YJYNetworkManager requestWithUrlString:Login message:loginReq controller:self command:APP_COMMAND_Login success:^(id response) {
        
       
        
        LoginRsp *rsp = [LoginRsp parseFromData:response error:nil];
        [YJYRoleManager sharedInstance].roleType = (YJYRoleType)rsp.roleId;// ;
        [YJYRoleManager sharedInstance].hgType = rsp.hgType;
        
        [KeychainManager saveWithKey:kUserphone Value:self.phoneNumTextField.text];
        [KeychainManager saveWithKey:kRoleId Value:[NSString stringWithFormat:@"%@",@([YJYRoleManager sharedInstance].roleType)]];
        [KeychainManager saveWithKey:kHgType Value:[NSString stringWithFormat:@"%@",@([YJYRoleManager sharedInstance].hgType)]];


        [self done];
   
    
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)callAction:(id)sender {
    
    
    [SYProgressHUD show];
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"400-000-601"]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [SYProgressHUD hide];
    [self.view addSubview:callWebView];

}
- (IBAction)phoneNumDidChange:(id)sender {
    
    if ([self.phoneNumTextField isFirstResponder] && self.phoneNumTextField.text.length > 11) {
        self.phoneNumTextField.text = [self.phoneNumTextField.text substringToIndex:11];
        return;
    }
    
    if(self.phoneNumTextField.text.length == 11 && _currentCountDown == 0){
        
        self.authCodeButton.userInteractionEnabled = YES;
    }
}

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)
- (void)done {
    
    [self.view endEditing:NO];
    
    [SYProgressHUD hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *rotate;
        rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.fromValue = [NSNumber numberWithFloat:0];
        rotate.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360)];
        rotate.duration = 0.5;
        rotate.repeatCount = 1;
        [self.logoImageView.layer addAnimation:rotate forKey:@"10"];
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3 animations:^{
                self.logoImageView.image = [UIImage imageNamed:@"login_logo_go_icon"];
                
            }completion:^(BOOL finished) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYWorkBenchDidLoginNotification object:nil];
                    [SYProgressHUD showSuccessText:@"登录成功"];
                    
                });
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self changeRootViewController:[YJYTabController instanceWithStoryBoard]];

                
                if (self.didSuccessLoginComplete) {
                    self.didSuccessLoginComplete(nil);
                }
            });
        });
    });

    
    

}

- (void)changeRootViewController:(UIViewController*)viewController {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = viewController;

    
}


- (IBAction)toAgreementAction:(id)sender {
    

    
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        YJYUserAgreementController *vc = [YJYUserAgreementController new];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    
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
    [SYProgressHUD show];
    sender.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    sender.spinner.color = APPHEXCOLOR;
    
    GetVerifyCodeReq *codeReq = [GetVerifyCodeReq new];
    codeReq.phone = self.phoneNumTextField.text;
    codeReq.purpose = @"Login";
    codeReq.source = 1;
    
    [YJYNetworkManager requestWithUrlString:GetSMSCode message:codeReq controller:self command:APP_COMMAND_GetSmscode success:^(id response) {
        
        [SYProgressHUD hide];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
            [self beginCountdown];
        });
        
    } failure:^(NSError *error) {
        

        [sender stopActivityIndicatorVisibility];

    }];
    
    
    
    
}

- (void)beginCountdown {
    
 
    _currentCountDown = 60;
    _timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
        
        
        if (_currentCountDown == 0) {
            [_timer invalidate];
            _timer = nil;
            [_authCodeButton setTitle:@"获取验证码" forState:0];
            _authCodeButton.userInteractionEnabled = YES;
            return;
        }
        
        _currentCountDown -=1;
        [_authCodeButton setTitle:[NSString stringWithFormat:@"剩余%d秒",(int)_currentCountDown] forState:UIControlStateNormal];
        
    } userInfo:@"fire" repeats:YES];
    
    [_timer fire];
}

#pragma mark - UITextField


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    [self verifyEnable];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view layoutIfNeeded];
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
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.phoneTopConstraint.constant = kPhoneChangeTop;
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
   
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.phoneTopConstraint.constant = kPhoneDefaultTop;;
        self.logoImageView.alpha = 1;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    }];
}


@end
