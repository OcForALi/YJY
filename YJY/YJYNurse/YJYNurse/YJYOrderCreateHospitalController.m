//
//  YJYOrderCreateHospitalController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/9/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderCreateHospitalController.h"
#import "YJYOrderCreatePriceCell.h"
#import "YJYTimePicker.h"
#import "YJYOrderDetailController.h"
#import "YJYPersonListController.h"
#import "YJYPersonEditController.h"
#import "YJYBookBranchController.h"
#import "IQActionSheetPickerView.h"
#import "YJYOrderContractController.h"
#import "AppDelegate.h"

@interface YJYOrderCreateHospitalContentController:YJYTableViewController<IQActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet YJYOrderCreatePriceCell *priceItemCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *useridCell;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *toHospitaltimeLabel;

@property (weak, nonatomic) IBOutlet UITextField *beServerLabel;
@property (weak, nonatomic) IBOutlet UITextField *hospitalNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexLabel;
@property (weak, nonatomic) IBOutlet UITextField *ageLabel;
@property (weak, nonatomic) IBOutlet UITextField *bedNoTextField;

@property (weak, nonatomic) IBOutlet UILabel *preMoneyLabel;

// 门禁卡
@property (weak, nonatomic) IBOutlet UIImageView *doorBanSelectView;
@property (weak, nonatomic) IBOutlet UILabel *doorBanNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorBanTipLabel;

//outdata

@property (copy, nonatomic) NSString *contactPhone;
@property(nonatomic, strong) OrderVO *orderVo;

//data

@property (strong, nonatomic) GetPriceRsp *rsp;
@property (strong, nonatomic) CreateOrderReq *createOrderReq;

@property (strong, nonatomic) NSMutableArray *priceArray;

@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (strong, nonatomic) BranchModel *currentBranch;
@property (strong, nonatomic) RoomModel *currentRoom;
@property (strong, nonatomic) BedModel *currentBed;
@property (strong, nonatomic) KinsfolkVO *currentKinsfolk;
@property (strong, nonatomic) OrderTimeData *currentDate;
@property (strong, nonatomic) IndexServiceItem *currentItem;
@property (assign, nonatomic) uint64_t currentPriceId;
@property (assign, nonatomic) BOOL isDoorBan;

@end

@implementation YJYOrderCreateHospitalContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.priceArray = [NSMutableArray array];
    self.isDoorBan = YES;
    //view
    
    self.userIDLabel.text = self.contactPhone;
    if ([YJYRoleManager sharedInstance].roleType != YJYRoleTypeSupervisor) {
        self.toHospitaltimeLabel.text = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];

    }
    
    self.currentItem = [YJYSettingManager sharedInstance].items.firstObject;
    self.createOrderReq = [CreateOrderReq new];
    self.createOrderReq.orderType = 1;

    //被服务人
    
    self.createOrderReq.userId = [YJYSettingManager sharedInstance].userId;
    
    
    [self setupCell];

    //套餐
    if (self.orderVo) {
        
        self.createOrderReq.userId = [YJYSettingManager sharedInstance].userId = self.orderVo.userId;
        [self loadOrderVo];
        [self loadPackage];
        
        //套餐
        [self.priceItemCell setSelectedPriceID:self.orderVo.priceId];
        self.createOrderReq.priceId = self.orderVo.priceId;

    }else {
        
        [self loadPackage];
        if (!([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor || [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker)) {
            [self loadCurrentOrgBranchData];
        }
    }
    [self loadDefaultTimeNetwork];

    
}

- (void)loadOrderVo {
    
    
    //1
    self.userIDLabel.text = self.orderVo.orderId;
    self.createOrderReq.orderId = self.orderVo.orderId;
    
    //2
    self.currentOrg = [OrgDistanceModel new];
    OrgVO *orgVo = [OrgVO new];
    orgVo.orgName = self.orderVo.orgName;
    orgVo.orgId = self.orderVo.orgId;
    self.currentOrg.orgVo = orgVo;
    self.createOrderReq.orgId = self.orderVo.orgId;
    
    self.currentBranch = [BranchModel new];
    self.currentBranch.branchName = self.orderVo.branchName;
    self.currentBranch.id_p = self.orderVo.branchId;
    
    [self setupHospitalWithOrg:self.currentOrg branch:self.currentBranch];
    
    //3.陪护人
    
    self.currentKinsfolk = [KinsfolkVO new];
    self.currentKinsfolk.kinsId = self.orderVo.kinsId;
    self.currentKinsfolk.name =  self.orderVo.kinsName;
    self.currentKinsfolk.sex = self.orderVo.sex;
    self.currentKinsfolk.age = self.orderVo.age;
    
    self.hospitalNumberTextField.text = self.orderVo.orgNo;
    self.bedNoTextField.text = self.orderVo.bed;
    
    
    [self setupKindFolk:self.currentKinsfolk];
    
}

#pragma mark - Network

- (void)loadPackage {
    
    GetPriceReq *req = [GetPriceReq new];
    
    if(self.currentBranch.id_p == 0) {
        return;
    }
    req.branchId = self.currentBranch.id_p;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetPrice message:req controller:self command:APP_COMMAND_SaasappgetPrice success:^(id response) {
        
        //rsp
        
        self.rsp = [GetPriceRsp parseFromData:response error:nil];
        self.priceArray = self.rsp.pList12NArray;
        
        YJYPriceType priceType = YJYPriceTypeBoth;
        if (self.rsp.pList12NArray.count > 0 && self.rsp.pList121Array.count == 0) {
            priceType = YJYPriceTypeOnlyMany;
            self.priceArray = self.rsp.pList12NArray;

        }else if (self.rsp.pList12NArray.count == 0 && self.rsp.pList121Array.count > 0) {
            priceType = YJYPriceTypeOnlyOne;
            self.priceArray = self.rsp.pList121Array;
            
        }
        
        [self reloadAllData];
        [self setupPriceArray];
        
        self.preMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.prepayAmount];
        self.doorBanNumberLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.entranceCardPriceStr];
        
        self.priceItemCell.priceType = priceType;
        [self.priceItemCell toSwitchPackage:self.priceItemCell.pubButton];
        
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

- (void)loadCurrentOrgBranchData {
    
    
    [SYProgressHUD show];
    
    GetOrgAndBranchListReq *req = [GetOrgAndBranchListReq new];
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranch message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranch success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        self.currentOrg = rsp.orgListArray.firstObject;
        
        if (self.currentOrg.orgVo.orgId) {
         
            [self loadBranchData];
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
    
    
    
}
- (void)loadBranchData {
    
    
    [SYProgressHUD show];
    
    GetOrgAndBranchListReq *req = [GetOrgAndBranchListReq new];
    
    req.orgId = self.currentOrg.orgVo.orgId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranch message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranch success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        NSArray *currentBranchListArray = [[rsp.map objectForKey:self.currentOrg.orgVo.orgId] branchListArray];
        BranchModel *branch = currentBranchListArray[0];
        
        [self setupHospitalWithOrg:self.currentOrg branch:branch];
       
        
        [self reloadAllData];
        
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
    
}

- (uint64_t)getPriceID {
    
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
    
    return (uint64_t)[additionArray.firstObject integerValue];
    
    
}

#pragma mark - Action
- (void)done {
    
    [SYProgressHUD show];
    
    self.createOrderReq.priceId = [self getPriceID];
    self.createOrderReq.orgNo = self.hospitalNumberTextField.text;
    self.createOrderReq.bedNo = self.bedNoTextField.text;
    
    self.createOrderReq.admissionDate = self.toHospitaltimeLabel.text;
    

    
    if ([self.createOrderReq.admissionDate isEqualToString:@"未选择"]) {
        [SYProgressHUD showInfoText:@"请选择入院日期"];
        return;
    }
    self.createOrderReq.needExtra = self.isDoorBan;
    
    if (!self.createOrderReq.kinsId) {
        self.createOrderReq.age = (u_int32_t)[self.ageLabel.text integerValue];
        self.createOrderReq.kinsName = self.beServerLabel.text;
        self.createOrderReq.sex = [self.sexLabel.text isEqualToString:@"男"] ? 1 : 2;
        
    }
    
    id req = self.createOrderReq;
    
    //url
    NSString *urlstring = SAASAPPCreateOrder;
    APP_COMMAND command = APP_COMMAND_SaasappcreateOrder;
    
    //command
    
    [YJYNetworkManager requestWithUrlString:urlstring message:req controller:self command:command success:^(id response) {
        [SYProgressHUD hide];
        
        CreateOrderRsp *rsp = [CreateOrderRsp parseFromData:response error:nil];
        
        YJYOrderContractController *contractController = [YJYOrderContractController instanceWithStoryBoard];
        contractController.orderId = rsp.orderId;
        contractController.isSetup = YES;
        
        contractController.urlString = [NSString stringWithFormat:@"%@?priceId=%@&branchId=%@",kUserKnowedURL,@(self.createOrderReq.priceId),self.createOrderReq.branchId > 0 ? @(self.createOrderReq.branchId) : @""];
        
        
        contractController.didSkipBlock = ^{
            
            YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
            vc.orderId = rsp.orderId;
            vc.fromCreate = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            [SYProgressHUD showSuccessText:@"创建成功"];
        };
        
        contractController.didDoneBlock = ^{
            
            YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
            vc.orderId = rsp.orderId;
            vc.fromCreate = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            [SYProgressHUD showSuccessText:@"创建成功"];
        };

        if (response == nil) {
            
            NSString *time = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD_HH_MM];
            
            NSMutableArray *notOrderList = [NSMutableArray array];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"] isKindOfClass:[NSArray class]]) {
                [notOrderList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"]];
            }
            
            NSDictionary *dict = [self.createOrderReq conversionDict];
            [notOrderList addObject:@{time:dict}];
            [[NSUserDefaults standardUserDefaults] setObject:notOrderList forKey:@"notOrderList"];
            [YJYAppDelegate networkFailureRequest];
            
            [self loseOrder];
        }
        
        YJYNavigationController *navi = [[YJYNavigationController alloc]initWithRootViewController:contractController];
        [self presentViewController:navi animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
//        NSString *time = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD_HH_MM];
//
//        NSMutableArray *notOrderList = [NSMutableArray array];
//
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"] isKindOfClass:[NSArray class]]) {
//            [notOrderList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"]];
//        }
//
//        NSDictionary *dict = [self.createOrderReq conversionDict];
//        [notOrderList addObject:@{time:dict}];
//        [[NSUserDefaults standardUserDefaults] setObject:notOrderList forKey:@"notOrderList"];
//        [YJYAppDelegate networkFailureRequest];
//
//        [self loseOrder];
    }];
}

- (void)loseOrder{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"下单失败，已添加至缓存队列" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    return;
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
        
        self.currentDate = orderTimeData;
        
        [self setupTime];
        
        
    };
    [picker showInView:nil];
    
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
            vc.didDoneBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self loadNetworkKinsfolk];

            };
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}

- (IBAction)toChangeDoorBanCardAction:(id)sender {
    
    self.isDoorBan = !self.isDoorBan;
    self.doorBanSelectView.image = [UIImage imageNamed:self.isDoorBan ? @"app_select_icon" :@"app_unselect_icon"];
    
    self.doorBanTipLabel.textColor = self.isDoorBan ? APPHEXCOLOR : APPDarkCOLOR;
    self.doorBanNumberLabel.textColor = self.isDoorBan ? APPHEXCOLOR : APPDarkCOLOR;
    
    
}

- (IBAction)toBranch {
    
    YJYBookBranchController *vc = [YJYBookBranchController instanceWithStoryBoard];
    vc.currentOrg = [OrgDistanceModel new];
    vc.currentOrg.orgVo = [YJYSettingManager sharedInstance].currentOrgVo;
    vc.didSelectBlock = ^(OrgDistanceModel *org, BranchModel *branch) {
        
        [self setupHospitalWithOrg:org branch:branch];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toChangeSex:(id)sender {
    
    if (self.currentKinsfolk) {
        return;
    }
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择性别" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@[@"女"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex != 0) {
            
            self.createOrderReq.sex = (u_int32_t)buttonIndex;
            self.sexLabel.text = buttonIndex == 2 ? @"女" : @"男";
        }
    }];
}

- (void)setupHospitalWithOrg:(OrgDistanceModel *)org branch:(BranchModel *)branch  {
    
    
    self.currentOrg = org;
    self.currentBranch = branch;
    
    NSString *des = [NSString stringWithFormat:@"%@ %@",org.orgVo.orgName,branch.branchName];
    
    if (branch.branchName) {
        self.branchLabel.text = des;
    }
    
    
    self.createOrderReq.orgId = self.currentOrg.orgVo.orgId;
    self.createOrderReq.branchId = self.currentBranch.id_p;
    
    
    [self loadPackage];
}
- (IBAction)toChangeToHosiptalTimeAction:(id)sender {

    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"入院时间" delegate:nil];
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];

    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
    picker.didSelectDate = ^(NSDate *date) {
        
        NSString *dataString = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
        self.toHospitaltimeLabel.text = dataString;
    };
    [picker show];
    
    
}



#pragma mark - setup

- (void)setupCell {
    
    
    [self.useridCell yjy_setBottomShadow];
    
    //cell
    
    __weak typeof(self) weakSelf = self;
    self.priceItemCell.createType = YJYOrderCreateTypeHospital;
    self.priceItemCell.hospitalPrepayAmount = self.rsp.prepayAmount;
    self.priceItemCell.didSwicthBlock = ^(NSInteger tag) {
        
        weakSelf.priceArray = (tag == 1) ? weakSelf.rsp.pList121Array : weakSelf.rsp.pList12NArray;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf setupPriceArray];

        });
        
        
    };
    self.priceItemCell.didSelectBlock = ^(uint64_t priceId, NSString *prepayAmount) {
        
        if (prepayAmount) {
            weakSelf.preMoneyLabel.text = [NSString stringWithFormat:@"%@元",prepayAmount];
        }
        
    };

    self.priceItemCell.didSelectSyncBlock = ^(id price) {
        
        Price *p = price;
        weakSelf.preMoneyLabel.text = [NSString stringWithFormat:@"%@元",p.prepayFeeStr];
        
//        int64_t doornum = (int64_t)[p.totalPrice integerValue] - p.prepayFee;
        weakSelf.doorBanNumberLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.entranceCardPriceStr];

        
    };
}

- (void)setupTime {
    
    
    self.createOrderReq.serviceStartTime = self.currentDate.serviceStartTime;
    self.createOrderReq.serviceEndTime = self.currentDate.serviceEndTime;
    NSString *serviceStartTime = self.currentDate.serviceStartTime;
    NSString *serviceEndTime = self.currentDate.serviceEndTime;
    
    NSDate *startDate = [NSDate dateString:serviceStartTime Format:YYYY_MM_DD_HH_MM_SS];
    NSDate *endDate = [NSDate dateString:serviceEndTime Format:YYYY_MM_DD_HH_MM_SS];
    NSString *startDataString = [NSDate getRealDateTime:startDate withFormat:YYYY_MM_DD_HH_MM];
    
    NSString *endDataString = [NSDate getRealDateTime:endDate withFormat:HH_MM];
    
    NSString *fullTime = [NSString stringWithFormat:@"%@-%@",startDataString,endDataString];
    
    self.timeLabel.text = fullTime;
    self.timeLabel.textColor = APPDarkCOLOR;
    
}

- (void)setupKindFolk:(KinsfolkVO *)kinsfolk {
    
    if (!kinsfolk || kinsfolk.name.length == 0) {
        return;
    }
    self.currentKinsfolk = kinsfolk;
    self.beServerLabel.text = kinsfolk.name;
    self.ageLabel.text = [NSString stringWithFormat:@"%@",@(kinsfolk.age)];
    self.sexLabel.text = [NSString stringWithFormat:@"%@",kinsfolk.sex == 1 ? @"男" : @"女"];
//    self.hospitalNumberTextField.text = [NSString stringWithFormat:@"%@",kinsfolk.medicalNo];
    self.createOrderReq.kinsId = kinsfolk.kinsId;
    
    if (self.currentKinsfolk) {
        
      
        self.beServerLabel.enabled = NO;
        self.ageLabel.enabled = NO;
        
    }
    
    
}
- (void)setupPriceArray {
    
    self.priceItemCell.hospitalPrepayAmount = self.rsp.prepayAmount;
    self.priceItemCell.priceArray = self.priceArray;
    self.priceItemCell.createType = YJYOrderCreateTypeHospital;
    
    [self reloadAllData];
    
   //
    
}



#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 12) {
        //门禁卡
        return [self.rsp.entranceCardPriceStr integerValue] > 0 ? 65 : 0;
    }
    
    if ((indexPath.row == 10 || indexPath.row == 11) && !self.currentBranch) {
        return 0;

    }
    
    if (indexPath.row == 13) {
        if (!self.currentBranch || self.priceArray.count == 0) {
            return 0;

        }else {
            
            return [self.priceItemCell cellHeight];
        }

    }
    
    
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end

@interface YJYOrderCreateHospitalController ()


@property (strong, nonatomic) YJYOrderCreateHospitalContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@end

@implementation YJYOrderCreateHospitalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderCreateHospitalController *)[UIStoryboard storyboardWithName:@"YJYOrderCreate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderCreateHospitalContentController"]) {
        self.contentVC = segue.destinationViewController;
        self.contentVC.contactPhone = self.contactPhone;
        self.contentVC.orderVo = self.orderVo;
    }
}


- (IBAction)done:(id)sender {
    
    if (!self.switchButton.selected) {
        [SYProgressHUD showInfoText:@"请勾选用户知情书"];
        return;
    }
    [self toJudgeSuccess:^{
        
        [self.contentVC done];

        
    } failure:^(NSString *msg) {
        
        [UIAlertController showAlertInViewController:self withTitle:msg message:nil alertControllerStyle:1 cancelButtonTitle:@"取消下单" destructiveButtonTitle:@"继续下单" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self.contentVC done];
            }
            
        }];
    }];
}
- (void)toJudgeSuccess:(DoneBlock)success
               failure:(DoneMsgBlock)failure{
    
    OrderRepetitionReq *req = [OrderRepetitionReq new];
    req.orgNo = self.contentVC.hospitalNumberTextField.text;
    req.branchId = self.contentVC.currentBranch.id_p;
    req.orgId = self.contentVC.currentOrg.orgVo.orgId;
    req.name = self.contentVC.beServerLabel.text;

    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderRepetition message:req controller:self command:APP_COMMAND_SaasappgetOrderRepetition success:^(id response) {
     
        /// 是否已下单 1-未下单 2-已下单

        OrderRepetitionRsp *rsp = [OrderRepetitionRsp parseFromData:response error:nil];
        if (rsp.status == 1) {

            if(success){
                success();
            }
            
        }else {
            
            if(failure){
                failure(rsp.noticeMsg);
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)toUserKnow:(id)sender {
    
    if ([self.contentVC getPriceID] == 0) {
        [SYProgressHUD showInfoText:@"请选择服务"];
        return;
    }
    if (!self.contentVC.currentBranch) {
        [SYProgressHUD showInfoText:@"请选择科室"];
        return;
    }
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?priceId=%@&branchId=%@",kUserKnowing,@([self.contentVC getPriceID]),@(self.contentVC.currentBranch.id_p)];
    vc.urlString = url;
    vc.title = @"用户知情书";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toSwitch:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
