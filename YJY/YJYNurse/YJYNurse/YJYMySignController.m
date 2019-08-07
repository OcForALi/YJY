//
//  YJYMySignController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/6/25.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYMySignController.h"
#import "YJYSignatureController.h"
@interface YJYMySignController ()
@property (weak, nonatomic) IBOutlet UISwitch *signSwitch;
@property (weak, nonatomic) IBOutlet UIButton *toSignButton;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property (strong, nonatomic) GetHgSignRsp *rsp;
@property (weak, nonatomic) IBOutlet UILabel *noSignTipLabel;

@end

@implementation YJYMySignController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSign];
    
}
- (void)loadSign {
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgSign message:nil controller:self command:APP_COMMAND_SaasappgetHgSign success:^(id response) {
        
        self.rsp = [GetHgSignRsp parseFromData:response error:nil];
        HGSign *signInfo = self.rsp.signInfo;
        [self.signImageView xh_setImageWithURL:[NSURL URLWithString:self.rsp.signPicURL]];
        self.signSwitch.on = self.rsp.signInfo.status == 2;
        
        
        self.signImageView.hidden = signInfo.signPic.length == 0;
        self.noSignTipLabel.hidden = !self.signImageView.hidden;
        [self.toSignButton setTitle:signInfo.signPic.length == 0 ? @"去签名" : @"重新签名" forState:0];
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)toSign:(UIButton *)sender {
    
    
    YJYSignatureController *vc = [[YJYSignatureController alloc]init];
    vc.isBackVC = YES;
    vc.didDone = ^{
        
    };
    vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
        
        [SYProgressHUD show];
        
        SaveOrUpdateHgSignReq *req = [SaveOrUpdateHgSignReq new];
        req.hgSignId = self.rsp.signInfo.id_p;
        req.signPic = imageURL;
        [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateHgSign message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateHgSign success:^(id response) {
            [SYProgressHUD showSuccessText:@"签名成功"];
            
            [self.signImageView xh_setImageWithURL:[NSURL URLWithString:imageURL]];
            self.signImageView.hidden = NO;
            self.noSignTipLabel.hidden = !self.signImageView.hidden;
            [self.toSignButton setTitle:@"重新签名" forState:0];
            
            [self loadSign];
            
            
        } failure:^(NSError *error) {
            
        }];
        
    };
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)toClickSwitch:(id)sender {

    if (self.rsp.signStatus == 1) {
        
        
        NSString *title = @"您还没有设置签名，是否现在去签名？";
        
        [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self toSign:nil];
            }
            
        }];
        
    }else {
        [self toSetupSign:self.signSwitch];
    }
}

- (IBAction)toSetupSign:(UISwitch *)sender {
    
    sender.on = !sender.on;
    
    [SYProgressHUD show];
    SaveOrUpdateHgSignReq *req = [SaveOrUpdateHgSignReq new];
    req.status = sender.on ? 2 : 1;
    req.hgSignId = self.rsp.signInfo.id_p;
    
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateHgSign message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateHgSign success:^(id response) {
        
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        
    }];

   
    
   
}

@end
