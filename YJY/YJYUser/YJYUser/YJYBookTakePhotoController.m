//
//  YJYBookTakePhotoController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBookTakePhotoController.h"
#import "YJYBookHospitalController.h"

typedef void(^CompleteBlock)(NSString *imageId);

@interface YJYBookTakePhotoController ()

@end

@implementation YJYBookTakePhotoController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBookTakePhotoController *)[UIStoryboard storyboardWithName:@"YJYBookHospital" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];
    
    
    
}

- (void)takePhotoActionWithCompleteBlock:(CompleteBlock)completeBlock {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                
                [SYProgressHUD showLoadingWindowText:@"正在上传"];
                
                [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
                    
                    if (completeBlock) {
                        completeBlock(response[@"imageId"]);
                    }

                    
                } failure:^(NSError *error) {
                    
                    [SYProgressHUD showFailureText:@"上传失败"];
                    
                    
                }];
                
            } cancel:^{
                
                [SYProgressHUD hide];
                
                
            }];
        }
        
    }];
    
}

- (IBAction)toTakePhotoAction:(id)sender {
    
    [self takePhotoActionWithCompleteBlock:^(NSString *imageId) {
        
        [SYProgressHUD showLoadingWindowText:@"正在识别"];

        OrgNORecognizeReq *req = [OrgNORecognizeReq new];
        req.imgId = imageId;
        
        [YJYNetworkManager requestWithUrlString:OrgNORecognize message:req controller:self command:APP_COMMAND_OrgNorecognize success:^(id response) {
            
            OrgNORecognizeRsp *rsp = [OrgNORecognizeRsp parseFromData:response error:nil];
            HospitalBra *hospitalBra = rsp.hospitalBra;
            
            [SYProgressHUD hide];
            
            if (hospitalBra.name.length == 0 || hospitalBra.orgName.length == 0) {
                [UIAlertController showAlertInViewController:self withTitle:@"图片识别失败，是否手工输入？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新拍照" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        [self toTakePhotoAction:nil];
                    }
                    
                    
                }];
                return;
            }
            
            YJYBookHospitalController *vc = [YJYBookHospitalController instanceWithStoryBoard];
            vc.hospitalBra = hospitalBra;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
  
}

- (IBAction)toSkipTakePhotoAction:(id)sender {
    
    YJYBookHospitalController *vc = [YJYBookHospitalController instanceWithStoryBoard];
    vc.currentOrg = self.currentOrg;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
