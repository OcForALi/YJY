//
//  YJYOrderDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/31.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderDetailController.h"
#import "YJYOrderAddServicesController.h"
#import "YJYOrderDailyDetailController.h"
#import "YJYOrderItemDetailCell.h"
#import "YJYOrderServiceItemsCell.h"
#import "YJYOrderDailyDetailsCell.h"
#import "YJYWeakTimerManager.h"
#import "YJYOrderModifyServiceController.h"
#import "YJYNurseWorkerController.h"
#import "YJYOrderContractController.h"
#import "YJYPersonBeServerController.h"
#import "YJYOrderEndServiceController.h"
#import "YJYInsureBonusController.h"
#import "YJYOrderPayOffController.h"
#import "YJYOrderAddAdjustController.h"
#import "YJYPayOffComfireAddController.h"
#import "YJYOrderPrePayChargeController.h"
#import "YJYEditController.h"
#import "YJYOrderRefundController.h"
#import "YJYOrderQRController.h"
#import "YJYOrderDetailBedController.h"
#import "YJYPaymentAdjustController.h"
#import "YJYOrderNightCareController.h"
#import "YJYBookBranchController.h"
#import "YJYInsureTimeChooseView.h"
#import "YJYPayOffDetailController.h"
#import "YJYHandBedDetailController.h"
#import "YJYOrderCreateHospitalController.h"
#import "YJYPeirenDetailController.h"

typedef NS_ENUM(NSInteger, YJYOrderDetailType) {
    
    YJYOrderDetailTypeOrderId,
    YJYOrderDetailTypeCountTime,
    YJYOrderDetailTypeServiceItem,
    YJYOrderDetailTypeOrderTime,
    YJYOrderDetailTypeBeService,
    YJYOrderDetailTypeHospitalNumber,
    YJYOrderDetailTypeSignState,
    YJYOrderDetailTypeServicer,
    YJYOrderDetailTypeContact,
    YJYOrderDetailTypeServiceLocation,
    YJYOrderDetailTypeBedNo,
    YJYOrderDetailTypeYesterdayBedNo,
    YJYOrderDetailTypeTodayBedNo,
    YJYOrderDetailTypeNightNum,
    YJYOrderDetailTypeHangingBedDays,
    YJYOrderDetailTypeWorkerPay,
    YJYOrderDetailTypeTakePeopleBed,
    YJYOrderDetailTypePayDetail,
    YJYOrderDetailTypePrePay,
    YJYOrderDetailTypeDoorban,
    YJYOrderDetailTypeNurseServices ,
    YJYOrderDetailTypeTotoalPay ,
    YJYOrderDetailTypePrePayMoney ,
    YJYOrderDetailTypeButieYue ,
    YJYOrderDetailTypeAddJust,
    YJYOrderDetailTypeDaily ,
    
};

typedef void(^OrderDetailDidLoadBlock)();

#pragma mark - YJYOrderDetailContentController

@interface YJYOrderDetailContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UIView *orderHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *beServerLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *guideButton;
@property (weak, nonatomic) IBOutlet UILabel *adjustMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *adjustTimeLabel;

//bad
@property (weak, nonatomic) IBOutlet UILabel *bedNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayBedNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayBedNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseBedButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseYesterdayBedButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseTodayBedButton;


@property (weak, nonatomic) IBOutlet UILabel *workerPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayBedPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *nightCareEditButton;


@property (weak, nonatomic) IBOutlet UILabel *hospitalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLocationTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightCareNumberLabel;

//挂床
@property (weak, nonatomic) IBOutlet UILabel *hangingBedDaysLabel;


//health & supervisor
@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *prePayLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorBanMoneyLabel;

//daily

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *preLabel;
@property (weak, nonatomic) IBOutlet UILabel *recuitLabel;

//cell
@property (weak, nonatomic) IBOutlet UITableViewCell *timeViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *doorbanCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet YJYOrderServiceItemsCell *serviceItemsCell;
@property (weak, nonatomic) IBOutlet YJYOrderItemDetailCell *itemDetailCell;
@property (weak, nonatomic) IBOutlet YJYOrderDailyDetailsCell *dailyDetailsCell;
@property (weak, nonatomic) IBOutlet UILabel *hosiptalSectionLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchSectionButton;

//out
@property (copy, nonatomic) NSString *orderId;
@property (strong, nonatomic) OrderListVO *orderListVO;

//sign
@property (weak, nonatomic) IBOutlet UILabel *signStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *toSignButton;

//data
@property (strong, nonatomic)GetOrderInfoRsp *rsp;
@property (assign, nonatomic)BOOL isExpend;
@property (assign, nonatomic) BOOL isToRoot;
@property (assign, nonatomic) BOOL isSignPicFirst;
@property (assign, nonatomic) BOOL isReSign;


//manager
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countDown;


@property (copy, nonatomic) OrderDetailDidLoadBlock didLoadBlock;
@property (copy, nonatomic) OrderDetailDidLoadBlock didCancelBlock;

@end

@implementation YJYOrderDetailContentController

- (void)viewDidLoad {
    
    if (self.orderListVO.orderId) {
        self.orderId = self.orderListVO.orderId;
    }
    if (self.orderId) {
    
        __weak __typeof(self)weakSelf = self;
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf loadNetworkData];
        }];
        [SYProgressHUD show];
        [self loadNotification];
        
    }else {
    
        [self loadCancelOrder];
    }
    [SYProgressHUD show];

    [self loadNetworkData];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.isSignPicFirst = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [SYProgressHUD hide];

    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self navigationBarNotAlphaWithBlackTint];

}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.orderHeaderView yjy_setBottomShadow];
    [self.addressCell yjy_setBottomShadow];

}
#pragma mark - load

- (void)loadCancelOrder {

    OrderListVO *order = self.orderListVO;
    
//    NSString *hospitalName = [NSString stringWithFormat:@"%@ %@ %@ %@",order.orgName,order.branchName,order.roomNo,order.bedNo];
//    NSString *addressName = [NSString stringWithFormat:@"%@%@%@%@%@",order.province,order.city,order.district,order.street,order.addrDetail];
    
    self.rsp = [GetOrderInfoRsp new];
    OrderVO *orderVo = [OrderVO new];
    orderVo.orderId = order.orderId;
    orderVo.kinsName = order.kinsName;
    orderVo.contactName = order.contacts;
    orderVo.contactPhone = order.contactPhone;
    orderVo.location = order.addrDetail;// (order.orderType == 1) ? hospitalName : addressName;
    orderVo.status = -1;
    orderVo.createTime = order.createTime;
    orderVo.statusStr = @"已取消";
//    orderVo.hgId = order.hgId;
//    orderVo.kinsId = order.kinsId;
//    orderVo.insureNo = order.insureNo;
    
    self.rsp.orderVo = orderVo;
    
    [self reloadRsp];
    if (self.didLoadBlock) {
        self.didLoadBlock();
    }
}



- (void)loadNotification {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNetworkData) name:kYJYOrderDetailUpdateNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)loadNetworkData {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    
    req.orderId = self.orderId;

    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderInfo message:req controller:self command:APP_COMMAND_SaasappgetOrderInfo success:^(id response) {
        
        
        GetOrderInfoRsp *rsp = [GetOrderInfoRsp parseFromData:response error:nil];
        
        self.rsp = rsp;
        
        if (self.didLoadBlock) {
            self.didLoadBlock();
        }
        
        [self reloadRsp];
        [self setupCountDownTime];
        [self reloadAllData];
        
       
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
    
}

- (void)reloadGuideButton {
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        
        
        BOOL isNotGuide = (self.rsp.orderVo.status != YJYOrderStateWaitGuide && self.rsp.orderVo.status != YJYOrderStateWaitServe && self.rsp.orderVo.status != YJYOrderStateServing);
        
        self.guideButton.hidden = isNotGuide;
        [self.guideButton setTitle:self.rsp.orderVo.status == YJYOrderStateWaitGuide ? @"指派" : @"更换" forState:0];
        
        
        //待评估
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager &&
            self.rsp.orderVo.insureType == 2 &&
            self.rsp.orderVo.pgStatus == 0 &&
            self.rsp.orderVo.status == YJYOrderStateWaitGuide) {
            
            self.guideButton.hidden = NO;
        }
        
        if (self.rsp.orderVo.insureType == 1) {
            self.guideButton.hidden = isNotGuide;
        }
        
        
        
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor){
        
        BOOL isNotGuide = (self.rsp.orderVo.status != YJYOrderStateWaitGuide && self.rsp.orderVo.status != YJYOrderStateWaitServe && self.rsp.orderVo.status != YJYOrderStateServing);
        
        self.guideButton.hidden = isNotGuide;
        [self.guideButton setTitle:self.rsp.orderVo.status == YJYOrderStateWaitGuide ? @"指派" : @"更换" forState:0];
        
        if (!self.rsp.isUpdateHg) {
            self.guideButton.hidden = YES;
        }

    }else {
        
        self.guideButton.hidden = YES;
    }
    
}

- (void)reloadRsp {

    [self reloadGuideButton];
   
    if (self.rsp.orderVo.status == YJYOrderTypeServing) {
        
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
            ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker && self.rsp.orderVo.serviceType == YJYWorkerServiceTypeMany)) {
            
            
            
            self.switchSectionButton.hidden = NO;
        }else {
            
            self.switchSectionButton.hidden = YES;

        }
        
    }else {
        
        self.switchSectionButton.hidden = YES;
    }
    
    if (self.rsp.orderVo.orderType == 1) {
        self.serviceLocationTipLabel.text = @"医院科室";
    }else {
        
        self.serviceLocationTipLabel.text = @"服务地址";
    }
    
    //data
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@", self.rsp.orderVo.orderId];
    self.beServerLabel.text = self.rsp.orderVo.kinsName;
    self.serverLabel.text = self.rsp.orderVo.serviceStaff.length > 0 ? self.rsp.orderVo.serviceStaff : @"无";
    
    
    NSString *phone;
    
    if (self.rsp.orderVo.contactPhone.length == 0) {
        phone = @"";
    }else {
        phone = self.rsp.showPhone ? self.rsp.orderVo.contactPhone : [self.rsp.orderVo.contactPhone stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        
    }
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:self.rsp.orderVo.contactName phone:phone];
    self.contactLabel.userInteractionEnabled = self.rsp.showPhone;
    self.contactLabel.delegate = self;
    
    NSString *orgName = [NSString stringWithFormat:@"%@\n%@",self.rsp.orderVo.hospital,self.rsp.orderVo.branch];
    self.locationLabel.text = self.rsp.orderVo.orderType == 1 ? orgName : self.rsp.orderVo.locationMinute;
    
    
    //床号
    self.bedNoLabel.text = self.rsp.orderVo.bed.length > 0 ? self.rsp.orderVo.bed: @"无";
    self.todayBedNumberLabel.text = [NSString stringWithFormat:@"%@个",@(self.rsp.subjoinNewNum)];
    self.chooseBedButton.hidden  = !self.rsp.isUpdateBedNo;

//    [self.chooseBedButton setTitle:self.rsp.orderVo.bed.length == 0 ? @"添加":@"修改" forState:0];
//    if (self.rsp.orderVo.status == YJYOrderStateCancel || self.rsp.orderVo.status > 6) {
//        self.chooseBedButton.hidden  = YES;
//
//    }else {
//        self.chooseBedButton.hidden  = NO;
//
//    }
    
    //今日陪人床
    [self.chooseTodayBedButton setTitle:self.rsp.subjoinNewNum > 0 ? @"修改": @"添加" forState:0];
    if (self.rsp.orderVo.status != YJYOrderStateServing ||
        self.rsp.orderVo.orderType == 2 ||
        !([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker || [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor)){

        self.chooseTodayBedButton.hidden  = YES;

    }else {
        self.chooseTodayBedButton.hidden  = NO;

    }
    
    //昨天陪人床
    self.yesterdayBedNumberLabel.text = self.rsp.yesterdayPrcnum;//[NSString stringWithFormat:@"%@个",self.rsp.yesterdayPrcnum];
//    self.chooseYesterdayBedButton.hidden = self.rsp.yesterdayPrcnum.length == 0;
    
    self.nightCareNumberLabel.text = [NSString stringWithFormat:@"%@", @(self.rsp.numberNight)];
    
    
    //挂床
    
    self.hangingBedDaysLabel.text = [NSString stringWithFormat:@"%@", @(self.rsp.hangServiceDateListArray_Count)];
    //
    self.workerPayLabel.text = [NSString stringWithFormat:@"%@元", self.rsp.accompanyFee];
    self.todayBedPayLabel.text = [NSString stringWithFormat:@"%@元", self.rsp.subjoinFeeStr];
    self.nightCareEditButton.hidden = !(self.rsp.orderVo.status == YJYOrderStateServing || self.rsp.orderVo.status == YJYOrderStateWaitPayOff);
    
    
    
    //取消
    if ( [self.rsp.orderVo.statusStr isEqualToString:@"已取消"]) {
        self.locationLabel.text = self.rsp.orderVo.location;
        self.guideButton.hidden = YES;
    }
    
    self.timeLabel.text = self.rsp.orderVo.createTime;
    self.orderStartTimeLabel.text = self.rsp.orderVo.orderStartTime;

    self.adjustMoneyLabel.text = [NSString stringWithFormat:@"附加服务:%@", self.rsp.orderVo.reviseFee];
    self.adjustTimeLabel.text = [NSString stringWithFormat:@"结束服务时间:%@", self.rsp.orderVo.updateTime];
    ////health & supervisor
    
    self.totalPayLabel.text = [NSString stringWithFormat:@"总额: %@元",self.rsp.confirmCost];
    self.prePayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.orderVo.preRealFee];
    self.doorBanMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.orderVo.extraFee.length > 0 ? self.rsp.orderVo.extraFee : @"0.00"];
    self.hospitalNumberLabel.text = self.rsp.orderVo.orgNo.length > 0 ?  self.rsp.orderVo.orgNo : @"无";
    
    //state
    
    
    ///-1-已取消 0-待付款预交金,1-待派工,2-待服务,3-服务中,4-服务完成,5-待评价,6-已完成

    UIColor *stateColor;
    uint32_t status = self.rsp.orderVo.status;
    
    if (status == 0 ||
        status == 1 ||
        status == 2 ||
        status == 6) {
        
        stateColor = APPREDCOLOR;
        
    }else if (status == 3){
        
        stateColor = APPHEXCOLOR;
        
    }else if (status == 4 ||
              status == 5){
        stateColor = APPORANGECOLOR;

        if (status == 4 && self.rsp.orderVo.settleItemStatus == 0) {
            stateColor = APPREDCOLOR;
            
        }
        
    }else if (status == -1){
        
        stateColor = APPNurseGrayRGBCOLOR;
        
        
    }
    
    //state
    
    self.stateButton.backgroundColor = stateColor;
    [self.stateButton setTitle:self.rsp.orderVo.statusStr forState:0];

    
    //cell
    
    [self setupServiceItemsCell];

    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager ||
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        [self setupDailyDetailsCell];

    }else {
    
        [self setupItemDetailCell];
    }
    
    
    //daily
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.confirmCost];
    self.preLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.orderVo.prepayAmount];
    self.recuitLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.insureAccount.length > 0 ? self.rsp.insureAccount : @"0"];
    
    
    //sign
    
    if (self.rsp.isSignPicRole && !self.rsp.isSignPic && self.isSignPicFirst) {
        
        self.isSignPicFirst = NO;
        [UIAlertController showAlertInViewController:self withTitle:@"当前服务未签署知情同意书，是否补签？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"去签署" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self toSign:nil];
            }
            
        }];
    }
    /// 是否已签署用户知情书 true-已签署 false-未签署
    
    self.toSignButton.hidden = !self.rsp.isSignPicRole;
    
    [self.toSignButton setTitle:self.rsp.isSignPic ? @"重新签名" : @"去签名" forState:0];
    self.signStateLabel.text = self.rsp.isSignPic ? @"已签署" : @"未签署";
    
    
    [self.tableView reloadData];

    [self.dailyDetailsCell.tableView reloadData];
    [self.serviceItemsCell.expandView.tableView reloadData];
    [self.itemDetailCell.tableView reloadData];
    


}
#pragma mark - cell


- (void)setupServiceItemsCell {

    //services
    
    __weak typeof(self) weakSelf = self;

    self.serviceItemsCell.priceNameArray = [NSMutableArray array];
    self.serviceItemsCell.priceNameArray = self.rsp.priceNameArray;
    
    
    self.serviceItemsCell.didExpandBlock = ^{
        
        [weakSelf reloadAllData];
    };
    
}
- (void)setupItemDetailCell {

    //items
    
    __weak typeof(self) weakSelf = self;
    
    self.itemDetailCell.orderItemArray = [NSMutableArray array];
    self.itemDetailCell.orderItemArray = self.rsp.insureItemArray;
    self.itemDetailCell.orderInfoRsp = self.rsp;
    //展开
    
    self.itemDetailCell.didExpandBlock = ^(BOOL isExpand) {
        
        
        [weakSelf reloadAllData];
        [weakSelf.itemDetailCell.tableView reloadData];
        
    };
    
    //添加修改附加服务
    self.itemDetailCell.didAddAndModifyBlock = ^(OrderItemVO *orderItem) {
        

        YJYOrderAddServicesController *vc = [YJYOrderAddServicesController instanceWithStoryBoard];
        vc.orderId = self.rsp.orderVo.orderId;
        vc.affirmTime = orderItem.serviceTime;
        
        BOOL isInsure = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse ||
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader;
        vc.isInsure = isInsure;
        
        vc.didEditServicesBlock = ^{
            
            [weakSelf reloadAllData];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //开关
    self.itemDetailCell.didDoneAndCloseBlock = ^(OrderItemVO *orderItem) {
        
        [weakSelf loadNetworkData];
        
    };
    
 
   //更新服务人员
    self.itemDetailCell.didChangeBlock  = ^(OrderItemVO *orderItem) {
        
        
        if (self.rsp.orderVo.insureType == 1) {
            [self toGuideNurseWorkerInsure:orderItem];
        }else {
            [self toGuideNurseWorkerJigou:orderItem];
            
            
        }
        
       
    };
}


- (void)toGuideNurseWorkerInsure:(OrderItemVO *)orderItem {
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.nurseWorkType = YJYNurseWorkTypeNurse;
    vc.isGuide = YES;
    vc.orderId = self.orderId;
    vc.time = orderItem.serviceTime;
    vc.isNurse = YES;
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        
        [self loadNetworkData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toGuideNurseWorkerJigou:(OrderItemVO *)orderItem {

    YJYNurseWorkerController *vc = [YJYNurseWorkerController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.time = orderItem.serviceTime;
    vc.nurseWorkType = YJYNurseWorkTypeNurse;
    vc.isToSelect = YES;
    
    if ([self.guideButton.currentTitle isEqualToString:@"更换"]) {
        vc.isUpdateHg = self.rsp.isUpdateHg;

    }
    
    vc.didSelectBlock = ^(HgVO *hg) {
        
        [self loadNetworkData];
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupDailyDetailsCell {

    //detail
    self.dailyDetailsCell.orderItemArray = [NSMutableArray array];
    self.dailyDetailsCell.orderItemArray = self.rsp.orderItemArray;
    self.dailyDetailsCell.orderInfoRsp = self.rsp;
    
    
    __weak typeof(self) weakSelf = self;
    self.dailyDetailsCell.toDetailBlock = ^() {
        
        YJYInsureBonusController *vc = [YJYInsureBonusController instanceWithStoryBoard];
        vc.order = weakSelf.rsp.orderVo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    self.dailyDetailsCell.toCellDetailBlock = ^(SettlementVO *orderItem) {
        // 禁止到跳转到每日明细
//        YJYOrderDailyDetailController *vc = [YJYOrderDailyDetailController instanceWithStoryBoard];
//        vc.orderId = weakSelf.orderId;
//        vc.settDate = orderItem.settleDate;
//        [weakSelf.navigationController pushViewController:vc animated:YES];

    };

    
    
    
}


- (void)setupCountDownTime {

    if (self.rsp.orderVo.status == 0 &&
        self.rsp.expire > 0 &&
        ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
         [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager||
         [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker)) {
            
            _countDown = (NSInteger)(self.rsp.expire/(NSInteger)1000);
            
            _timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
                
                if (_countDown == 0) {
                    if (self.didCancelBlock) {
                        self.didCancelBlock();
                    }
                    [_timer invalidate];
                   // _timer = nil;
                    return;
                }
                
                _countDown -=1;
                NSInteger hours = (int)_countDown/60/60;
                NSInteger mins = (_countDown - (hours * 60 * 60))/60;
                NSInteger seconds = (int)_countDown%60;
                self.levelTimeLabel.text =  [NSString stringWithFormat:@"剩余时间:%02d小时%02d分钟%02d秒",(int)hours,(int)mins,(int)seconds];
                
            } userInfo:nil repeats:YES];
            [_timer fire];
    }
}
#pragma mark - Action
- (IBAction)toCheckAddServiceAdjustAction:(id)sender {
    
    YJYOrderAddAdjustController *vc = [YJYOrderAddAdjustController instanceWithStoryBoard];
    vc.orderVo = self.rsp.orderVo;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (IBAction)toBeServiceAction:(id)sender {
    
    YJYPersonBeServerController *vc = [YJYPersonBeServerController instanceWithStoryBoard];
    
    vc.kinsId = self.rsp.orderVo.kinsId;
    vc.insureNo = self.rsp.orderVo.insureNo;
    vc.orderId = self.rsp.orderVo.orderId;
    vc.pgStatus = self.rsp.orderVo.pgStatus;
    vc.securityAssess = self.rsp.orderVo.securityAssess;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)toGuideNurseWorkerInsureAction:(id)sender {
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.time = self.rsp.orderVo.serviceTime;
    vc.nurseWorkType = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YJYNurseWorkTypeNurse : YJYNurseWorkTypeWorker;
    vc.isGuide = YES;
    vc.isNurse = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YES : NO;
    
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        [self loadNetworkData];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)toGuideNurseWorkerJigouAction:(id)sender {

    YJYNurseWorkerController *vc = [YJYNurseWorkerController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.time = self.rsp.orderVo.serviceTime;
    vc.nurseWorkType = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YJYNurseWorkTypeNurse : YJYNurseWorkTypeWorker;
    vc.isToSelect = YES;
    if ([self.guideButton.currentTitle isEqualToString:@"更换"]) {
        vc.isUpdateHg = self.rsp.isUpdateHg;
        
    }

//    vc.isNurse = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YES : NO;
    
    vc.didSelectBlock = ^(HgVO *hg) {
        
        [self loadNetworkData];

        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toGuideNurseWorkerAction:(id)sender {
    
    if (self.rsp.orderVo.insureType == 1) {
        [self toGuideNurseWorkerInsureAction:nil];
    }else {
        [self toGuideNurseWorkerJigouAction:nil];

        
    }
    
    
    
}
- (IBAction)toChooseBedAction:(id)sender {
    
    if (self.rsp.orderVo.status == -1) {
        return;
    }
  
    YJYEditController *vc = [YJYEditController instanceWithStoryBoard];
    vc.originString = self.bedNoLabel.text;
    vc.didEditBlock = ^(NSString *text) {
        UpdateOrderServeReq *req = [UpdateOrderServeReq new];
        req.orderId = self.rsp.orderVo.orderId;
        req.bedNo = text;
        [YJYNetworkManager requestWithUrlString:SAASAPPUpdateOrderServe message:req controller:self command:APP_COMMAND_SaasappupdateOrderServe success:^(id response) {
            
            [self loadNetworkData];
            
        } failure:^(NSError *error) {
            
        }];
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toChooseTodayBedAction:(UIButton *)sender {
    
    if (self.rsp.orderVo.status == -1) {
        return;
    }
    

    
    if (sender.tag == 1) {
        //昨天陪人床
        
        if (!self.rsp.isUpdateYesterday) {
            [UIAlertController showAlertInViewController:self withTitle:@"上午12:00之后不能修改" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
            }];
            return;
        }
        
    }else if (!self.rsp.isAddYesterday) {
        
        if ([self judgeDayAndNightWithStart:@"00:00" End:@"12:00"]) {
            [UIAlertController showAlertInViewController:self withTitle:@"上午12:00之前不能修改" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
            }];
            return;
        }
    }
    
  
    
    YJYOrderDetailBedController *vc = [YJYOrderDetailBedController instanceWithStoryBoard];
    vc.orderId = self.rsp.orderVo.orderId;
    vc.isYesterday = (sender == self.chooseYesterdayBedButton);
    vc.didComfireBlock = ^{
        [self loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];

  
}

- (IBAction)toNightCareAction:(id)sender {

    YJYOrderNightCareController *vc = [YJYOrderNightCareController instanceWithStoryBoard];
    vc.orderId = self.rsp.orderVo.orderId;
    vc.didBackBlock = ^{
        [self loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toSwitch:(id)sender {
    
    [self toCheckFinishOrder:^{
        YJYBookBranchController *vc = [YJYBookBranchController instanceWithStoryBoard];
        vc.currentOrg = [OrgDistanceModel new];
        vc.orgId = self.rsp.orderVo.orgId;
        vc.orderId = self.rsp.orderVo.orderId;
        vc.isTranfer  =YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
   
}

- (IBAction)toSign:(id)sender {
    
    YJYOrderContractController *contractController = [YJYOrderContractController instanceWithStoryBoard];
    contractController.isReSign = self.isReSign;
    contractController.orderId = self.rsp.orderVo.orderId;
    contractController.urlString = [NSString stringWithFormat:@"%@?priceId=%@&branchId=%@",kUserKnowedURL,@(self.rsp.orderVo.priceId),self.rsp.orderVo.branchId > 0 ? @(self.rsp.orderVo.branchId) : @""];

    contractController.didSkipBlock = ^{
        
        [self loadNetworkData];
    };
    
    contractController.didDoneBlock = ^{
        
        [self loadNetworkData];
    };
    
    [self.navigationController pushViewController:contractController animated:YES];
}
- (void)toCheckFinishOrder:(CompleteNoneBlock)completeNoneBlock {
    
//    if (completeNoneBlock) {
//        completeNoneBlock();
//    }
//    return;

    
    [SYProgressHUD show];
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    req.orderId = self.rsp.orderVo.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCheckFinishOrder message:req controller:self command:APP_COMMAND_SaasappcheckFinishOrder success:^(id response) {
        [SYProgressHUD hide];

        CheckFinishOrderRsp *rsp = [CheckFinishOrderRsp parseFromData:response error:nil];
        /// 是否可以结束 true-可以 false-不可以

        if (!rsp.finishOrder) {
            [UIAlertController showAlertInViewController:self withTitle:rsp.msg message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
              
            }];
        }else {
            
            if (completeNoneBlock) {
                completeNoneBlock();
            }
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)toGetOrgNOOrderList {
    
    [SYProgressHUD show];
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.rsp.orderVo.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgNOOrderList message:req controller:self command:APP_COMMAND_SaasappgetOrgNoorderList success:^(id response) {
        
        GetOrgNOOrderListRsp *rsp = [GetOrgNOOrderListRsp parseFromData:response error:nil];
        /// 是否需要提示 1-不需要 2-需要

        if (rsp.status == 2) {
            [UIAlertController showAlertInViewController:self withTitle:@"该病人还有其他未结算的订单。" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
            }];
        }
        
        [self loadNetworkData];
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)toHandBedDetail:(id)sender {
    
    YJYHandBedDetailController *vc = [YJYHandBedDetailController instanceWithStoryBoard];
    vc.hangServiceDateListArray = [NSMutableArray array];
    vc.hangServiceDateListArray = self.rsp.hangServiceDateListArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toPeirenBed:(id)sender {

    //陪人床租借详情
    YJYPeirenDetailController *vc = [YJYPeirenDetailController instanceWithStoryBoard];
    vc.orderId = self.rsp.orderVo.orderId;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - helper

//判断现在是不是下午  yes
-(BOOL)judgeDayAndNightWithStart:(NSString *)startStr
                             End:(NSString *)end
{
    //获取当前时间
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    // strar 格式 "5:30"  end: "19:08"
    NSDate *start = [dateFormat dateFromString:startStr];
    NSDate *expire = [dateFormat dateFromString:end];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    
    return NO;
}


#pragma mark - UITableView


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        
    {
        [cell.superview bringSubviewToFront:cell];
        cell.contentView.superview.clipsToBounds = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    //history
    if (indexPath.row == YJYOrderDetailTypeCountTime) {
        
        //倒计时
        
        BOOL isCountDown = (self.rsp.orderVo.status == YJYOrderStateWaitPay &&
                            self.rsp.expire > 0);
                            
        return isCountDown ? 30 : 0;
        
        
    }else if (indexPath.row == YJYOrderDetailTypeServiceItem) {
        
        //服务项
        return [self.serviceItemsCell cellHeight];
        
    }else if (indexPath.row == YJYOrderDetailTypeOrderTime) {
        
        //服务时间
        return self.rsp.orderVo.orderStartTime.length > 0 ? 130 : 65;
        
    }else if (indexPath.row == YJYOrderDetailTypeHospitalNumber) {
        
        //住院号
        
        if (self.rsp.orderVo.orderType == 2) {
            return 0;
        }
        
        return [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor || [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker ? 70 : 0;
        
    }else if (indexPath.row == YJYOrderDetailTypeBedNo) {
        
        //服务时间
        return [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor  ||
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker ? 60 : 0;
        
    }else if (indexPath.row == YJYOrderDetailTypeYesterdayBedNo) {
        if (self.rsp.yesterdayPrcnum.length == 0 || self.rsp.orderVo.status != YJYOrderStateServing) {
            H = 0;
        }
//        H = 0;

        
    }else if (indexPath.row == YJYOrderDetailTypeTodayBedNo) {
        
        return (self.rsp.isNumberPrc == 0  && self.rsp.orderVo.status > YJYOrderStateWaitServe) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;

        
    }else if (indexPath.row == YJYOrderDetailTypeNightNum) {
        
//         && (self.rsp.orderVo.status == YJYOrderStateServing || self.rsp.orderVo.status == YJYOrderStateWaitPayOff)
        //服务时间
        return (self.rsp.isNumberNight == 0 && self.rsp.orderVo.status > YJYOrderStateWaitServe) ? 60 : 0;
        
    }else if (indexPath.row == YJYOrderDetailTypeHangingBedDays) {
        if (self.rsp.hangServiceDateListArray_Count == 0){
            H = 0;

        }
    }else if (indexPath.row >= YJYOrderDetailTypeWorkerPay &&
              indexPath.row <= YJYOrderDetailTypeTakePeopleBed) {
        
        if (self.rsp.orderVo.status < YJYOrderStateServing) {
            return 0;
        }else {
            
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];

        }
  
    }else if (indexPath.row == YJYOrderDetailTypeServiceLocation) {
        
       
        
        //地址
         NSString *orgName = [NSString stringWithFormat:@"%@\n%@",self.rsp.orderVo.hospital,self.rsp.orderVo.branch];

        NSString *address = self.rsp.orderVo.orderType == 1 ? orgName : self.rsp.orderVo.locationMinute;

        //取消
        if ([self.rsp.orderVo.statusStr isEqualToString:@"已取消"]) {
           address = self.rsp.orderVo.location;
            
        }
        CGFloat addressWidth = self.tableView.frame.size.width - (35 + 17);
        
        CGFloat markExtraHeight = [address boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height - 17;
        
        return 60 + markExtraHeight;
        
        
    }else if (indexPath.row >= YJYOrderDetailTypePayDetail && indexPath.row <= YJYOrderDetailTypePrePay) {
        
        //待付款
      
                
        return self.rsp.orderVo.status == YJYOrderStateWaitPay ? 50 : 0;
        
    }else if (indexPath.row == YJYOrderDetailTypeDoorban){
        
        return self.rsp.orderVo.extraFee.length > 0 && self.rsp.orderVo.status == YJYOrderStateWaitPay ? 50 : 0;
    
    }else if (indexPath.row == YJYOrderDetailTypeNurseServices) {
        
        //待结算
        
        BOOL isWaitPayOffAndNurse  = (self.rsp.insureItemArray.count > 0);
        
        return isWaitPayOffAndNurse ? [self.itemDetailCell cellHeight] : 0;
        
    }else if(indexPath.row >= YJYOrderDetailTypeTotoalPay && indexPath.row <= YJYOrderDetailTypeButieYue){
        
      
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse ||
            [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ||
             [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker ||
            self.rsp.orderVo.status == YJYOrderStateWaitPay ||
            self.rsp.orderVo.status == YJYOrderStateCancel) {
            
            
            return 0;
        }else {
        
            if (indexPath.row == YJYOrderDetailTypeButieYue) {
                return self.rsp.orderVo.insureType == 1 ? 60 : 0;
            }
            return 60;

        }

    }else if (indexPath.row == YJYOrderDetailTypeAddJust) {
        
        //附加服务调整
        
        if ([self.rsp.orderVo.reviseFee floatValue] == 0) {
            return 0;
        }
        
        return (self.rsp.orderVo.status >= YJYOrderStateWaitPayOff || self.rsp.orderVo.status <= YJYOrderStateDone) ? 216 : 0;
        
    }else if (indexPath.row == YJYOrderDetailTypeDaily) {
        
        //督导健康经理 //明细 //待结算

        BOOL isWaitPayOffAndLeader  = (self.rsp.orderItemArray.count > 0);
        
//        return 0;
        return isWaitPayOffAndLeader ? [self.dailyDetailsCell cellHeight] : 0;
        
    }
    return H;


}

@end

#pragma mark - YJYOrderDetailController
@interface YJYOrderDetailController ()

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewHConstraint;


@property (strong, nonatomic) YJYOrderDetailContentController *contentVC;
@property (strong, nonatomic) NSArray <OrderMenuItem *>*menuItem;
@property (strong, nonatomic) NSMutableArray *buttonViews;
@end

@implementation YJYOrderDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderDetailController *)[UIStoryboard storyboardWithName:@"YJYOrderDetail" viewControllerIdentifier:NSStringFromClass(self)];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttonViews = [NSMutableArray array];
    
    if (self.fromCreate || self.isToRoot) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];
        //[UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(backAction)];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderDetailContentController"]) {
        
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYOrderDetailContentController *)segue.destinationViewController;
        if (!self.orderId) {
            self.orderId = self.orderListVO.orderId;
        }
        
        if (self.orderListVO.status == YJYOrderStateCancel) {
            self.orderId = nil;
            self.contentVC.orderListVO = self.orderListVO;
        }
        self.contentVC.orderId = self.orderId;
        self.contentVC.didLoadBlock = ^{
            
            [weakSelf reloadToolView];
            
        };
        
        self.contentVC.didCancelBlock = ^{
            [weakSelf toCloseCancelOrderAction];

        };
        
        self.contentVC.isReSign = self.isReSign;
        
    }
}
//工具栏
- (void)reloadToolView {
    
    //先清空
    for (UIView *subView in self.buttonViews) {
        [subView removeFromSuperview];
    }
    self.buttonViews = [NSMutableArray array];
    
 
    ///-1-已取消 0-待付款预交金,1-待派工,2-待服务,3-服务中,4-服务完成,5-待评价,6-已完成
    
 
    
    NSArray *menuItems = [[YJYRoleManager sharedInstance] orderMenuItemsWithOrderInfoRsp:self.contentVC.rsp];
    [self reloadButtonsWithArray:menuItems];

    self.toolViewHConstraint.constant = (menuItems.count > 0) ? 60 : 0;
    self.toolView.hidden = (menuItems.count == 0);
    
    
}

//工具栏按钮
- (void)reloadButtonsWithArray:(NSArray *)serviceItems {

    CGFloat width = self.toolView.frame.size.width/serviceItems.count+1;

    for (NSInteger i = 0; i < serviceItems.count; i ++) {
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(i * width, 0, width, self.toolView.frame.size.height)];
        
        OrderMenuItem *orderMenuItem = serviceItems[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonView.bounds;
        [button setTitle:orderMenuItem.title forState:0];
        [button addTarget:self action:NSSelectorFromString(orderMenuItem.func) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.minimumScaleFactor = 0.2;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitleColor:[UIColor whiteColor] forState:0];
        
        [buttonView addSubview:button];
        
        
        //line
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width - 1, 15, 1, button.frame.size.height - 30)];
        line.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.3];
        line.alpha = 0.3;
        [buttonView addSubview:line];
        
        [self.toolView addSubview:buttonView];
        
        [self.buttonViews addObject:buttonView];

    }
}



#pragma mark - Action

// 关闭页面
- (void)close {
    
    
    
    [SYProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SYProgressHUD hide];
        [self.navigationController.tabBarController setSelectedIndex:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (self.didDismiss) {
            self.didDismiss();
        }
    });
    
    
    
}



//变更
- (void)toModifyAction {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        if (self.contentVC.rsp.orderVo.serviceType == YJYWorkerServiceTypeOne) {
            [self workToPushRequestWithJpushType:2];

        }else {
            [self toOrderModifyService];


        }


        
    }else if([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor){
  
        if (self.contentVC.rsp.orderVo.status == YJYOrderStateServing) {
            YJYPaymentAdjustController *vc = [YJYPaymentAdjustController instanceWithStoryBoard];
            vc.orderId = self.contentVC.rsp.orderVo.orderId;
            vc.jumpType = YJYOrderPaymentAdjustTypeServingModify;
            vc.isAdjustPage  = YES;
            vc.workerServiceType = self.contentVC.rsp.orderVo.serviceType;

            vc.didDismissBlock = ^{
                
                [self toOrderModifyService];
                
            };
            vc.didDoneBlock = ^{
                [self.contentVC loadNetworkData];
                
            };
            vc.didToListBlock = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }else {
            
            [self toOrderModifyService];

        }
        
        
        
    }
    
}

//变更服务
- (void)toOrderModifyService {
    
    YJYOrderModifyServiceController *vc = [YJYOrderModifyServiceController instanceWithStoryBoard];
    vc.order = self.contentVC.rsp.orderVo;
    vc.showPhone =  self.contentVC.rsp.showPhone;
    vc.priceName = [NSArray arrayWithArray:self.contentVC.rsp.priceNameArray];
    [YJYSettingManager sharedInstance].userId = self.contentVC.rsp.orderVo.userId;
    vc.didDoneBlock = ^{
        
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

//协助收款
- (void)toHelpGatheringAction {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        
        [self workToPushRequestWithJpushType:3];
        
    }
}
//增加服务
- (void)toAddServiceAction {
    
  
    YJYOrderAddServicesController *vc = [YJYOrderAddServicesController instanceWithStoryBoard];
    vc.title = @"添加长护险医疗服务";
    vc.orderId = self.contentVC.rsp.orderVo.orderId;
    vc.affirmTime = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    vc.isShowCalendar = YES;
    vc.isInsure = YES;
    
  
    
    
    __weak typeof(self) weakSelf = self;
    vc.didEditServicesBlock = ^{
        
        [weakSelf.contentVC reloadAllData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


//关闭

- (void)toCloseCancelOrderAction {
    
    NSString *title = @"是否确定关闭订单？";
//    if (!self.contentVC.rsp.dudaoChargeConfig) {
//        title = @"是否确定关闭订单？\n（如需退款请提示客户移步至收费处）";
//    }
    
    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [SYProgressHUD show];
            GetOrderReq *req = [GetOrderReq new];
            req.orderId = self.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPCancelOrder message:req controller:self command:APP_COMMAND_SaasappcancelOrder success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"关闭完成"];
                //有权限
                
                if (self.contentVC.rsp.dudaoChargeConfig) {
                    
                    GetOrderInfoReq *req = [GetOrderInfoReq new];
                    req.orderId = self.contentVC.rsp.orderVo.orderId;
                    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderInfo message:req controller:self command:APP_COMMAND_SaasappgetOrderInfo success:^(id response) {
                        
                        
                        GetOrderInfoRsp *rsp = [GetOrderInfoRsp parseFromData:response error:nil];
                        
                        self.contentVC.rsp = rsp;
                        [self.contentVC reloadRsp];
                        [self.contentVC reloadAllData];
                        
                        if (self.contentVC.rsp.needRefundPrepay || self.contentVC.rsp.needRefundExtra) {
                            
                            [self toRefundPrepayAction];
                        }
                        
                        
                    } failure:^(NSError *error) {
                        
                        [self.contentVC reloadErrorData];
                    }];
                }else {
                    
                    [self.contentVC loadNetworkData];

                }
                
                
                
                
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
  
    
}
//开启
- (void)toStartUpOrderAction{

    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker && self.contentVC.rsp.orderVo.serviceType == YJYWorkerServiceTypeOne) {
        [self workToPushRequestWithJpushType:5];
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        [self toStartUpOrderVC];
   }else {
        
        if (self.contentVC.rsp.canStartService) {
            [self toGetOrderReceptionTime];

        }else {
            
            [UIAlertController showAlertInViewController:self withTitle:@"检测到用户交了门禁卡押金但未绑卡,请提示用户先到收费处绑定门禁卡！" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
              
                
            }];
        }
        
    }
    
    
}

- (void)toGetOrderReceptionTime {

    [SYProgressHUD show];
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    req.orderId = self.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderReceptionTime message:req controller:self command:APP_COMMAND_SaasappgetOrderReceptionTime success:^(id response) {
        
        [SYProgressHUD hide];

        GetOrderReceptionTimeRsp *rsp = [GetOrderReceptionTimeRsp parseFromData:response error:nil];
        if (rsp.receptionType == 1) {
            
            [UIAlertController showAlertInViewController:self withTitle:@"未查询到病人住院日期，是否确定开启服务？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [self toStartUpForDouBaoWorkerWithRsp:rsp dateType:2];
                }
                
            }];
            
        }else if (rsp.receptionType == 2) {
            
            [UIAlertController showAlertInViewController:self withTitle:@"是否确定开启订单？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [self toStartUpForDouBaoWorkerWithRsp:rsp dateType:2];
                }
                
            }];
            
        }else if (rsp.receptionType == 3) {
            
            NSString *currentDate = [NSString stringWithFormat:@"当前日期:%@",rsp.today];
            NSString *jiezhenDate = [NSString stringWithFormat:@"接诊日期:%@",rsp.receptionDay];
            
            YJYInsureTimeChooseView *vc = [YJYInsureTimeChooseView instancetypeWithXIB];
            vc.frame = [UIApplication sharedApplication].keyWindow.bounds;
            vc.today = currentDate;
            vc.receptionDay = jiezhenDate;
            vc.didComfireBlock = ^(id result) {
                
                NSInteger buttonIndex = [result integerValue];
                
                if (buttonIndex == 1) {
                    [self toStartUpForDouBaoWorkerWithRsp:rsp dateType:1];
                }else if (buttonIndex == 2) {
                    [self toStartUpForDouBaoWorkerWithRsp:rsp dateType:2];
                    
                }
            };
            [vc showInView:nil];
            
//            [UIAlertController showAlertInViewController:self withTitle:@"请选择计费起点" message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:currentDate otherButtonTitles:@[jiezhenDate] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//
//
//
//            }];
            
        }else {
            [UIAlertController showAlertInViewController:self withTitle:@"未查询到病人住院日期，是否确定开启服务？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [self toStartUpForDouBaoWorkerWithRsp:rsp dateType:2];
                }
                
            }];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
//
}

- (void)toStartUpForDouBaoWorkerWithRsp:(GetOrderReceptionTimeRsp *)getOrderReceptionTimeRsp dateType:(NSInteger)dataType{
    
    [SYProgressHUD show];
    
    StartOrgOrderReq *req = [StartOrgOrderReq new];
    req.orderId = self.orderId;
    req.receptionType = getOrderReceptionTimeRsp.receptionType;
    if (getOrderReceptionTimeRsp.receptionType == 3) {
        req.dateType = (uint32_t)dataType;
    }
    if (getOrderReceptionTimeRsp.receptionType == 2 || getOrderReceptionTimeRsp.receptionType == 3) {
        req.receptionTime = getOrderReceptionTimeRsp.receptionTime;

    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPStartOrgOrder message:req controller:self command:APP_COMMAND_SaasappstartOrgOrder success:^(id response) {
        
        
        [self.contentVC loadNetworkData];
        
        [SYProgressHUD hide];
        
        
    } failure:^(NSError *error) {
        
    }];

}
- (void)toStartUpOrderVC {
    

    

    [UIAlertController showAlertInViewController:self withTitle:@"开启服务后，将开始计费，是否开启？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [SYProgressHUD show];

            SaveOrUpdateOrderReq *req = [SaveOrUpdateOrderReq new];
            req.orderId = self.orderId;
            req.operationType = 1;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateOrder message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateOrder success:^(id response) {
                
                
                [self.contentVC loadNetworkData];

                [SYProgressHUD hide];
                
                
            } failure:^(NSError *error) {
                
            }];
        
        }
        
    }];
}

//指派护工
- (void)toGuideAction{
    
    [self.contentVC toGuideNurseWorkerAction:nil];
}

//跳过评估
- (void)toSkipReviewAction {
    
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"确定跳过评估？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            SaveOrderItemReq *req = [SaveOrderItemReq new];
            req.orderId = self.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPSkipAssessOrder message:req controller:self command:APP_COMMAND_SaasappskipAssessOrder success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
    
    
}
//现金收款

- (void)toReceivedCashAction {
    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"线上收款" otherButtonTitles:@[@"现金收款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            YJYOrderQRController *vc = [YJYOrderQRController instanceWithStoryBoard];
            vc.orderId = self.contentVC.rsp.orderVo.orderId;
            vc.URLType = 1;
            vc.didDoneBlock = ^{
                [self.contentVC loadNetworkData];

            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (buttonIndex == 2){
         
            [UIAlertController showAlertInViewController:self withTitle:@"确定已现金收取预付款？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [SYProgressHUD show];
                    
                    DoPayReq *req = [DoPayReq new];
                    req.operation = @"PAY_PREAMOUNT";
                    req.payType = 5;
                    req.orderId = self.orderId;
                    
                    [YJYNetworkManager requestWithUrlString:SAASDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
                        
                        [SYProgressHUD hide];
                        [self.contentVC loadNetworkData];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                
            }];
        }
        
    }];

   
}
- (void)toHgReceivedMoneyAction{
    
    /// 判断护工是否需要收款 true-是 false-否

    if (self.contentVC.rsp.isHgPay == NO) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否通知督导收款" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [SYProgressHUD show];
                
                OrderJPushReq *req = [OrderJPushReq new];
                req.orderId = self.contentVC.rsp.orderVo.orderId;
                req.jpushType = 3;
                [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
                    
                    [SYProgressHUD showSuccessText:@"发送成功"];
                    
                } failure:^(NSError *error) {
                    
                }];
                //                [self workToPushRequestWithJpushType:3];
                
            }
            
        }];
        return;
    }else {
        
        [self toPayOffAction];
    }
    
}

//收款
- (void)toReceivedMoneyAction{
    

   
    
    
    NSMutableArray *settDateArray = [self toGetSettDateArray];
    if (settDateArray.count == 0) {
        return;
    }
    
    YJYPaymentAdjustController *vc = [YJYPaymentAdjustController instanceWithStoryBoard];
    vc.orderId = self.contentVC.rsp.orderVo.orderId;
    vc.monthsArray = settDateArray;
    vc.isAdjustPage  = YES;
    vc.workerServiceType = self.contentVC.rsp.orderVo.serviceType;
    vc.didDismissBlock = ^{
        
        
        
        YJYOrderPayOffController *pvc = [YJYOrderPayOffController instanceWithStoryBoard];
        pvc.didDoneBlock = ^{
            [self.contentVC loadNetworkData];
            
        };
        pvc.orderId = self.orderId;
        pvc.settDateArray = settDateArray;
        pvc.orderInfoRsp = self.contentVC.rsp;
        [self.navigationController pushViewController:pvc animated:YES];
    
        
    };
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
        
    };
    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
  
    
}

//查看结算单
- (void)toCheckPayOffAction {
    
    NSMutableArray *settDateArray = [NSMutableArray array];
    //[self.contentVC.dailyDetailsCell selectedOrderItemArray]
    for (SettlementVO *settle in self.contentVC.rsp.orderItemArray) {
        
        if (settle.payState == 0) {
            [settDateArray addObject:settle.settleDate];
            
        }
    }
    if (settDateArray.count == 0) {
        return;
    }
    
    YJYPaymentAdjustController *vc = [YJYPaymentAdjustController instanceWithStoryBoard];
    vc.orderId = self.contentVC.rsp.orderVo.orderId;
    vc.monthsArray = settDateArray;
    vc.jumpType = YJYOrderPaymentAdjustTypePayoffPaymentCheck;
    vc.workerServiceType = self.contentVC.rsp.orderVo.serviceType;
    vc.didDismissBlock = ^{
        
        [self.contentVC loadNetworkData];

       
        
    };
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
        
    };
    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

   
    
}
//结算收款
- (void)toPayOffAction {
//
//    [self toPayOffSingleOrderAction];
//    return;
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
       
        [self toPayOffSingleOrderAction];
        return;
    }
    
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    req.orderId = self.contentVC.rsp.orderVo.orderId;
    [YJYNetworkManager requestWithUrlString:SAASAPPCheckOrderSettle message:req controller:self command:APP_COMMAND_SaasappcheckOrderSettle success:^(id response) {
        
        /// 当前订单结算类型 0-非中肿订单或无其他状态的订单（可直接去单独结算） 1-有其他状态（除待结算）的订单 2-只有其他待结算的订单

        CheckOrderSettleRsp *rsp = [CheckOrderSettleRsp parseFromData:response error:nil];
        if (rsp.settleType == 0) {
            
            [self toPayOffSingleOrderAction];
            
        }else if(rsp.settleType == 1) {
            [UIAlertController showAlertInViewController:self withTitle:@"温馨提示" message:rsp.msg alertControllerStyle:1 cancelButtonTitle:@"只结算当前订单" destructiveButtonTitle:@"稍后结算所有订单" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 0) {
                    [self toPayOffSingleOrderAction];

                }
                return;
                
            }];
        }else if (rsp.settleType == 2) {
            
            
            
            [UIAlertController showAlertInViewController:self withTitle:@"温馨提示" message:rsp.msg alertControllerStyle:1 cancelButtonTitle:@"只结算当前订单" destructiveButtonTitle:@"结算所有订单" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    [self toPayOffAllOrderAction];
                }else {
                    [self toPayOffSingleOrderAction];

                }
                
            }];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
 
    
   
    
}
- (void)toPayOffAllOrderAction {
    YJYPayOffDetailController *vc = [YJYPayOffDetailController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (void)toPayOffSingleOrderAction {
    
    NSMutableArray *settDateArray = [self toGetSettDateArray];
    if (settDateArray.count == 0) {
        return;
    }
    
    YJYOrderPayOffController *vc = [YJYOrderPayOffController instanceWithStoryBoard];
    vc.didDoneBlock = ^{
        [self.contentVC toGetOrgNOOrderList];
        
    };
    vc.orderId = self.orderId;
    vc.settDateArray = settDateArray;
    vc.isModifyPayOff = NO;
    vc.orderInfoRsp = self.contentVC.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}
//结束订单
- (void)toFinishOrderAction{
    
    [self.contentVC toCheckFinishOrder:^{
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
            [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager ||
            ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) ) {
                
                //正常结算
                
                [UIAlertController showAlertInViewController:self withTitle:@"一旦结束订单，将会停止计费，是否结束？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        
                        [SYProgressHUD show];
                        SaveOrUpdateOrderReq *req = [SaveOrUpdateOrderReq new];
                        req.orderId = self.orderId;
                        req.operationType = 2;
                        
                        [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateOrder message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateOrder success:^(id response) {
                            
                            [SYProgressHUD hide];
                            [self.contentVC loadNetworkData];
                            
                            if ( [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker &&
                                self.contentVC.rsp.orderVo.serviceType != YJYWorkerServiceTypeMany) {
                                return;
                            }
                            
                            
                            YJYPaymentAdjustController *vc = [YJYPaymentAdjustController instanceWithStoryBoard];
                            vc.orderId = self.contentVC.rsp.orderVo.orderId;
                            vc.jumpType = YJYOrderPaymentAdjustTypeServingPayoffEnding;
//                            vc.isAdjustPage = YES;
                            vc.workerServiceType = self.contentVC.rsp.orderVo.serviceType;
                            vc.didDismissBlock = ^{
                                
                                [SYProgressHUD hide];
                                [self.contentVC loadNetworkData];
                                
                            };
                            vc.didDoneBlock = ^{
                                [self.contentVC loadNetworkData];
                                
                            };
                            YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:vc];
                            [self presentViewController:nav animated:YES completion:nil];
                            
                        } failure:^(NSError *error) {
                            
                        }];
                    }
                    
                }];
                
                
//            }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker &&
//                      self.contentVC.rsp.orderVo.serviceType != YJYWorkerServiceTypeMany) {
//
//
//
//                [self workToPushRequestWithJpushType:1];
//
                
            }
    }];
    
    
    
    
}

// 预付款充值

- (void)toChargePrePayAction {

    YJYOrderQRController *vc = [YJYOrderQRController instanceWithStoryBoard];
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
    };
    vc.orderId = self.contentVC.rsp.orderVo.orderId;
    vc.URLType = 3;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"线上收款" otherButtonTitles:@[@"现金收款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//
//        if (buttonIndex == 1) {
//
//        }else if (buttonIndex == 2){
//
//            YJYOrderPrePayChargeController *vc = [YJYOrderPrePayChargeController instanceWithStoryBoard];
//            vc.orderId =  self.contentVC.rsp.orderVo.orderId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//
//    }];
  
    
}

- (void)toRefundPrepayAction {
    
    YJYOrderRefundController *vc = [YJYOrderRefundController instanceWithStoryBoard];
    vc.orderVo = self.contentVC.rsp.orderVo;
    vc.isDudao = self.contentVC.rsp.dudaoChargeConfig;
    vc.orderInfoRsp = self.contentVC.rsp;
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)toAgainOrderAction {
    

    
    GetUserInfoByOrgNOReq *req = [GetUserInfoByOrgNOReq new];
    req.orgNo = self.contentVC.rsp.orderVo.orgNo;
    req.orgId = self.contentVC.rsp.orderVo.orgId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserInfoByOrgNO message:req controller:self command:APP_COMMAND_SaasappgetUserInfoByOrgNo success:^(id response) {
        
        GetUserInfoByOrgNORsp *rsp = [GetUserInfoByOrgNORsp parseFromData:response error:nil];
        
        if (rsp.rspFlag == 1) {
            
            [UIAlertController showAlertInViewController:self withTitle:@"是否再下一张订单？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    YJYOrderCreateHospitalController *vc = [YJYOrderCreateHospitalController instanceWithStoryBoard];
                    vc.orderVo = self.contentVC.rsp.orderVo;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }];
            
        }else if (rsp.rspFlag != 0) {
            
            
            [UIAlertController showAlertInViewController:self withTitle:rsp.errorMsg message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                
            }];
        }else if (rsp.bra.inStatus == 1) {
            
            
            [UIAlertController showAlertInViewController:self withTitle:@"请提示病人先办理入院。" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                
            }];
            
        }else {
            
            [UIAlertController showAlertInViewController:self withTitle:@"是否再下一张订单？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    YJYOrderCreateHospitalController *vc = [YJYOrderCreateHospitalController instanceWithStoryBoard];
                    vc.orderVo = self.contentVC.rsp.orderVo;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
  

}
#pragma mark - helper


- (NSMutableArray *)toGetSettDateArray {

    //1.有需要收款的吗
    
    BOOL needPaid = NO;
    BOOL chooseAll = NO;
    
    //遍历
    for (SettlementVO *settle in self.contentVC.rsp.orderItemArray) {
        
        if (settle.needPay > 0 || settle.payState == 0) {
            needPaid = YES;
            break;
        }
    }
    
    if (([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker || [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) &&
        self.contentVC.rsp.orderVo.orderType == 1 &&
        self.contentVC.rsp.orderVo.status == YJYOrderStateWaitPayOff) {
        
       chooseAll = YES;
        
    }
    
    //NO
    if (!needPaid) {
        [UIAlertController showAlertInViewController:self withTitle:@"当前暂无可收款项" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        return nil;
    }
    
    //2.去勾选
    if (!chooseAll) {
        if ([self.contentVC.dailyDetailsCell selectedOrderItemArray].count <= 0) {
            [UIAlertController showAlertInViewController:self withTitle:@"请勾选收款项" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
            return nil; 
        }
    }
    
    

    NSMutableArray *settDateArray = [NSMutableArray array];
    NSArray *orderItemArray = self.contentVC.rsp.orderItemArray;
    if (self.contentVC.rsp.orderVo.status == YJYOrderStateServing) {
        orderItemArray = [self.contentVC.dailyDetailsCell selectedOrderItemArray];
    }
    for (SettlementVO *settle in orderItemArray) {
        if (settle.payState == 0) {
        
            [settDateArray addObject:settle.settleDate];
        }
        
    }
    
    return settDateArray;
}


///类型：1-结束订单 2-变更服务 3-协助收款

- (void)workToPushRequestWithJpushType:(uint32_t)jpushType {

    
    NSString *leaderTitle = self.contentVC.rsp.orderVo.orderType == 1 ? @"督导" : @"健康经理";
    ///类型：1-结束订单 2-变更服务 3-协助收款 4-长护险订单申请结束订单 5-请求开启服务通知

    NSString *actionTitle = @"结束订单";
    if (jpushType == 2) {
        actionTitle = @"变更订单";
    }else if (jpushType == 3) {
        actionTitle = @"协助收款";
    }else if (jpushType == 5) {
        actionTitle = @"开启服务";
    }

    
    NSString *des = [NSString stringWithFormat:@"是否向%@发送%@请求",leaderTitle,actionTitle];
    
    
    [UIAlertController showAlertInViewController:self withTitle:des message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            OrderJPushReq *req = [OrderJPushReq new];
            req.orderId = self.contentVC.rsp.orderVo.orderId;
            req.jpushType = jpushType;
            [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"发送成功"];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
    
}

- (void)toComfireService {
    
    if (!self.contentVC.rsp.isfinish) {
        
        
        [UIAlertController showAlertInViewController:self withTitle:@"你还有未确认的服务" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        return;
    }
    YJYPayOffComfireAddController *vc = [YJYPayOffComfireAddController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.affirmTime = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    vc.orderState = self.contentVC.rsp.orderVo.status;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
