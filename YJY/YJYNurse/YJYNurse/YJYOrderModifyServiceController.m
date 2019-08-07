//
//  YJYOrderModifyServiceController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderModifyServiceController.h"
#import "YJYAddressesController.h"
#import "YJYOrderBedController.h"
#import "YJYOrderCreatePriceCell.h"
#import "YJYEditController.h"
#import "YJYNurseWorkerController.h"
#import "YJYAddressPositionController.h"
#import "YJYOrderModifyDetailController.h"
#import "YJYOrderContractController.h"
#import "YJYPaymentAdjustController.h"
#import "YJYOrderDetailController.h"


@interface YJYOrderModifyServiceContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UILabel *contactTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *servicePeopleLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet YJYOrderCreatePriceCell *priceCell;

@property (strong, nonatomic) OrderVO *order;
@property (copy, nonatomic) YJYOrderModifyServiceDidDoneBlock didDoneBlock;

//data
@property (strong, nonatomic) NSMutableArray *priceArray;
@property (strong, nonatomic) GetOrderServiceRsp *rsp;
@property (strong, nonatomic) NSArray *priceName;
@property(nonatomic, readwrite) uint64_t lastPriceId;
@property (strong, nonatomic) UpdateOrderServeReq *req;
@property (assign, nonatomic) BOOL showPhone;
@property (assign, nonatomic) BOOL isDenySkip;

//net data
@property(nonatomic, readwrite) uint64_t hgId;
@property(nonatomic, readwrite) uint64_t addrId;
@property(nonatomic, readwrite) uint64_t priceId;
@property(nonatomic, readwrite) GPBUInt64Array *additionArray;
@property(nonatomic, readwrite) uint64_t branchId;
@property(nonatomic, readwrite) uint64_t roomId;
@property(nonatomic, readwrite) uint64_t bedId;
@property(nonatomic, readwrite) NSString *phone;
@property (assign, nonatomic) YJYOrderCreateType createType;

@property (weak, nonatomic) IBOutlet UIButton *modifyHgButton;

@property (weak, nonatomic) IBOutlet UIButton *modifyAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyContactButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyBranchButton;


@end

@implementation YJYOrderModifyServiceContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.priceArray = [NSMutableArray array];    
    [self loadNetworkData];
    
 
}


- (void)loadNetworkData {
    
    GetOrderProcessReq *req = [GetOrderProcessReq new];
    
    req.orderId = self.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderService message:req controller:self command:APP_COMMAND_SaasappgetOrderService success:^(id response) {
        
        //rsp
        
        self.rsp = [GetOrderServiceRsp parseFromData:response error:nil];
        [self reloadAllData];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    
}

- (void)reloadRsp {

    
    
    self.servicePeopleLabel.text = self.rsp.hgName.length > 0 ? self.rsp.hgName : @"请选择服务人员";
    
    if (self.rsp.contacts.length > 0) {
        self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:self.rsp.contacts phone:self.rsp.phone];
    }
    
    
    NSString *branchName = [NSString stringWithFormat:@"%@ %@ %@",self.rsp.branchName,self.rsp.roomNo,self.rsp.bedNo];


    BOOL isHome  = (self.rsp.serviceType != 1 && self.rsp.serviceType != 2);
    
    self.modifyAddressButton.hidden = !isHome;
    self.modifyContactButton.hidden = isHome;
    self.modifyBranchButton.hidden = isHome;
    
    self.contactTipLabel.text = isHome ? @"联系方式" : @"联系电话";
    self.addressTipLabel.text = isHome ? @"联系地址" : @"科室信息";
    self.addressLabel.text = isHome ? self.rsp.addrStr : branchName;
    
    NSString *phone;
    
    if (self.order.contactPhone.length == 0) {
        phone =@"";
    }else {
        phone = self.showPhone ? self.order.contactPhone : [self.order.contactPhone stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];

        
    }
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:self.order.contactName phone:phone];
    self.contactLabel.userInteractionEnabled = self.showPhone;
    self.contactLabel.delegate = self;

    //createType

    self.createType = YJYOrderCreateTypeHospital;
    if (self.order.orderType == 2) {
        self.createType = self.order.insureType == 1 ? YJYOrderCreateTypeLongNurse : YJYOrderCreateTypeHome;
    }
    
    //priceArray
    
    if (self.createType == YJYOrderCreateTypeHospital) {
        
        if (self.rsp.serviceType == YJYWorkerServiceTypeMany) {
            self.priceArray = self.rsp.pList12NArray;
        }else if (self.rsp.serviceType == YJYWorkerServiceTypeOne) {
            self.priceArray = self.rsp.pList121Array;
        }
        
    }else {
        self.priceArray = self.rsp.familyPriceVolistArray;
    }
    

    [self setupPriceCell];
    [self setupHiddenModifyHgButton];
}

- (void)setupPriceCell {
    
    self.priceCell.isModify = YES;
    self.priceCell.createType = self.createType;
    self.priceCell.priceArray = self.priceArray;
    self.priceCell.serviceType = self.rsp.serviceType;
    
    
    
    
    
    YJYPriceType priceType = YJYPriceTypeBoth;
    if (self.rsp.pList12NArray.count > 0 && self.rsp.pList121Array.count == 0) {
        priceType = YJYPriceTypeOnlyMany;
    }else if (self.rsp.pList12NArray.count == 0 && self.rsp.pList121Array.count > 0) {
        priceType = YJYPriceTypeOnlyOne;

    }
    self.priceCell.priceType = priceType;
    __weak typeof(self) weakSelf = self;
    self.priceCell.didSwicthBlock = ^(NSInteger serviceType) {
        
        if (serviceType == YJYWorkerServiceTypeMany) {
            self.priceArray = self.rsp.pList12NArray;
        }else if (serviceType == YJYWorkerServiceTypeOne) {
            self.priceArray = self.rsp.pList121Array;
        }
        
        weakSelf.priceCell.priceArray = weakSelf.priceArray;
        [weakSelf reloadAllData];
        [weakSelf.tableView reloadData];
    };
    
    self.priceCell.didSelectBlock = ^(uint64_t priceId, NSString *prepayAmount) {
        
        if (!weakSelf.lastPriceId && weakSelf.lastPriceId != priceId) {
            weakSelf.lastPriceId = priceId;
        }
        weakSelf.priceId = priceId;
        
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.rsp.serviceType == YJYWorkerServiceTypeMany) {
            [self.priceCell toSwitchPackage:self.priceCell.pubButton];
        }else if (self.rsp.serviceType == YJYWorkerServiceTypeOne) {
            [self.priceCell toSwitchPackage:self.priceCell.privateButton];
        }
        self.priceCell.priceName = self.priceName;

    });
}

- (void)setupHiddenModifyHgButton {

    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {

        if (self.order.status == YJYOrderStateWaitPay || self.order.status == YJYOrderStateWaitGuide) {
            //隐藏服务人员
            self.modifyHgButton.hidden = YES;
        }

        if (self.order.status == YJYOrderStateWaitServe || self.order.status == YJYOrderStateServing) {
            
            if (self.rsp.serviceType == YJYWorkerServiceTypeMany) {
                
                //普陪
                self.modifyHgButton.hidden = YES;
            }else {
            
                self.modifyHgButton.hidden = NO;

            }
        }
    }else {
    
        BOOL isNotHg = (self.order.status == 0 || self.order.status == -1 || self.hgId == 0);
        self.modifyHgButton.hidden = isNotHg;
    }

}
#pragma mark - Action

- (void)toChangeNurseCompleteNoneBlock:(CompleteNoneBlock)complete {

    YJYNurseWorkerController *vc = [YJYNurseWorkerController instanceWithStoryBoard];
    vc.orderId = self.order.orderId;
    vc.time = self.order.serviceTime;
    vc.nurseWorkType = YJYNurseWorkTypeWorker;
    vc.isToSelect = YES;
    vc.priceId = self.priceId;
    
    vc.didSelectBlock = ^(HgVO *hg) {
        

        self.hgId = hg.id_p;
        self.servicePeopleLabel.text = hg.fullName;
        if (complete) {
            complete();
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toBranchCompleteNoneBlock:(CompleteNoneBlock)complete {

    YJYOrderContractController *vc = [YJYOrderContractController instanceWithStoryBoard];
    vc.orderId = self.order.orderId;
    vc.isDenySkip = self.isDenySkip;
    
    vc.urlString = [NSString stringWithFormat:@"%@?priceId=%@&branchId=%@",kUserKnowedURL,@(self.priceId),self.order.branchId > 0 ? @(self.order.branchId) : @""];
    vc.newOrAltered = 1;
    vc.didDoneBlock = ^{
        
        YJYOrderDetailController *homeVC = [[YJYOrderDetailController alloc] init];
        UIViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[homeVC class]]) {
                target = controller;
            }
        }
        if (target) {
            [self.navigationController popToViewController:target animated:YES];
        }
        
        if (complete) {
            complete();
        }
    };
    vc.didSkipBlock = ^{
        
        YJYOrderDetailController *homeVC = [[YJYOrderDetailController alloc] init];
        UIViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[homeVC class]]) {
                target = controller;
            }
        }
        if (target) {
            [self.navigationController popToViewController:target animated:YES];
        }
        
        if (complete) {
            complete();
        }
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)toSwitchServerAction:(id)sender {
    
    [self toChangeNurseCompleteNoneBlock:nil];
    
    
}

- (IBAction)toBranchContact {
    
    YJYEditController *vc = [YJYEditController instanceWithStoryBoard];
    vc.originString = self.showPhone ?  self.rsp.phone : @"";
    vc.didEditBlock = ^(NSString *text) {
        self.contactLabel.htmlText = [NSString yjy_PhoneNumberStringWithOrigin:text];
        self.phone = self.contactLabel.plainText;

    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toAddressList{
    
    [SYProgressHUD show];
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserAddrList message:req controller:self command:APP_COMMAND_SaasappgetUserAddrList success:^(id response) {
        
        GetUserAddrListRsp *rsp = [GetUserAddrListRsp parseFromData:response error:nil];
        if (rsp.addrListArray.count > 0) {
            
            YJYAddressesController *vc = [YJYAddressesController instanceWithStoryBoard];
            vc.didSelectBlock = ^(UserAddressVO *address) {

                self.addressLabel.text = address.addressInfo;
                self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:address.contacts phone:address.phone];
                self.addrId = address.addrId;
                [self.tableView reloadData];

                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
        
            
            YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
            vc.addressDidSavedBlock = ^(UserAddressVO *address) {
                
                self.addressLabel.text = address.addressInfo;
                self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:address.contacts phone:address.phone];
                self.addrId = address.addrId;
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        [SYProgressHUD hide];
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}


- (IBAction)toBranch {
    
    YJYOrderBedController *vc = [YJYOrderBedController instanceWithStoryBoard];
    vc.currentOrg = [OrgDistanceModel new];
    vc.currentOrg.orgVo = [YJYSettingManager sharedInstance].currentOrgVo;
    vc.orderBedResultBlock = ^(OrgDistanceModel *currentOrg, BranchModel *branch, RoomModel *room, BedModel *bed) {
        
        self.branchId = branch.id_p;
        self.roomId = room.roomId;
        self.bedId = bed.bedId;
    
        NSString *des = [NSString stringWithFormat:@"%@ %@ %@ %@ ",currentOrg.orgVo.orgName,branch.branchName,room.roomNo,bed.bedNo];
        
        if (branch.branchName) {
            self.addressLabel.text = des;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)toComfireAction {
    
    self.req = [UpdateOrderServeReq new];
    
    if (self.rsp.updateType == 4 && self.order.status == YJYOrderStateServing) {
        
        NSMutableArray<NSString *> *updates = [NSMutableArray array];
        for (UpdateType *updateType in self.rsp.updatePriceTypeArray) {
            [updates addObject:updateType.updateTypeStr];
        }
        
        if (updates.count > 0) {
            
            [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:updates tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex > 0) {
                    NSInteger index = buttonIndex - 2;
                    ///变更服务，科室配置为手动选择收费的时传。 1 - 收取变更前服务费用 2-收取变更后服务费用

                    UpdateType *updateType = self.rsp.updatePriceTypeArray[index];
                    self.req.priceUpdateType = updateType.updateTypeId;
                    [self toPreComfireAction];
                }
                
            }];
        }else {
            
            [self toPreComfireAction];

            
        }
        
       
        
    }else {
        
        [self toPreComfireAction];
        
    }
}

- (void)toPreComfireAction {
    
    
    [self toJudgeOrderWithComplete:^{
        
        
        [self toFinishOtherAction];

    }failure:^{
        [self done:nil];
    }];
    
    
    
}
- (void)toJudgeOrderWithComplete:(CompleteNoneBlock)complete failure:(FailureNoneBlock)failure{
    
   
    if (self.lastPriceId == 0) {
        
        if(failure){
           failure();
        }
        
    }else {
        
        
        if (complete) {
            complete();
        }
    }
}



- (void)toFinishOtherAction {


    //督导
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
        
        if (self.order.status == YJYOrderStateWaitPay) {
            
            [UIAlertController showAlertInViewController:self withTitle:@"是否确定变更" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    //合同
                    [self toBranchCompleteNoneBlock:^{
                        
                        //完成订单
                        [self done:nil];
                    }];
                }
                
            }];
           
        }else if (self.order.status == YJYOrderStateWaitGuide) {
            //合同
            [self toBranchCompleteNoneBlock:^{
                
                //完成订单
                [self done:nil];
            }];
        }else if ([self.priceCell swichType] == YJYSwitchTypeM2O) {
            
            //切换护工
            [self toChangeNurseCompleteNoneBlock:^{
                
                [SYProgressHUD show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SYProgressHUD hide];
                    //合同
                    [self toBranchCompleteNoneBlock:^{
                        
                        [self done:nil];
                    }];
                    //完成订单
                });
                
                
            }];
            
        }else if (self.order.status == YJYOrderStateServing &&
                  ([self.priceCell swichType] == YJYSwitchTypeM2M ||
                   [self.priceCell swichType] == YJYSwitchTypeO2M ||
                   [self.priceCell swichType] == YJYSwitchTypeO2O)) {
            
            //合同
            [self toBranchCompleteNoneBlock:^{
                
                //完成订单
                [self done:nil];
            }];
            
            
        }else {
        
            //合同
            [self toBranchCompleteNoneBlock:^{
                
                //完成订单
                [self done:nil];
            }];
            
        }
     //多陪护工
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker && self.rsp.serviceType == YJYWorkerServiceTypeMany) {
    
        
        if ((self.order.status == YJYOrderStateWaitServe) && [self.priceCell swichType] == YJYSwitchTypeM2O) {
                
            [UIAlertController showAlertInViewController:self withTitle:@"是否将变更需求发送给督导" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    [self toNotificateSupervisor];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
            
        }else if ((self.order.status == YJYOrderStateWaitGuide || self.order.status == YJYOrderStateWaitServe || self.order.status == YJYOrderStateServing) && [self.priceCell swichType] == YJYSwitchTypeM2M) {
            
            //合同
            self.isDenySkip = YES;
            [self toBranchCompleteNoneBlock:^{
                
                self.isDenySkip = NO;
                //完成订单
                [self done:nil];
            }];
            
            
        }else if (self.order.status == YJYOrderStateServing && [self.priceCell swichType] == YJYSwitchTypeM2O) {
            //通知
            
            [UIAlertController showAlertInViewController:self withTitle:@"是否将变更需求发送给督导" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    [self toNotificateSupervisor];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
           

            
        }else {
            //完成订单
            [self done:nil];
        }
        
    }else {
    
        [self done:nil];

    }
    
}

- (void)done:(id)sender {
    
    
    [SYProgressHUD show];
    
    UpdateOrderServeReq *req = self.req;
    req.orderId = self.order.orderId;
    
    req.hgId = self.hgId ? self.hgId : self.rsp.hgId;
    req.addrId  = self.addrId ? self.addrId : self.rsp.addrId;
    req.phone  = self.phone ? self.phone : self.rsp.phone;
    
    req.branchId  = self.branchId ? self.branchId : self.rsp.branchId;
    req.roomId  = self.roomId ? self.roomId : self.rsp.roomId;
    req.bedId  = self.bedId ? self.bedId : self.rsp.bedId;
    
    if (self.order.orderType == 1) {
        req.priceId = self.priceId;
        
    }else {
        req = [self.priceCell createReqAdditionArrayAndPriceId:req insureType:self.order.insureType];
        
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateOrderServe message:req controller:self command:APP_COMMAND_SaasappupdateOrderServe success:^(id response) {
        
        [SYProgressHUD hide];
        
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {

    }];
    
}

- (void)toNotificateSupervisor {
    
    
    [SYProgressHUD show];
    
    OrderJPushReq *req = [OrderJPushReq new];
    req.orderId = self.order.orderId;
    req.jpushType = 2;
    req.priceId = self.priceId;
    [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"发送成功"];

        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 0;
    }
    else if (indexPath.row == 3) {
        //address

        CGFloat addressWidth = self.tableView.frame.size.width - (414-226);
        
        CGFloat markExtraHeight = [self.addressLabel.text boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height- 13;
    
        return 80 + markExtraHeight;
        
    }else if (indexPath.row == 4) {
        
        return [self.priceCell cellHeight];
        
    }else {
    
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

@end

@interface YJYOrderModifyServiceController ()

@property (strong, nonatomic) YJYOrderModifyServiceContentController *contentVC;

@end

@implementation YJYOrderModifyServiceController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderModifyServiceController *)[UIStoryboard storyboardWithName:@"YJYOrderModify" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderModifyServiceContentController"]) {
        self.contentVC = segue.destinationViewController;
        self.contentVC.order = self.order;
        self.contentVC.priceName = self.priceName;
        self.contentVC.showPhone = self.showPhone;
        __weak typeof(self) weakSelf = self;
        self.contentVC.didDoneBlock = ^{
            if (weakSelf.didDoneBlock) {
                weakSelf.didDoneBlock();
            }
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.didDoneBlock) {
        self.didDoneBlock();
    }
}

- (IBAction)toDetailAction:(id)sender {
    
    YJYOrderModifyDetailController *vc = [YJYOrderModifyDetailController instanceWithStoryBoard];
    vc.orderId = self.order.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)done:(id)sender {
    
    [self.contentVC toComfireAction];
}
@end
