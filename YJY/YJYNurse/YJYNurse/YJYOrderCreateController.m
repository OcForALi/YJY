//
//  YJYOrderCreateController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/16.
//  No Comment © 2017年 samwuu. All rights reserved.
// what the fucking is the project

//

#import "YJYOrderCreateController.h"
#import "YJYPersonListController.h"
#import "YJYPersonEditController.h"
#import "YJYAddressesController.h"
#import "YJYAddressPositionController.h"
#import "YJYTimePicker.h"
#import "YJYOrderCreatePriceCell.h"
#import "YJYOrderHomeServicesController.h"
#import "YJYBookBranchController.h"
#import "YJYOrderDetailController.h"


#pragma mark - YJYOrderCreateContentController


@interface YJYOrderCreateContentController : YJYTableViewController
@property (weak, nonatomic) IBOutlet YJYOrderCreatePriceCell *priceItemCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *useridCell;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serveTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *beServerButton;
@property (weak, nonatomic) IBOutlet UITextView *securityTextView;
@property (weak, nonatomic) IBOutlet UILabel *addressTipLabel;
@property (weak, nonatomic) IBOutlet UIView *securityView;


//outdata

@property (assign, nonatomic) YJYOrderCreateType createType;
@property(nonatomic, readwrite) InsureNOModel *insureModel;
@property(nonatomic, readwrite) NSString *contactPhone;
@property (copy, nonatomic) YJYOrderCreatePriceCellDidSelectBlock didSelectBlock;


//data

@property (strong, nonatomic) GetPriceRsp *rsp;
@property (strong, nonatomic) CreateOrderReq *createOrderReq;
@property (strong, nonatomic) CreateInsureOrderReq *createInsureOrderReq;

@property (strong, nonatomic) NSMutableArray *priceArray;

@property (strong, nonatomic) KinsfolkVO *currentKinsfolk;
@property (strong, nonatomic) OrderTimeData *currentDate;
@property (strong, nonatomic) UserAddressVO *currentAddress;
@property (strong, nonatomic) IndexServiceItem *currentItem;
@property (assign, nonatomic) uint64_t currentPriceId;

@end

@implementation YJYOrderCreateContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.priceArray = [NSMutableArray array];
    //view
    
    self.userIDLabel.text = self.createType == YJYOrderCreateTypeLongNurse ? self.insureModel.contactPhone : self.contactPhone;
    
    self.currentItem = [YJYSettingManager sharedInstance].items.firstObject;
    self.createOrderReq = [CreateOrderReq new];
    self.createInsureOrderReq = [CreateInsureOrderReq new];
    
    self.beServerButton.hidden = (self.createType == YJYOrderCreateTypeLongNurse);
    
    //被服务人
    if (self.createType != YJYOrderCreateTypeLongNurse) {
        
        self.createOrderReq.userId = [YJYSettingManager sharedInstance].userId;
        [self loadNetworkKinsfolk];

    }else {
        
        [YJYSettingManager sharedInstance].userId = self.insureModel.userId;
        self.createInsureOrderReq.userId = [YJYSettingManager sharedInstance].userId;
        self.createInsureOrderReq.kinsId = self.insureModel.kinsId;
        self.createInsureOrderReq.insureNo = self.insureModel.insureNo;
        self.beServerLabel.text = self.insureModel.kinsName;
        self.beServerLabel.textColor = APPNurseDarkGrayCOLOR;
    }
    
    
    
    //地址
    
    if (self.createType == YJYOrderCreateTypeHome){
        self.createOrderReq.orderType = 2;
        [self loadNetworkAddress];

        
    }else if (self.createType == YJYOrderCreateTypeLongNurse){
        self.createOrderReq.orderType = 2;
        
        UserAddressVO *address = [UserAddressVO new];
        address.addrId = self.insureModel.addrId;
        NSString *addressName = [NSString stringWithFormat:@"%@%@%@%@",self.insureModel.province,self.insureModel.city,self.insureModel.district,self.insureModel.addrDetail];
        address.addressInfo = addressName;

        
        [self setupAddress:address];
    }
    
    //套餐
    if (self.createType != YJYOrderCreateTypeHome) {
        [self loadPackage];

    }
    
    self.securityView.layer.cornerRadius = 5;
    self.securityView.layer.borderColor = [UIColor colorWithHexString:@"d6d8d7"].CGColor;
    self.securityView.layer.borderWidth = 1;
   
    [self setupCell];
    [self loadDefaultTimeNetwork];
    
}

- (void)setCreateType:(YJYOrderCreateType)createType {
    
    _createType = createType;
    
    [self.tableView reloadData];

}
- (void)setupCell {

    
    [self.useridCell yjy_setBottomShadow];
    
    //cell
    
    __weak typeof(self) weakSelf = self;
    self.priceItemCell.createType = self.createType;
    self.priceItemCell.hospitalPrepayAmount = self.rsp.prepayAmount;
    self.priceItemCell.didSwicthBlock = ^(NSInteger tag) {
        
        weakSelf.priceArray = (tag == 0) ? weakSelf.rsp.pList121Array : weakSelf.rsp.pList12NArray;
        [weakSelf setupPriceArray];
        [weakSelf.priceItemCell.tableView reloadAllData];
        
        
    };
    self.priceItemCell.didSelectBlock = ^(uint64_t priceId, NSString *prepayAmount) {
        
        if (prepayAmount) {
            weakSelf.priceItemCell.hospitalPrepayAmount = prepayAmount;
        }
        
    };
    self.priceItemCell.didSelectSyncBlock = ^(id price) {
        

        if ([price isKindOfClass:[CompanyPriceVO class]]) {
            weakSelf.priceItemCell.prePayLabel.text = [NSString stringWithFormat:@"预约金:%@元",[(CompanyPriceVO *)price prepayAmount]];

        }

    };
    
}
#pragma mark - Network

- (void)loadPackage {
    
    GetPriceReq *req = [GetPriceReq new];
    
    //req
    if (self.createType == YJYOrderCreateTypeLongNurse) {
        req.islti = YES;
    }else if (self.createType == YJYOrderCreateTypeHome) {
        req.st =  self.currentItem.st;
        req.adcode = [YJYSettingManager sharedInstance].adcode;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetPrice message:req controller:self command:APP_COMMAND_SaasappgetPrice success:^(id response) {
        
        //rsp
        
        self.rsp = [GetPriceRsp parseFromData:response error:nil];
        
        if (self.createType == YJYOrderCreateTypeLongNurse) {
            
            self.priceArray = self.rsp.familyPriceVolistArray;
            
        }else if (self.createType == YJYOrderCreateTypeHome) {
            
            self.priceArray = self.rsp.familyPriceVolistArray;

        }
        [self reloadAllData];
        [self setupPriceArray];
        

    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];

}

- (void)loadNetworkKinsfolk {
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserKinsList message:req controller:self command:APP_COMMAND_SaasappgetUserKinsList success:^(id response) {
        
        
        GetUserKinsListRsp *rsp = [GetUserKinsListRsp parseFromData:response error:nil];
        self.currentKinsfolk = rsp.kinsListArray.firstObject;
        
        [self setupKindFolk:self.currentKinsfolk];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)loadNetworkAddress {
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserAddrList message:req controller:self command:APP_COMMAND_SaasappgetUserAddrList success:^(id response) {
        
        
        GetUserAddrListRsp *rsp = [GetUserAddrListRsp parseFromData:response error:nil];
        self.currentAddress = rsp.addrListArray.firstObject;
        [self setupAddress:self.currentAddress];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)loadDefaultTimeNetwork {
    
    GetOrderTimeReq *req = [GetOrderTimeReq new];
    
    req.orderType = 1;

    [YJYNetworkManager requestWithUrlString:APPGetOrderTime message:req controller:nil command:APP_COMMAND_AppgetOrderTime success:^(id response) {
        
        GetOrderTimeRsp *rsp = [GetOrderTimeRsp parseFromData:response error:nil];
        self.currentDate = rsp.defaultTimeData;
        [self setupTime];

        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

#pragma mark - Data

- (void)setupAddress:(UserAddressVO *)address {
    
    if (!address || address.addressInfo.length == 0) {
        self.addressLabel.text = @"被服务人信息";
        return;
    }
    
    self.currentAddress = address;
    self.addressLabel.text = address.addressInfo;
    self.addressLabel.textColor = APPNurseDarkGrayCOLOR;
    //req
    (self.createType == YJYOrderCreateTypeLongNurse) ? (self.createInsureOrderReq.addrId = address.addrId) : (self.createOrderReq.addrId = address.addrId);
    
    [self.tableView reloadData];
    
   
    
}


- (void)setupTime {
    
    
    (self.createType == YJYOrderCreateTypeLongNurse) ? (self.createInsureOrderReq.serviceStartTime = self.currentDate.serviceStartTime) : (self.createOrderReq.serviceStartTime = self.currentDate.serviceStartTime);

    (self.createType == YJYOrderCreateTypeLongNurse) ? (self.createInsureOrderReq.serviceEndTime = self.currentDate.serviceEndTime) : (self.createOrderReq.serviceEndTime = self.currentDate.serviceEndTime);

    NSString *serviceStartTime = self.currentDate.serviceStartTime;
    NSString *serviceEndTime = self.currentDate.serviceEndTime;
    
    NSDate *startDate = [NSDate dateString:serviceStartTime Format:YYYY_MM_DD_HH_MM_SS];
    NSDate *endDate = [NSDate dateString:serviceEndTime Format:YYYY_MM_DD_HH_MM_SS];
    NSString *startDataString = [NSDate getRealDateTime:startDate withFormat:YYYY_MM_DD_HH_MM];
    
    NSString *endDataString = [NSDate getRealDateTime:endDate withFormat:HH_MM];
    
    NSString *fullTime = [NSString stringWithFormat:@"%@-%@",startDataString,endDataString];
    
    self.timeLabel.text = fullTime;
    self.timeLabel.textColor = APPNurseDarkGrayCOLOR;
    
}

- (void)setupKindFolk:(KinsfolkVO *)kinsfolk {
    
    if (!kinsfolk || kinsfolk.name.length == 0) {
        self.beServerLabel.text = @"被服务人信息";
        return;
    }
    
    self.beServerLabel.text = kinsfolk.name;
    self.beServerLabel.textColor = APPNurseDarkGrayCOLOR;

    
    (self.createType == YJYOrderCreateTypeLongNurse) ? (self.createInsureOrderReq.kinsId = kinsfolk.kinsId) : (self.createOrderReq.kinsId = kinsfolk.kinsId);
    
   
}

- (void)setupPriceArray {

    self.priceItemCell.hospitalPrepayAmount = self.rsp.prepayAmount;
    self.priceItemCell.priceArray = self.priceArray;
    self.priceItemCell.createType = self.createType;

    [self reloadAllData];

}

#pragma mark - Action
- (void)done {

    [SYProgressHUD show];
    

  
    NSMutableArray *additionArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.priceItemCell.tableView.indexPathsForSelectedRows.count; i++) {
        
        
        NSIndexPath *indexPath = self.priceItemCell.tableView.indexPathsForSelectedRows[i];
        id price = self.priceItemCell.priceArray[indexPath.row];
        uint64_t priceID;
        
        if ([price isKindOfClass:[Price class]]) {
            
            priceID = [(Price *)price priceId];
            
        }else {
            
            priceID = [[(CompanyPriceVO *)price price] priceId];
        }
        
        [additionArray addObject:[NSString stringWithFormat:@"%@",@(priceID)]];
        
    }
    self.createOrderReq.priceId = (uint64_t)[additionArray.firstObject integerValue];
    self.createOrderReq.securityAssess = self.securityTextView.text;
    id req = self.createOrderReq;
    
    if (self.createType == YJYOrderCreateTypeLongNurse) {
        
        uint64_t priceID =  [[(CompanyPriceVO *)self.priceArray.firstObject price] priceId];
        self.createInsureOrderReq.priceId = priceID;
        self.createInsureOrderReq.priceitemIdsArray = additionArray;
        req = self.createInsureOrderReq;

    }
    
    
    
    //url
    NSString *urlstring = (self.createType == YJYOrderCreateTypeLongNurse) ? SAASAPPCreateInsureOrder : SAASAPPCreateOrder;
    APP_COMMAND command = (self.createType == YJYOrderCreateTypeLongNurse) ? APP_COMMAND_SaasappcreateInsureOrder: APP_COMMAND_SaasappcreateOrder;

    //command

    [YJYNetworkManager requestWithUrlString:urlstring message:req controller:self command:command success:^(id response) {
        
        CreateOrderRsp *rsp = [CreateOrderRsp parseFromData:response error:nil];
        YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
        vc.orderId = rsp.orderId;
        vc.fromCreate = YES;
        [self.navigationController pushViewController:vc animated:YES];

        [SYProgressHUD showSuccessText:@"创建成功"];


    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)toSwitchTime:(id)sender {
    
    YJYTimePicker *picker = [YJYTimePicker instancetypeWithXIB];
    picker.orderType = 1;
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
        self.timeLabel.textColor = APPNurseDarkGrayCOLOR;
        
        self.currentDate = orderTimeData;
        
        [self setupTime];
        
        
    };
    [picker showInView:nil];
    
}
- (IBAction)toSwitchSt:(id)sender {
    
    YJYOrderHomeServicesController *vc = [YJYOrderHomeServicesController instanceWithStoryBoard];
    vc.didSelectBlock = ^(IndexServiceItem *item) {
        
        self.currentItem = item;
        self.serveTypeLabel.text = item.iconDesc;
        self.serveTypeLabel.textColor = APPNurseDarkGrayCOLOR;
        [self loadPackage];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toSwitchAddress:(id)sender {
    
    [self toAddressList];
}
- (IBAction)toSwitchPerson:(id)sender {
    
    [SYProgressHUD show];
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserKinsList message:req controller:self command:APP_COMMAND_SaasappgetUserKinsList success:^(id response) {
        
        
        [SYProgressHUD hide];
        
        GetUserKinsListRsp *rsp = [GetUserKinsListRsp parseFromData:response error:nil];
        if (rsp.kinsListArray.count > 0) {
            
            YJYPersonListController *vc = [YJYPersonListController instanceWithStoryBoard];
            vc.kinsType = YJYPersonListKinsTypeNormal;
            vc.kinsfolksDidSelectBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
            vc.firstAdd = YES;
            vc.kinsType = self.createType == YJYOrderCreateTypeLongNurse ? 1 : 0;
            vc.didDoneBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self loadNetworkKinsfolk];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}

- (void)toAddressList{

    [SYProgressHUD show];
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserAddrList message:req controller:self command:APP_COMMAND_SaasappgetUserAddrList success:^(id response) {
        
        GetUserAddrListRsp *rsp = [GetUserAddrListRsp parseFromData:response error:nil];
        if (rsp.addrListArray.count > 0) {
            
            YJYAddressesController *vc = [YJYAddressesController instanceWithStoryBoard];
            vc.didSelectBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            
            YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
            vc.addressDidSavedBlock = ^(UserAddressVO *address) {
                [self loadNetworkAddress];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        [SYProgressHUD hide];
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}


#pragma mark - UITableView



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 2) {
        //地址
        
        CGSize size = [self.addressLabel.text boundingRectWithSize:CGSizeMake(self.addressLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.addressLabel.font} context:nil].size;
        double height = ceil(size.height);
        
        return 50 + height;
        
    }else if ((indexPath.row == 4 || indexPath.row == 5) && (self.createType != YJYOrderCreateTypeHome)) {
        
        return 0;
        
    }else if (indexPath.row == 6) {
    
        return [self.priceItemCell cellHeight];
    
    }else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];

    }
    
    
}

@end



@interface YJYOrderCreateController ()

@property (strong, nonatomic) YJYOrderCreateContentController *contentVC;

@end

@implementation YJYOrderCreateController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderCreateController *)[UIStoryboard storyboardWithName:@"YJYOrderCreate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderCreateContentController"]) {
        self.contentVC = segue.destinationViewController;
        if (self.insureModel) {
            
            self.contentVC.insureModel = self.insureModel;
            [YJYSettingManager sharedInstance].userId = self.insureModel.userId;
        }else {
            
            self.contentVC.contactPhone = self.contactPhone;
        }
        
        self.contentVC.createType = self.createType;

    }
}

- (IBAction)done:(id)sender {
    
    [self.contentVC done];
}



@end
