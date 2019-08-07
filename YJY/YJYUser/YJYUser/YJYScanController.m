//
//  YJYScanController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYScanController.h"

@interface YJYScanController ()

@property (strong, nonatomic) UILabel *upTipLabel;
@property (strong, nonatomic) UILabel *downTipLabel;

@property (strong, nonatomic) UIButton *rebutton;
@end

@implementation YJYScanController


+ (instancetype)presentWithInVC:(UIViewController *)vc {
    
    
    YJYScanController *avc = [YJYScanController new];
    
    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:avc];
    
    [vc presentViewController:nav animated:YES completion:nil];
    
    return avc;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(backAction)];


    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    self.style = style;
    
    

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (![self.view.subviews containsObject:self.rebutton]) {
        self.rebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rebutton.frame = CGRectMake(0, 60, self.view.frame.size.width, 20);
        self.rebutton.center = CGPointMake(self.rebutton.center.x, self.view.center.y + 100);
        [self.rebutton setTitle:@"无法扫描请点此处 >" forState:0];
        [self.rebutton setTitleColor:APPHEXCOLOR forState:0];
        [self.rebutton addTarget:self action:@selector(rePictureAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.rebutton];
    }
    
    if (![self.view.subviews containsObject:self.upTipLabel]) {
        self.upTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 20)];
        self.upTipLabel.text = @"请扫描入院手环二维码，快速下单";
        self.upTipLabel.textColor = [UIColor whiteColor];
        self.upTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.upTipLabel];
    }
    
    if (![self.view.subviews containsObject:self.downTipLabel]) {
        self.downTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 20)];
        self.downTipLabel.center = CGPointMake(self.downTipLabel.center.x, self.view.center.y + 60);
        self.downTipLabel.text = @"将住院手环上的二维码放入框内扫描";
        self.downTipLabel.textColor = [UIColor whiteColor];
        self.downTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.downTipLabel];
    }
    
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    
}
- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (void)rePictureAction:(id)sender {
    if (self.didReplayBlock) {
        self.didReplayBlock();
        [self backAction];

    }
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [SYProgressHUD showFailureText:@"扫码失败"];
        return;
    }
 
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    
    if (strResult) {
        
        if (self.didResultBlock) {
            self.didResultBlock(strResult);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
    
        [SYProgressHUD showFailureText:@"扫码失败"];

    }
    
    
    
}

@end
