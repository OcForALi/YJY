//
//  YJYScanController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/2.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYScanController.h"
#import <LBXScan/LBXScanViewStyle.h>

@interface YJYScanController ()
@property (strong, nonatomic) LBXScanViewStyle *style;
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];
    //[UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(backAction)];


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
- (void)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];

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
