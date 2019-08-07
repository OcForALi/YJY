//
//  YJYOrderHospitalNurseController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/21.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderHospitalNurseController.h"
#import "YJYPersonEditController.h"
#import "YJYKinsfolksController.h"
#import "YJYPackageCell.h"
#import "YJYAddressesController.h"
#import "YJYAddressPositionController.h"
#import "YJYOrderDetailController.h"
#import "YJYNearHospitalController.h"
#import "YJYOrderPackageDetailController.h"

#import "NSDate+JJ.h"
#import "YJYTimePicker.h"
#import "YJYOrderHospitalPackageCell.h"


@interface YJYOrderBookContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet YJYOrderHospitalPackageCell *packageCell;


//address
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressTipButton;


//data
@property (strong, nonatomic) GetPriceReq *req;
@property (strong, nonatomic) CreateOrderReq *createOrderReq;

@property (strong, nonatomic) KinsfolkVO *currentKinsfolk;
@property (strong, nonatomic) OrderTimeData *currentDate;
@property (strong, nonatomic) UserAddressVO *currentAddress;
@property (strong, nonatomic) CompanyPriceVO *currentCompanyPrice;

//callback
@property (copy, nonatomic) YJYOrderHospitalPackageCellDidSelectBlock didSelectBlock;


@end


@implementation YJYOrderBookContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.phoneTextField.text = [KeychainManager getValueWithKey:kUserphone];
    self.createOrderReq  = [CreateOrderReq new];
  
    //network
    [self loadNetworkKinsfolk];
    [self loadNetworkAddress];
    
    
    //cell
    
    //priceCell
    
    self.packageCell.req = self.req;
    __weak typeof(self) weakSelf = self;
    
    self.packageCell.didSelectBlock = ^(CompanyPriceVO *companyPrice) {
        weakSelf.currentCompanyPrice = companyPrice;
        weakSelf.didSelectBlock(companyPrice);
        
    };
    
    self.packageCell.packageCellDidSelectBlock = ^(Price *price) {
       
        YJYOrderPackageDetailController *vc = [YJYOrderPackageDetailController instanceWithStoryBoard];
        vc.price = price;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
   
    self.packageCell.didLoadedBlock = ^{
        
        [weakSelf reloadAllData];
    };
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0) {
       
        
       return self.currentAddress ? 110 : 60;

    }else if (indexPath.row == 4) {
        
        
        return [self.packageCell cellHeight];
        
    }
    
    return 50;
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

#pragma mark - Action



- (IBAction)patientAction:(id)sender {
    
    [SYProgressHUD show];

    [YJYNetworkManager requestWithUrlString:APPListKinsfolk message:nil controller:self command:APP_COMMAND_ApplistKinsfolk success:^(id response) {
        
        
        [SYProgressHUD hide];
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        if (rsp.kinsfolkListArray.count > 0) {
            
            YJYKinsfolksController *vc = [YJYKinsfolksController instanceWithStoryBoard];
            vc.kinsfolksDidSelectBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
            vc.firstAdd = YES;
            vc.didDoneBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            [self.navigationController pushViewController:vc animated:YES];

            
        }

        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
    
    
}


- (IBAction)addressSelectAction:(id)sender {
    
    [SYProgressHUD show];

    [YJYNetworkManager requestWithUrlString:APPListUserAddress message:nil controller:self command:APP_COMMAND_ApplistUserAddress success:^(id response) {
        
        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
        if (rsp.userAddressVoArray.count > 0) {
            
            YJYAddressesController *vc = [YJYAddressesController instanceWithStoryBoard];
            vc.didSelectBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
            };
            [self.navigationController pushViewController:vc animated:YES];

        }else {
            
        
            YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
            vc.addressDidSavedBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
            };
            [self.navigationController pushViewController:vc animated:YES];

        }
        [SYProgressHUD hide];

        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];

    }];
    
   
    
}
- (IBAction)timeAction:(id)sender {
   
    
    YJYTimePicker *picker = [YJYTimePicker instancetypeWithXIB];
    picker.orderType = 2;
    [picker loadNetwork];
    picker.timePickerDidSelectBlock = ^(TimeData *currentTimeData, OrderTimeData *orderTimeData) {
        
        NSString *serviceStartTime = orderTimeData.serviceStartTime;
        NSString *serviceEndTime = orderTimeData.serviceEndTime;
        
        
        NSDate *startDate = [NSDate dateString:serviceStartTime Format:YYYY_MM_DD_HH_MM_SS];
        NSDate *endDate = [NSDate dateString:serviceEndTime Format:YYYY_MM_DD_HH_MM_SS];
        
        NSString *startDataString = [NSDate getRealDateTime:startDate withFormat:YYYY_MM_DD_HH_MM];
        
        NSString *endDataString = [NSDate getRealDateTime:endDate withFormat:HH_MM];
        
        NSString *fullTime = [NSString stringWithFormat:@"%@-%@",startDataString,endDataString];
        
        self.timeLabel.text = fullTime;
        
        self.currentDate = orderTimeData;
        
        [self setupTime];
        
        
    };
    [picker showInView:nil];
    
}


#pragma mark - Network

- (void)loadNetworkKinsfolk {

    [YJYNetworkManager requestWithUrlString:APPListKinsfolk message:nil controller:self command:APP_COMMAND_ApplistKinsfolk success:^(id response) {
        
        
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        self.currentKinsfolk = rsp.kinsfolkListArray.firstObject;
        
        [self setupKindFolk:self.currentKinsfolk];

    
    } failure:^(NSError *error) {
        
    }];

}

- (void)loadNetworkAddress {
   
    [YJYNetworkManager requestWithUrlString:APPListUserAddress message:nil controller:self command:APP_COMMAND_ApplistUserAddress success:^(id response) {
        
        
        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
        UserAddressVO *currentAddress = rsp.userAddressVoArray.firstObject;
        [self setupAddress:currentAddress];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Data

- (void)setupAddress:(UserAddressVO *)address {

    if (address.addressInfo.length == 0) {
        return;
    }
    self.currentAddress = address;
    
    self.addressTipButton.hidden = (address.addressInfo.length > 0);
    self.nameLabel.text = address.contacts;
    self.phoneLabel.text = address.phone;
    self.addressLabel.attributedText = [address.addressInfo attributedStringWithLineSpacing:8];
    [self.addressLabel sizeToFit];
    //req
    self.createOrderReq.orderType = 2;
    self.createOrderReq.addrId = address.addrId;
  
    
    [self.tableView reloadData];

    
}


- (void)setupTime {

    self.createOrderReq.serviceStartTime =  self.currentDate.serviceStartTime;
     self.createOrderReq.serviceEndTime =  self.currentDate.serviceEndTime;
    
    self.timeLabel.textColor = APPDarkCOLOR;

}

- (void)setupKindFolk:(KinsfolkVO *)kinsfolk {
    
    if (!kinsfolk || kinsfolk.name.length == 0) {
        self.patientLabel.text = @"被服务人信息";
        self.patientLabel.textColor = APPGrayCOLOR;
        return;
    }

    
    self.createOrderReq.kinsId = kinsfolk.kinsId;
    self.patientLabel.text = [NSString stringWithFormat:@"%@     %@岁      %@",kinsfolk.name,@(kinsfolk.age),((kinsfolk.sex == 1) ? @"男" : @"女")];
    self.patientLabel.textColor = APPDarkCOLOR;
}




@end



typedef void(^Complete)(id orderID,uint32_t doPay);


@interface YJYOrderHospitalNurseController ()


@property (weak, nonatomic) IBOutlet UIButton *prePayButton;
@property (weak, nonatomic) IBOutlet UILabel *tipServiceTitleLabel;
@property (strong, nonatomic) YJYOrderBookContentController *contentVC;

@end

@implementation YJYOrderHospitalNurseController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderBookContentController"]) {
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = segue.destinationViewController;
        self.contentVC.didSelectBlock = ^(CompanyPriceVO *companyPrice) {
           [weakSelf.prePayButton setTitle:[NSString stringWithFormat:@"预付款 %@元",companyPrice.prepayAmount] forState:0];

        };
        
        //req
        
        GetPriceReq *req = [GetPriceReq new];
        
        if ([KeychainManager getValueWithKey:kAdcode]) {
            req.adcode = (uint32_t)[[KeychainManager getValueWithKey:kAdcode] integerValue];
        }
        req.st = (uint32_t)[self.st integerValue];
        req.islti = self.islti;
        self.contentVC.req = req;
        
        
        

    }
}

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderHospitalNurseController *)[UIStoryboard storyboardWithName:@"YJYOrderBook" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
}


- (IBAction)comfireAction:(id)sender {
    
    
    [SYProgressHUD show];
    
    CreateOrderReq *req  = self.contentVC.createOrderReq;
    
    if (!req.addrId) {
        [SYProgressHUD showFailureText:@"请选择地址"];
        return;
    }
    
    if (!req.kinsId) {
        [SYProgressHUD showFailureText:@"请选择被照护人"];
        return;
    }
    
    if (!req.serviceStartTime || req.serviceStartTime.length == 0) {
        [SYProgressHUD showFailureText:@"请选择时间"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.contentVC timeAction:nil];
        });
        return;
    }
    
    if (!self.contentVC.phoneTextField.text || self.contentVC.phoneTextField.text.length != 11) {
        [SYProgressHUD showFailureText:@"请填写正确手机号"];
        return;
    }
    if (!self.contentVC.currentCompanyPrice.price) {
        [SYProgressHUD showFailureText:@"请选择套餐"];
        return;
    }
    
   
    
    req.priceId = self.contentVC.currentCompanyPrice.price.priceId;
    req.phone = self.contentVC.phoneTextField.text;

    [YJYNetworkManager requestWithUrlString:APPCreateOrder message:req controller:self command:APP_COMMAND_AppcreateOrder success:^(id response) {
        
        CreateOrderRsp *rsp = [CreateOrderRsp parseFromData:response error:nil];
        
        YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
        vc.fromBooking = YES;
        vc.orderId = rsp.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        
        [SYProgressHUD hide];

        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}







@end
