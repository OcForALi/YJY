//
//  YJYAddressPositionController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/7.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAddressPositionController.h"
#import "YJYAddressSearchController.h"

#pragma mark - YJYAddressPositionController

@interface YJYAddressPositionController ()





@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *addressSearchTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;



#define kTopDefaultH 0
#define kTopShowH -105

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation YJYAddressPositionController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYAddressPositionController *)[UIStoryboard storyboardWithName:@"YJYAddress" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.detailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailTextField.borderStyle = UITextBorderStyleNone;

    [self reloadData:self.address];
    if (self.address.addrDetail.length > 0) {
        self.detailTextField.text = self.address.addrDetail;
    }
    

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
    [self.nameTextField becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}


- (void)reloadData:(UserAddressVO *)address {
    
    self.address = address;
    if (address) {
        self.addressSearchTextField.text = address.building;
        if (address.contacts.length > 0) {
            self.nameTextField.text = address.contacts;
        }
        if (address.phone.length > 0) {
            self.phoneField.text = address.phone;

        }
        
       
       
    }
   

}



#pragma mark - Action

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)comfireAction:(UIButton *)sender {
    
    [SYProgressHUD show];
    
    if(!(self.phoneField.text && self.nameTextField.text && self.addressSearchTextField.text && self.detailTextField.text)) {
        [SYProgressHUD showToCenterText:@"信息不全"];
        return;
    }
    
    UserAddressReq *userAddressReq = [UserAddressReq new];
    userAddressReq.addrId = self.address.addrId;
    userAddressReq.lng = self.address.lng;
    userAddressReq.lat = self.address.lat;
    userAddressReq.gpsType = 2;
    userAddressReq.adCode = self.address.adCode;
    
    userAddressReq.addrDetail =  self.detailTextField.text;
    userAddressReq.street = self.address.district;
    userAddressReq.building = self.address.building;
    userAddressReq.contacts = self.nameTextField.text;
    userAddressReq.phone = self.phoneField.text;
    
    NSString *urlString = (self.isEdit) ? APPUpdateUserAddress : APPAddUserAddress;
    APP_COMMAND command = (self.isEdit) ? APP_COMMAND_AppupdateUserAddress : APP_COMMAND_AppaddUserAddress;
    
    
    [YJYNetworkManager requestWithUrlString:urlString message:userAddressReq controller:self command:command success:^(id response) {
        
        
        CreateAddressRsp *rsp = [CreateAddressRsp parseFromData:response error:nil];
        
        self.address.addressInfo = [NSString stringWithFormat:@"%@%@%@%@%@",self.address.province,self.address.city,self.address.district,self.address.building,self.detailTextField.text];
        self.address.contacts = self.nameTextField.text;
        self.address.phone = self.phoneField.text;
        
        if (!self.isEdit) {
            self.address.addrId = rsp.addrId;
        }


        if (self.addressDidSavedBlock) {
            self.addressDidSavedBlock(self.address);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        [SYProgressHUD showSuccessText: (self.isEdit) ? @"修改成功" : @"添加成功"];

        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}
- (IBAction)nameDidChange:(id)sender {
    
    if ([self.nameTextField isFirstResponder] && self.nameTextField.text.length > 6) {
        self.nameTextField.text = [self.nameTextField.text substringToIndex:6];
        return;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"YJYAddressSearchController"]) {
        YJYAddressSearchController *vc = (YJYAddressSearchController *)segue.destinationViewController;
        vc.addressDidSearchBlock = ^(UserAddressVO *address) {
            address.addrId = self.address.addrId;
            [self reloadData:address];
        };
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
@end
