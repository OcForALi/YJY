//
//  YJYMineModifyController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYMineModifyController.h"
#import "IQActionSheetPickerView.h"



@interface YJYMineModifyController ()<IQActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (copy, nonatomic) NSString *imageID;



@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *brithdayLabel;



@end

@implementation YJYMineModifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料修改";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(doneAction:)];
    [self reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.avatarButton setImage:[UIImage imageNamed:@"mine_profile_place"] forState:0];

    [self reloadNetworkingData];
}

- (void)reloadNetworkingData {
    
    [YJYNetworkManager requestWithUrlString:APPGetUserInfo message:nil controller:nil command:APP_COMMAND_AppgetUserInfo success:^(id response) {
        
        GetUserInfoRsp *rsp = [GetUserInfoRsp parseFromData:response error:nil];
        self.user = rsp.userVo;
        [self reloadData];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)reloadData {

    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameTextField.text = self.user.name;
    [self.avatarButton setImageForState:0 withURL:[NSURL URLWithString:self.user.headImgURL]];
    
    if (self.user.sex > 0) {
        self.sexLabel.text = (self.user.sex == 1) ? @"男":@"女";

    }
    if (self.user.birthday.length > 0) {
        self.brithdayLabel.text = self.user.birthday;

    }else {
        self.brithdayLabel.text = @"1990-01-01";
    }
    
}

#pragma mark - Action
- (IBAction)nameDidChange:(id)sender {
    
    if ([self.nameTextField isFirstResponder] && self.nameTextField.text.length > 4) {
        self.nameTextField.text = [self.nameTextField.text substringToIndex:4];
        return;
    }
}

- (IBAction)changeAvatorAction:(id)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
           
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                
                [SYProgressHUD show];
                
                [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
                    
                    self.imageID = response[@"imageId"];
                    [self.avatarButton setImage:image forState:0];
                    self.user.headImgURL = response[@"imgUrl"];
                    
                    [SYProgressHUD showSuccessText:@"上传成功"];
                    
                    
                } failure:^(NSError *error) {

                    [SYProgressHUD showFailureText:@"上传失败"];

                    
                }];
                
            } cancel:^{
                
                [SYProgressHUD hide];
                
                
            }];
        }
        
    }];
    
}


- (IBAction)sexAction:(UIButton *)sender {
    
    
   [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"男",@"女"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
       
       if (buttonIndex != 0) {
           self.sexLabel.text = (buttonIndex == 2) ? @"男" :@"女";
           self.user.sex = (uint32_t)buttonIndex;
       }
   }];
    
}
- (IBAction)birthdayAction:(id)sender {
    
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"生日选择" delegate:self];
   // picker.minimumDate = [NSDate dateString:@"1870-01-01" Format:YYYY_MM_DD];
    //picker.maximumDate = [NSDate dateString:@"2017-12-31" Format:YYYY_MM_DD];
    picker.marginYear = 150;
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
    [picker setDate:[NSDate dateString:self.user.birthday Format:YYYY_MM_DD]];
    [picker show];
    
}

- (IBAction)doneAction:(id)sender {

    
    
    if (!self.nameTextField.text && !self.imageID) {
        [SYProgressHUD showFailureText:@"没有需要更新的数据"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UpdateUserInfoReq *req = [UpdateUserInfoReq new];
    req.name = self.nameTextField.text;
    req.headImg = self.imageID;
    req.sex = self.user.sex;
    req.birthday = self.brithdayLabel.text;
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:APPUpdateUserInfo message:req controller:self command:APP_COMMAND_AppupdateUserInfo success:^(id response) {
        
         self.user.name = self.nameTextField.text;
        
        if (self.mineModifyDidDoneBlock) {
            self.mineModifyDidDoneBlock(self.user);
        }
        [SYProgressHUD hide];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
       

    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
#pragma mark - IQSheetDelegate

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date {
    
    NSString *dataString = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
    self.brithdayLabel.text = dataString;
    self.user.birthday = dataString;

}
@end
