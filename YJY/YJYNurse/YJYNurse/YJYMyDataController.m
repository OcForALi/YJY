//
//  YJYMyDataController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/7.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYMyDataController.h"
#import "YJYSettingViewController.h"
#import "YJYQRView.h"

@interface YJYMyDataController ()

@property (strong, nonatomic) GetHgInfoRsp *rsp;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *mynumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobBeginLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *myphoneLabel;


@end

@implementation YJYMyDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];
    
    if (![YJYLoginManager isLogin]) {
        
        __weak YJYLoginController *vc = [YJYLoginController instanceWithStoryBoard];
        vc.didSuccessLoginComplete = ^(id response) {
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        YJYNavigationController *navi = [[YJYNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
        return;
    }
    
    [self loadNetworkData];
    
}
- (void)loadNetworkData {
    
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgInfo message:nil controller:nil command:APP_COMMAND_SaasappgetHgInfo success:^(id response) {
        
        
        self.rsp = [GetHgInfoRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)reloadRsp {
    
    
    self.nameLabel.text = self.rsp.fullName.length > 0 ? self.rsp.fullName :@"无";

//    self.superNameLabel.text = self.rsp.superiorName;
//    NSArray *lans = @[@"普通话",@"粤语",@"客家",@"客家话"];
//    NSMutableArray *lansM = [NSMutableArray array];
//    [self.rsp.languageArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
//        
//        [lansM addObject:lans[value]];
//        
//    }];
//    
//    self.lansLabel.text = [lansM componentsJoinedByString:@","];
//    self.experienceLabel.text = [NSString stringWithFormat:@"%@天",@(self.rsp.exp)];
    self.jobBeginLabel.text = self.rsp.joinTimeStr;

    //
    self.mynumberLabel.text = self.rsp.hgno.length > 0 ? self.rsp.hgno :@"无";
    self.jobLabel.text = self.rsp.serviceTypeStr.length > 0 ? self.rsp.serviceTypeStr :@"无";
    self.jobBeginLabel.text = self.rsp.careerStartTime.length > 0 ? self.rsp.careerStartTime :@"无";

    //
    self.bankNumberLabel.text =  self.rsp.bankNo.length > 0 ? self.rsp.bankNo :@"无";
    self.bankLabel.text =  self.rsp.bankName.length > 0 ? self.rsp.bankName :@"无";
    self.contactLabel.text = self.rsp.emergencyContact.length > 0 ? self.rsp.emergencyContact :@"无";
    self.myphoneLabel.text = self.rsp.emergencyContactPhone.length > 0 ? self.rsp.emergencyContactPhone :@"无";
    
}

- (IBAction)toSetting:(id)sender {
    
    YJYSettingViewController *vc = [YJYSettingViewController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkScanAction:(id)sender {
    
    YJYQRView *qrView = [YJYQRView instancetypeWithXIB];
    qrView.imgUrl = self.rsp.mpQrcode;
    qrView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [qrView showInView:nil];
}



@end
