//
//  YJYSignatureController.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/25.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYSignatureController.h"
#import "YJYSignatureView.h"


@interface YJYSignatureController ()

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet YJYSignatureView *signatureView;
@property (strong, nonatomic) NSString *imageID;


@end

@implementation YJYSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];

    //极光 Push + 融云 IM
    
    _signatureView.strokeColor = [UIColor blackColor];
    _signatureView.strokeWidth = 4.0f;
    
}
- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)comfireAction:(id)sender {

    [SYProgressHUD show];
    UIImage *image = self.signatureView.imageRepresentation;
    if ([self.signatureView bezierPathRepresentation] == nil) {
        [SYProgressHUD showInfoText:@"请签名"];
        return;
    }
    
    [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
        
        NSString *imageID = response[@"imageId"];
        NSString *imageURL = response[@"imgUrl"];

        self.imageID = imageID;
       
        
        if (self.isInsure || self.isBackVC) {
            if (self.didReturnImage) {
                self.didReturnImage(imageID,imageURL);
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }else{

            [self toUpdateOrderSignPic];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"上传失败"];
        
        
    } compress:1];
    [SYProgressHUD hide];
    
}

- (void)toUpdateOrderSignPic {
    
    [SYProgressHUD show];
    UpdateOrderSignPicReq *req =  [UpdateOrderSignPicReq new];
    req.orderId = self.orderId;
    req.signPic = self.imageID;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateOrderSignPic message:req controller:self command:APP_COMMAND_SaasappupdateOrderSignPic success:^(id response) {
        
        UpdateOrderSignPicRsp *rsp = [UpdateOrderSignPicRsp parseFromData:response error:nil];
        [self backAction:nil];

        if (self.didReturnImage) {
            self.didReturnImage([NSString stringWithFormat:@"%@",@(rsp.signId)], @"");
        }else if (self.didDone) {
            self.didDone();
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)toStartUpAction:(id)sender {
    
    SaveOrUpdateOrderReq *req = [SaveOrUpdateOrderReq new];
    req.orderId = self.orderId;
    req.operationType = 1;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateOrder message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateOrder success:^(id response) {
        
        
       
        
        [self backAction:nil];
        
        if (self.didDone) {
            self.didDone();
        }
        [SYProgressHUD hide];

        
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)clearAction:(id)sender {
    
    [self.signatureView clearDrawing];
}
- (IBAction)undoAction:(id)sender {
    
    [self.signatureView undoDrawing:nil];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate{
    return YES;
}
@end
