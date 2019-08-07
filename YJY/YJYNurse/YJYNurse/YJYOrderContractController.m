//
//  YJYOrderContractController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/10.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderContractController.h"
#import "YJYSignatureController.h"
@interface YJYOrderContractController ()


@end

@implementation YJYOrderContractController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderContractController *)[UIStoryboard storyboardWithName:@"YJYOrderContract" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"用户知情书";
    self.webView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 60);
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        self.isDenySkip = self.isReSign ? NO: YES;
    }

    if (self.isDenySkip || self.isReSign) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:nil highImage:nil target:nil action:nil];
    }else {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过签名" style:UIBarButtonItemStylePlain target:self action:@selector(toSkip:)];
        rightBarButtonItem.tintColor = APPHEXCOLOR;
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    }
    
    
    if (![self isPushController]) {
    
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)setNewOrAltered:(NSInteger)newOrAltered{
    _newOrAltered = newOrAltered;
}

- (IBAction)signatureAction:(id)sender {
    
    YJYSignatureController *vc = [YJYSignatureController new];
    vc.orderId = self.orderId;
    vc.isSetup = self.isSetup;
//    vc.isBackVC = YES;
    vc.didDone = ^{
        
      
        
        [SYProgressHUD showSuccessText:@"签名成功"];
        [self toReload];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.newOrAltered == 0) {
                [self dismiss];
            }

        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didDoneBlock) {
                self.didDoneBlock();
            }
        });
       

    };
    vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
 
        [SYProgressHUD showSuccessText:@"签名成功"];
        if (self.didReturnImage) {
            self.didReturnImage(imageID, imageURL);
        }
        [self toReload];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.newOrAltered == 0) {
                [self dismiss];
            }
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didDoneBlock) {
                self.didDoneBlock();
            }
        });
    };
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)toSkip:(id)sender {
    
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.orderId;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPNeglectOrderSignPic message:req controller:self command:APP_COMMAND_SaasappneglectOrderSignPic success:^(id response) {
       
        if (self.newOrAltered == 0) {
            [self dismiss];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didSkipBlock) {
                self.didSkipBlock();
            }
        });

    } failure:^(NSError *error) {
        
    }];
}

- (void)dismiss {
    
    
    
    if (![self isPushController]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];


    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}




@end
