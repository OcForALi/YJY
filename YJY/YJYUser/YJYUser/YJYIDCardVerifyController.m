//
//  YJYIDCardVerifyController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/7.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYIDCardVerifyController.h"

@interface YJYIDCardVerifyController ()

@property (weak, nonatomic) IBOutlet UIImageView *idCardImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@end

@implementation YJYIDCardVerifyController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYIDCardVerifyController *)[UIStoryboard storyboardWithName:@"YJYIDCardVerify" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    self.isNaviError = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)toUploadAction:(id)sender {
    
    [self.view endEditing:YES];
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@[@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 1) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                [SYProgressHUD showLoadingWindowText:@"正在上传"];
                
                [YJYNetworkManager uploadImageToServerWithImage:image type:kIdcard success:^(id response) {
                    
                    
                    NSString *imageID = response[@"imageId"];
                    
                    GetIDCardNoReq *req = [GetIDCardNoReq new];
                    req.imgId = imageID;
                    
                    [SYProgressHUD showLoadingWindowText:@"正在识别"];
                    
                    
                    [YJYNetworkManager requestWithUrlString:IDCardRecognize message:req controller:self command:APP_COMMAND_IdcardRecognize success:^(id response) {
                        
                        GetIDCardNoRsp *rsp = [GetIDCardNoRsp parseFromData:response error:nil];
                        [self.nameTextField setText:rsp.idInfo.fullName];
                        [self.idCardTextField setText:rsp.idInfo.idcard];
                        
                
                        
                        
                        self.idCardImgView.contentMode = UIViewContentModeScaleAspectFill;
                        self.idCardImgView.image = image;
                        
                        
                        
                        [SYProgressHUD hide];
                        [SYProgressHUD showToCenterText:@"识别成功"];
                        
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    
                } failure:^(NSError *error) {
                    
                }];
                
            } cancel:^{
                
            }];
        }
        
    }];
    
}
- (IBAction)done:(id)sender {
    
    [SYProgressHUD show];
    
    if (self.idCardTextField.text.length != 18 || !self.idCardTextField || !self.nameTextField.text) {
        [SYProgressHUD showFailureText:@"请填写完整资料"];
        return;
    }
    
    UpdateUserInfoReq *req = [UpdateUserInfoReq new];
    req.idcard = self.idCardTextField.text;
    req.realName = self.nameTextField.text;
    
    [YJYNetworkManager requestWithUrlString:APPUpdateUserInfo message:req controller:self command:APP_COMMAND_AppupdateUserInfo success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"认证成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];

        });
        
    } failure:^(NSError *error) {
        
    }];
}

@end
