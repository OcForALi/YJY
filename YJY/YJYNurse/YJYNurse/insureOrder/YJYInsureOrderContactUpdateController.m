//
//  YJYInsureOrderRelationController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderContactUpdateController.h"
#import "YJYAddressSearchController.h"

typedef void(^YJYInsureOrderContactUpdateDidDoneBlock)();

@interface YJYInsureOrderContactUpdateContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *yourPositionLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressLabel;

@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (copy, nonatomic) YJYInsureOrderContactUpdateDidDoneBlock didDoneBlock;

@property (strong, nonatomic) UserAddressVO *address;
@end

@implementation YJYInsureOrderContactUpdateContentController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.phoneLabel addTarget:self action:@selector(toGetHGIdcardByPhone:) forControlEvents:UIControlEventEditingDidEnd];

}

- (IBAction)done:(id)sender {
    
    [SYProgressHUD show];
    UpdateInsureOrderAddrReq *req = [UpdateInsureOrderAddrReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.phone = self.phoneLabel.text;
    req.addrDetail = self.detailAddressLabel.text;
    
    req.province = self.address.province;
    req.city = self.address.city;
    req.district = self.address.district;
    req.building = self.address.building;
    req.adCode = self.address.adCode;
    req.contacts = self.nameLabel.text;

    
    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateInsureOrderAddr message:req controller:self command:APP_COMMAND_SaasappupdateInsureOrderAddr success:^(id response) {
        
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }
        [SYProgressHUD showSuccessText:@"修改成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });

    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)toChangeAddress:(id)sender {
    
    YJYAddressSearchController *vc = [YJYAddressSearchController instanceWithStoryBoard];
    vc.addressDidSearchBlock = ^(UserAddressVO *address) {
        
        self.address = address;
        self.yourPositionLabel.text = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.district];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toGetHGIdcardByPhone:(UITextField *)textField {
    
    if (self.phoneLabel.text.length == 11) {
        
        GetHGIdcardByPhoneReq *req = [GetHGIdcardByPhoneReq new];
        req.phone = self.phoneLabel.text;
        req.isSaasapp = YES;
        [YJYNetworkManager requestWithUrlString:GetHGIdcardByPhone message:req controller:self command:APP_COMMAND_GetHgidcardByPhone success:^(id response) {
            
            
            GetHGIdcardByPhoneRsp *rsp = [GetHGIdcardByPhoneRsp parseFromData:response error:nil];
            
            self.nameLabel.text = rsp.hgName;
            
            
        } failure:^(NSError *error) {
            
        }];
    }
}

@end

@interface YJYInsureOrderContactUpdateController ()

@property (strong, nonatomic) YJYInsureOrderContactUpdateContentController *contentVC;


@end

@implementation YJYInsureOrderContactUpdateController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureOrderContactUpdateController *)[UIStoryboard storyboardWithName:@"YJYInsureOrderUpdate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureOrderContactUpdateContentController"]) {
        
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYInsureOrderContactUpdateContentController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        
        
        self.contentVC.didDoneBlock = ^{
           
            weakSelf.didDoneBlock();
            
        };
        
        
        
    }
}

- (IBAction)done:(id)sender {
    [self.contentVC done:nil];
}

@end

