//
//  YJYOrderQRController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/13.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderQRController.h"
#import <Masonry.h>

@interface YJYOrderQRDoneView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *doneIcon;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
+ (instancetype)instanceWithXIB;

@end

@implementation YJYOrderQRDoneView

+ (instancetype)instanceWithXIB {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    YJYOrderQRDoneView *tmpCustomView = [nib objectAtIndex:0];
    
    return tmpCustomView;
}

@end

@interface YJYOrderQRController ()
@property (weak, nonatomic) IBOutlet UIImageView *smallQRIcon;
@property (weak, nonatomic) IBOutlet UILabel *qrtipLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;

@property (weak, nonatomic) IBOutlet UILabel *scanResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

//done

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) YJYOrderQRDoneView *qrDoneView;
@property (nonatomic ,strong) UILabel *paymentAmountLaebl;
//data

@property (strong, nonatomic) GetQRCodeRsp *rsp;
@property (assign, nonatomic) BOOL isDone;
@property (assign, nonatomic) BOOL shouldStop;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic ,assign) NSInteger time;

@end

@implementation YJYOrderQRController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderQRController *)[UIStoryboard storyboardWithName:@"YJYOrderQRController" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收款二维码";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 50, 50)];
    [backButton setImage:[UIImage imageNamed:@"app_back_icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.qrDoneView = [YJYOrderQRDoneView instanceWithXIB];
    self.qrDoneView.hidden = YES;
    self.qrDoneView.frame = self.bgView.bounds;
    [self.bgView addSubview:self.qrDoneView];
    
    self.paymentAmountLaebl = [UILabel new];
    self.paymentAmountLaebl.font = [UIFont systemFontOfSize:14];
    self.paymentAmountLaebl.textColor = [UIColor colorWithRed:43.0/255.0 green:212.0/255.0 blue:188.0/255.0 alpha:1];
    self.paymentAmountLaebl.textAlignment = NSTextAlignmentCenter;
    [self.qrDoneView addSubview:self.paymentAmountLaebl];
    [self.paymentAmountLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrDoneView.doneLabel.mas_bottom).equalTo(@(10));
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.height.mas_equalTo(14);
    }];
    
    if (self.URLType == 5) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action: @selector(toBackToRoot)];
    }
    
    [self getQRCodeReqData];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    if (self.didDoneBlock) {
        self.didDoneBlock();
    }
    [self navigationBarNotAlphaWithBlackTint];
    [self.timer invalidate];
    self.timer = nil;
    self.isDone = YES;
}
- (void)toBackToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getQRCodeReqData {
    
    [SYProgressHUD show];
    /// 链接类型 0 - 不做操作（登录） 1 - 跳订单详情（支付预付款） 2 - 跳结算页 3 - 跳充值预付款    4 - 跳订单详情(跟中间支付) 5-订单合并结算

    GetQRCodeReq *req = [GetQRCodeReq new];
    req.URLType = self.URLType;
    req.orderId = self.orderId;
    req.purpose = @"PayQR";
    req.format = @"png";
    
    [YJYNetworkManager requestWithUrlString:GetQRCode message:req controller:self command:APP_COMMAND_GetQrcode success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp = [GetQRCodeRsp parseFromData:response error:nil];
        [self setupRsp];
        
        self.shouldStop = NO;
        [self checkPayState];
        
    } failure:^(NSError *error) {
        
        [self setupRsp];

    }];
    
}

- (void)setupRsp {
    
    // qr
    BOOL isQRURL = (self.rsp.qrcodeUri.length > 0);
    
    if (isQRURL) {

        [self.scanImageView xh_setImageWithURL:[NSURL URLWithString:self.rsp.qrcodeUri] placeholderImage:nil];
        self.time = self.rsp.time/1000;
        NSInteger HH = self.time/60/60;
        NSInteger mm = self.time/60%60;
        NSInteger ss = self.time%60;
        NSString *time = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)HH,(long)mm,(long)ss];
        
        self.scanResultLabel.text = [NSString stringWithFormat:@"二维码%@后失效，失效请重新生成",time];
        self.scanResultLabel.textColor = APPREDCOLOR;
        [self countDown];
    }else {
        
        self.scanImageView.image = [UIImage imageNamed:@"pay_qr_failure"];
        
        self.scanResultLabel.text = @"暂无可用付款码，请在正常网络状态下刷新重试";
        self.scanResultLabel.textColor = APPDarkGrayCOLOR;
    }
    
    self.scanTipLabel.hidden = !isQRURL;
    [self.actionButton setTitle:isQRURL ? @"刷新" : @"重新生成" forState:0];
}

- (void)countDown {
    
    //self.rsp.time/1000
//    NSInteger second = self.rsp.time/1000;
    
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];

}

- (void)handleTimer {
    
    self.time--;
    NSInteger HH = self.time/60/60;
    NSInteger mm = self.time/60%60;
    NSInteger ss = self.time%60;
    NSString *time = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)HH,(long)mm,(long)ss];
    
    [self.scanResultLabel setText:[NSString stringWithFormat:@"二维码%@后失效，失效请重新生成",time]];
    
    if (self.time == 0) {
        self.rsp.qrcodeUri = @"";
        self.shouldStop = YES;
        [self setupRsp];
        [self.timer invalidate];
    }
    
}


# pragma mark - 轮询
- (void)checkPayState {
    
    if (self.isDone || self.shouldStop) {
        return;
    }
    
    ScanLoginReq *req = [ScanLoginReq new];
    req.accessToken = self.rsp.accessToken;
    req.ops = 2;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCheckPayState message:req controller:self command:APP_COMMAND_SaasappcheckPayState success:^(id response) {
        
        NSString * str  =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        if (str == nil || [str isEqualToString:@""]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkPayState];
            });
            
            return;
        }
        
        self.paymentAmountLaebl.text = [NSString stringWithFormat:@"支付成功，已成功收款%@元",str];
        
        [self setupDone];
        
    } failure:^(NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkPayState];
        });
        
    }isHiddenError:YES];
}

- (void)setupDone {
    
    self.smallQRIcon.hidden = YES;
    self.qrtipLabel.hidden = YES;
    self.scanTipLabel.hidden = YES;
    self.scanImageView.hidden = YES;
    
    self.scanResultLabel.hidden = YES;
    self.actionButton.hidden = YES;
    
    //done
    self.qrDoneView.hidden = NO;
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.isDone = YES;
}


#pragma mark - Action


- (IBAction)genRefreshAction:(id)sender {
    
    [self getQRCodeReqData];
    
}

@end
