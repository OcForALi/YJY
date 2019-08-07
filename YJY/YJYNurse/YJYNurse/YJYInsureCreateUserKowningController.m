//
//  YJYInsureCreateUserKowningController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/4/27.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureCreateUserKowningController.h"
#import "YJYInsureDetailController.h"
#import "YJYSignatureController.h"

@interface YJYInsureCreateUserKowningController ()

@end

@implementation YJYInsureCreateUserKowningController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureCreateUserKowningController *)[UIStoryboard storyboardWithName:@"YJYInsureCreateUserKowning" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureCreateUserKowningControllerContent"]) {
        YJYWebController *vc = segue.destinationViewController;
        vc.urlString = kInsureUserKnowing;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (IBAction)done:(id)sender {

    YJYSignatureController *vc = [YJYSignatureController new];
    vc.isInsure = YES;
    vc.didReturnImage = ^(NSString *imageID,NSString *imageURL) {
        
        [SYProgressHUD show];
        self.req.userSignPic = imageID;
        [YJYNetworkManager requestWithUrlString:SAASAPPAddInsure  message:self.req controller:self command:APP_COMMAND_SaasappaddInsure success:^(id response) {
            
            
            AddInsureRsp *rsp = [AddInsureRsp parseFromData:response error:nil];
            [SYProgressHUD hide];
            
            YJYInsureDetailController *vc = [YJYInsureDetailController instanceWithStoryBoard];
            vc.insureNo = rsp.insureNo;
            vc.hasToBackRoot = YES;
            vc.didDismissBlock = ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    };
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}

@end
