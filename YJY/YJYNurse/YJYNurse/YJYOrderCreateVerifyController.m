//
//  YJYOrderCreateVerifyController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/16.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderCreateVerifyController.h"
#import "YJYWeakTimerManager.h"
#import "YJYOrderCreateController.h"
#import "YJYOrderCreateHospitalController.h"
#import "YJYInsureCreateController.h"

typedef NS_ENUM(NSInteger, YJYOrderCreateState) {

    YJYOrderCreateStateNormal,
    YJYOrderCreateStateWaitSendCode,
    YJYOrderCreateStateHadSendCode,
};

@interface YJYOrderCreateVerifyController ()
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;

@property (assign, nonatomic) YJYOrderCreateState createState;


//data

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger currentCountDown;
@property (weak, nonatomic) IBOutlet UIButton *genRandomAccountButton;
@end

@implementation YJYOrderCreateVerifyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderCreateVerifyController *)[UIStoryboard storyboardWithName:@"YJYOrderCreate" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.codeView.alpha = 0;
    
//    _phoneTextField.text = @"13286826558";
    
    [_phoneTextField setValue:[UIColor colorWithWhite:1 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdTextField setValue:[UIColor colorWithWhite:1 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self loadNetworkData];
   
 
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.phoneTextField becomeFirstResponder];
}

- (void)loadNetworkData {
    

    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgInfo message:nil controller:nil command:APP_COMMAND_SaasappgetHgInfo success:^(id response) {
        
        
        GetHgInfoRsp *rsp = [GetHgInfoRsp parseFromData:response error:nil];
        
        self.genRandomAccountButton.hidden = !rsp.hasDiffno;
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

#pragma mark - network
//验证手机
- (void)checkPhone {
    
    [SYProgressHUD show];
    
    if (!self.phoneTextField.text || self.phoneTextField.text.length != 11) {
        [SYProgressHUD showFailureText:@"手机输入错误"];
        return;
    }
    
    UserExistReq *req = [UserExistReq new];
    req.phone = self.phoneTextField.text;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCheckUserExist message:req controller:self command:APP_COMMAND_SaasappcheckUserExist success:^(id response) {
        
        [SYProgressHUD hide];
        
        UserExistRsp *rsp = [UserExistRsp parseFromData:response error:nil];
        
        if (rsp.userId > 0) {
            
            [YJYSettingManager sharedInstance].userId = rsp.userId;
            [self toAddOrderVc];
            
        }else {
            self.tipLabel.text = @"未检查检索到该会员\n请发送验证码，创建新账号";
            [self.tipLabel sizeToFit];
            self.createState = YJYOrderCreateStateWaitSendCode;
            
            [SYProgressHUD showFailureText:@"请创建新账号"];
            [UIView animateWithDuration:0.8 animations:^{
                
                self.codeView.alpha = 1;
                [self.view layoutIfNeeded];
            }];
        }
        
        
     
        
    } failure:^(NSError *error) {
        
        
    }];
}

//验证码
- (void)sendCode {

    [SYProgressHUD show];
    
    GetVerifyCodeReq *req = [GetVerifyCodeReq new];
    req.phone = self.phoneTextField.text;
    req.purpose = @"Login";

    
    [YJYNetworkManager requestWithUrlString:GetSMSCode message:req controller:self command:APP_COMMAND_GetSmscode success:^(id response) {
        
        [SYProgressHUD hide];
        self.createState = YJYOrderCreateStateHadSendCode;

    } failure:^(NSError *error) {
        
        

    }];
}

//下单
- (void)enter{

    [SYProgressHUD show];
    
    SignUserReq *req = [SignUserReq new];
    req.phone = self.phoneTextField.text;
    req.code = self.pwdTextField.text;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSignUserInfo message:req controller:self command:APP_COMMAND_SaasappsignUserInfo success:^(id response) {
        
        SignUserRsp *rsp = [SignUserRsp parseFromData:response error:nil];
        [SYProgressHUD hide];
        if (rsp.userId > 0) {
            
            [YJYSettingManager sharedInstance].userId = rsp.userId;
            [self toAddOrderVc];
            self.createState = YJYOrderCreateStateNormal;


        }else {
        
            self.createState = YJYOrderCreateStateHadSendCode;
            self.tipLabel.text = @"验证错误，请重新输入验证码";
            self.pwdTextField.textColor = APPREDCOLOR;

        }
       
        
    } failure:^(NSError *error) {
        
        self.pwdTextField.textColor = APPREDCOLOR;
        
        
    }];
    
}

- (void)setCreateState:(YJYOrderCreateState)createState {
    
    _createState = createState;
    
    if (createState == YJYOrderCreateStateNormal) {
        
        [_timer invalidate];
        _timer = nil;
        [self.operationButton setTitle:@"下单" forState:0];
        self.operationButton.enabled = YES;
    }else if (createState == YJYOrderCreateStateWaitSendCode) {
        
        [self.operationButton setTitle:@"发送验证码" forState:0];
        self.tipLabel.text = @"未检查检索到该会员\n请发送验证码，创建新账号";
    }else if (createState == YJYOrderCreateStateHadSendCode){
        
        [self.operationButton setTitle:@"创建并下单" forState:0];
        self.tipLabel.text = @"请输入验证码";
        [self beginCountdown];
    }
}

#pragma mark - Action

- (id)toAddOrderVc {

    if (self.isAddApply) {
        
        YJYInsureCreateController *vc = [YJYInsureCreateController instanceWithStoryBoard];
        vc.contactPhone = self.phoneTextField.text;
        self.phoneTextField.text = @"";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
    
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
            
            YJYOrderCreateController *vc = [YJYOrderCreateController instanceWithStoryBoard];
            vc.createType = YJYOrderCreateTypeHome;
            vc.contactPhone = self.phoneTextField.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            return vc;
            
        }else {
            
            YJYOrderCreateHospitalController *vc = [YJYOrderCreateHospitalController instanceWithStoryBoard];
            vc.contactPhone = self.phoneTextField.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            return vc;
            
        }
    }
    
    return nil;

}
- (IBAction)genRandomAccountAction:(id)sender {
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCreateDiffnoUser message:nil controller:self command:APP_COMMAND_SaasappcreateDiffnoUser success:^(id response) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SYProgressHUD hide];
            
            
            CreateDisffnoUserRsp *rsp = [CreateDisffnoUserRsp parseFromData:response error:nil];
            [YJYSettingManager sharedInstance].userId = rsp.userId;
            self.phoneTextField.text = rsp.diffno;
            
            id vc = [self toAddOrderVc];
            
            if([vc respondsToSelector:@selector(setContactPhone:)]) {
                [vc setContactPhone:rsp.diffno];
            }
            

           
            
        
            self.createState = YJYOrderCreateStateNormal;
        });
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)phoneDidChange:(id)sender {
    
    if ([self.phoneTextField isFirstResponder] && self.phoneTextField.text.length >= 11) {
        if (self.phoneTextField.text.length > 11) {
            self.phoneTextField.text = [self.phoneTextField.text substringToIndex:11];

        }else {
            [self operationAction:nil];
            [self.phoneTextField resignFirstResponder];
        }
        
        return;
    }
}

- (IBAction)codeDidChange:(id)sender {
    
    self.pwdTextField.textColor = [UIColor whiteColor];
    if (self.pwdTextField.text.length == 4 && self.createState == YJYOrderCreateStateHadSendCode) {
        
        [self.pwdTextField resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [self enter];

        });
        
    }
}


- (IBAction)operationAction:(id)sender {
    
    if (self.createState == YJYOrderCreateStateNormal) {
        [self checkPhone];
    }else if (self.createState == YJYOrderCreateStateWaitSendCode) {
        [self sendCode];
    }
}


- (void)beginCountdown {
    
    [self.operationButton stopActivityIndicatorVisibility];
    self.operationButton.enabled = NO;
    
    _currentCountDown = 60;
    _timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
        
        
        if (_currentCountDown == 0) {
            [_timer invalidate];
            _timer = nil;
            [self.operationButton setTitle:@"获取验证码" forState:0];
            self.operationButton.enabled = YES;
            
            return;
        }
        
        _currentCountDown -=1;
        [self.operationButton setTitle:[NSString stringWithFormat:@"%d秒",(int)_currentCountDown] forState:UIControlStateNormal];
        
    } userInfo:@"fire" repeats:YES];
    
    [_timer fire];
}

@end
