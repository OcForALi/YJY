//
//  YJYOrderDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderDetailController.h"
#import "YJYOrderReviewController.h"
#import "YJYOrderPayOffListController.h"
#import "YJYWeakTimerManager.h"
#import "YJYOrderSettleController.h"
#import "YJYSuggestionController.h"

typedef void(^OrderDetailDidLoadedBlock)(GetOrderPayDetailRsp *payDetailRsp);
typedef NS_ENUM(NSInteger, OrderDetailType) {
    
    OrderDetailTypePackage,
    OrderDetailTypeOrderID ,
    OrderDetailTypeContact ,
    OrderDetailTypePhone,
    OrderDetailTypeLocation,
    OrderDetailTypeBookTime,
    OrderDetailTypeBookBeginTime,
    OrderDetailTypeService,
    OrderDetailTypeHospitalNumber,
    OrderDetailTypePayDesc,
    OrderDetailTypePrePay,
    OrderDetailTypeDoorPay,
    OrderDetailTypeTotal,
    OrderDetailTypePayWayDesc,
    OrderDetailTypePocket,
    OrderDetailTypeWechat,
    OrderDetailTypeAlipay,
    OrderDetailTypeTip,

};

@interface YJYOrderDetailContentController : YJYTableViewController

//package
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLevelTimeLabel;


//orderid

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderBeginLabel;

//info
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;


//paydetail
@property (weak, nonatomic) IBOutlet UILabel *prePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;

//feedback

@property (weak, nonatomic) IBOutlet UILabel *costTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *preCostLabel;


//pay method

@property (weak, nonatomic) IBOutlet UIButton *alipayTinyButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatTinyButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@property (weak, nonatomic) IBOutlet UIButton *pocketButton;
@property (weak, nonatomic) IBOutlet UIButton *pocketTinyButton;
@property (weak, nonatomic) IBOutlet UIImageView *pocketIcon;
@property (weak, nonatomic) IBOutlet UILabel *pocketLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

//outside
@property (strong, nonatomic)  UIButton *cancelButton;
@property (strong, nonatomic)  UIButton *actionButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLabelYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneIconXConstraint;

//data

@property (strong, nonatomic) GetOrderPayDetailRsp *orderDetailRsp;
@property (strong, nonatomic) NSString *orderID;
@property (assign, nonatomic) PayType payType;
@property (assign, nonatomic) BOOL isNeedPay;
@property (assign, nonatomic) NSTimeInterval currentCountDown;

@property (assign, nonatomic) BOOL isShowPocket;
@property (assign, nonatomic) BOOL isShowWeChat;
@property (assign, nonatomic) BOOL isShowAlipay;

#define kOrderDetailContentListCount 15

@property (weak, nonatomic) IBOutlet UILabel *payTipLabel;
//block

@property (copy, nonatomic) OrderDetailDidLoadedBlock didLoadedBlock;

//timer
@property (nonatomic, strong)NSTimer *timer;




@end

@implementation YJYOrderDetailContentController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self loadConfigure];

    
    //ui
    
    self.balanceLabel.layer.cornerRadius = self.balanceLabel.frame.size.height/2;
    self.balanceLabel.layer.borderColor = self.balanceLabel.textColor.CGColor;
    self.balanceLabel.layer.borderWidth = 1;
    
    //data
    
    [self payAction:self.pocketButton];
    
    //load
   
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        [weakSelf loadNetWorkData];
        
    }];
    if (IS_IPHONE_5) {
        self.phoneIconXConstraint.constant = 300;
    }
    

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetWorkData];

}
- (void)loadNetWorkData {
    
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.orderID;
    [SYProgressHUD show];
    
    
    [YJYNetworkManager requestWithUrlString:APPPrePayAmountDetail message:req controller:self command:APP_COMMAND_AppprePayAmountDetail success:^(id response) {
        
        GetOrderPayDetailRsp *rsp = [GetOrderPayDetailRsp parseFromData:response error:nil];
        
        self.orderDetailRsp = rsp;
        if (self.didLoadedBlock) {
            self.didLoadedBlock(self.orderDetailRsp);
        }
        
        [self reloadAllData];
        [self setupOrder];
        [self reloadAllData];

        
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];

}

- (void)loadWithPurse {
    
    
//
    [YJYNetworkManager requestWithUrlString:APPGetPayType message:nil controller:self command:APP_COMMAND_GetPayType success:^(id response) {

        

    } failure:^(NSError *error) {

    }];
    
    self.balanceLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    if (self.orderDetailRsp.usePurse) {
        self.balanceLabel.text = [NSString stringWithFormat:@" 余额 : %@元  ",self.orderDetailRsp.purse];
        [self.balanceLabel sizeToFit];
        self.pocketLabel.textColor = APPDarkCOLOR;
        self.pocketButton.userInteractionEnabled = YES;
        
    }else {
        self.balanceLabel.text = @" 钱包余额不足  ";
        [self.balanceLabel sizeToFit];
        self.pocketIcon.image = [UIImage imageNamed:@"pay_purse_unable_icon"];
        self.pocketLabel.textColor = APPGrayCOLOR;
        self.pocketButton.userInteractionEnabled = NO;
        if (self.payType == 6) {
            [self payAction:self.wechatButton];
        }
    }
    [self.tableView reloadData];

}


- (void)loadConfigure {
    
    [YJYNetworkManager requestWithUrlString:APPGetPayType message:nil controller:nil command:APP_COMMAND_GetPayType success:^(id response) {
        
        GetPayTypeRsp *rsp = [GetPayTypeRsp parseFromData:response error:nil];
        [YJYSettingManager sharedInstance].payTypeListArray = rsp.payTypeListArray;
        [self loadPayTypeHidden];

    } failure:^(NSError *error) {
        
    }];
}

- (void)setupOrder {
    
    
    OrderVO *order = self.orderDetailRsp.order;
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号: %@",order.orderId];

    //hidden
    
    
    self.cancelButton.hidden = (order.status != OrderStatus_WaitPayPrefee &&
                                order.status != OrderStatus_WaitAppraise &&
                                order.status != OrderStatus_OrderComplete);
    
    if (order.status == OrderStatus_WaitAppraise ||
        order.status == OrderStatus_OrderComplete ) {
        [self.cancelButton setTitle:@"查看明细" forState:0];
    }
    
    
    self.isNeedPay = ((self.orderDetailRsp.expire > 0 && order.status == OrderStatus_WaitPayPrefee));
    
    
    
    if ((self.orderDetailRsp.expire > 0 && order.status == OrderStatus_WaitPayPrefee)) {
        
        self.stateLabelYConstraint.constant = -10;
        self.packageLevelTimeLabel.hidden = NO;
        self.stateLabel.font = [UIFont systemFontOfSize:12];
        [self setupTimer];
    }else {
        self.stateLabelYConstraint.constant = 0;
        self.packageLevelTimeLabel.hidden = YES;
        self.stateLabel.font = [UIFont systemFontOfSize:15];
    }
    
    //status
    
    NSString *statusText;
    NSString *actionText;
    UIColor  *statusColor;
    
    if (order.status == OrderStatus_WaitPayPrefee) {
        
        statusText = @"待付款";
        actionText = @"去支付";
        statusColor = kWaitPayPrefeeColor;
        
        
    }else if (order.status == OrderStatus_WaitAssign) {
        
        
        statusText = @"待派工";
        actionText = @"电话催单";
        statusColor = kWaitAssignColor;
        
        
    }else if (order.status == OrderStatus_WaitService) {
        
        statusText = @"待服务";
        actionText = @"电话催单";
        statusColor = kWaitAssignColor;
        
        
    }else if (order.status == OrderStatus_ServiceIng) {
        
        
        statusText = @"服务中";
        actionText = @"去支付";
        statusColor = kServiceIngColor;
        
        
    }else if (order.status == OrderStatus_ServiceComplete) {
        statusText = @"待结算";
        actionText = @"去结算";
        statusColor = kWaitCheckoutColor;
        
        
    }else if (order.status == OrderStatus_WaitAppraise) {
        statusText = @"待服务";
        actionText = @"电话催单";
        statusColor = kWaitAppraiseColor;
        
        
        
    }else if (order.status == OrderStatus_OrderComplete) {
        statusText = @"已完成";
        actionText = @"查看评价";
        statusColor = kOrderCompleteColor;
        
    }
    self.stateLabel.textColor = statusColor;
    self.stateLabel.text = order.statusStr;
    
    if ((self.orderDetailRsp.expire < 0 && order.status == OrderStatus_WaitPayPrefee) || order.status == OrderStatus_Cancel) {
        self.cancelButton.hidden = YES;
        self.actionButton.hidden = YES;
        statusColor = APPGrayCOLOR;
    }
    
    //
    [self.actionButton setTitle:order.actionStr forState:0];
    self.actionButton.layer.borderColor = statusColor.CGColor;
    [self.actionButton setTitleColor:statusColor forState:0];
    
    if (order.status == OrderStatus_OrderComplete){
        self.stateLabel.textColor = APPGrayCOLOR;
        
    }
    
    //time
    
    self.orderTimeLabel.text = [order.serviceTime stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    
    self.orderBeginLabel.text = order.orderStartTime;
    
    self.orderStartTimeLabel.text = [NSString stringWithFormat:@"订单时间: %@",order.createTime];
    
    
    //address
    
    self.packageLabel.text = order.service;
    [self.packageLabel sizeToFit];

    self.beServiceLabel.text = order.kinsName;
    self.serviceLabel.text = order.serviceStaff;
    self.prePriceLabel.text = [NSString stringWithFormat:@"%@元",order.prepayAmount];
    self.priceLabel.text = self.orderDetailRsp.needPay;
    self.doorFeeLabel.text = [NSString stringWithFormat:@"%@元",self.orderDetailRsp.entranceFee];
    
    self.nameLabel.text = order.contactName;
    self.phoneLabel.text = order.contactPhone;
    
    if (order.orderType == 2) {
        
        self.addressLabel.attributedText = [order.locationMinute attributedStringWithLineSpacing:8];;
        [self.addressLabel sizeToFit];
        
    }else {
        
        NSString *des = [NSString stringWithFormat:@"%@ %@ %@ %@",order.hospital,order.branch,order.room,order.bed];
        self.addressLabel.attributedText = [des attributedStringWithLineSpacing:8];;
        [self.addressLabel sizeToFit];
        
        
    }
    self.hospitalNumberLabel.text = order.orgNo;
    
    //
    
    self.costTotalLabel.text = [NSString stringWithFormat:@"%.2元",[order.paidFee floatValue] + [order.needPay floatValue]];
    self.preCostLabel.text = [NSString stringWithFormat:@"%@元",order.preRealFee];
    self.payTipLabel.text = self.orderDetailRsp.payHint;
    
    [self loadWithPurse];
    
    
}
- (void)setupTimer {
    

    
    self.currentCountDown = self.orderDetailRsp.expire/1000;
    
    //(NSTimeInterval)fabs([startDate timeIntervalSinceDate:[NSDate date]]);
    
    self.timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
        
        
        if (_timer && self.currentCountDown == 0 ) {
            [_timer invalidate];
            _timer = nil;
            [SYProgressHUD showFailureText:@"超越预约时间"];
            [self loadNetWorkData];
            return;
        }
        
        self.currentCountDown -=1;
        
        NSInteger hours = (int)self.currentCountDown/60/60;
        NSInteger mins = (self.currentCountDown - (hours * 60 * 60))/60;
        NSInteger seconds = (int)self.currentCountDown%60;
        self.packageLevelTimeLabel.text =  [NSString stringWithFormat:@"剩余时间:%02d小时%02d分钟%02d秒",(int)hours,(int)mins,(int)seconds];

        
        
    } userInfo:@"fire" repeats:YES];
    
    [_timer fire];
}

#pragma mark - Pay



- (BOOL)isExistPayType:(PayType)payType {
    
    
    __block BOOL isExist = NO;
    [[YJYSettingManager sharedInstance].payTypeListArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
        
        if (payType == (PayType)value) {
            
            isExist = YES;
            *stop = YES;
        }
        
    }];
    
    return isExist;
}
- (void)loadPayTypeHidden {
    
    self.isShowPocket = [self isExistPayType:PayType_Account];
    self.isShowWeChat = ([self isExistPayType:PayType_WxApp]  || [self isExistPayType:PayType_BaofooWxapp]);
    self.isShowAlipay = ([self isExistPayType:PayType_AliZfb]  || [self isExistPayType:PayType_BaofooAliapp]);
}
- (IBAction)payAction:(UIButton *)sender {
  
    UIImage *selectImage = [UIImage imageNamed:@"pay_select_icon"];
    UIImage *unselectImage = [UIImage imageNamed:@"pay_unselect_icon"];

    
    [self.pocketTinyButton setImage:unselectImage forState:0];
    [self.alipayTinyButton setImage:unselectImage forState:0];
    [self.wechatTinyButton setImage:unselectImage forState:0];
    
   UIButton *tinyButton = [sender.superview viewWithTag:100];
    
    [tinyButton setImage:selectImage forState:0];
    
    if (sender == self.pocketButton) {
        
        self.payType = PayType_Account;

    }else if (sender == self.wechatButton){
        
        self.payType = [self isExistPayType:PayType_WxApp] ? PayType_WxApp : PayType_BaofooWxapp;

    }else{
        
        self.payType = [self isExistPayType:PayType_AliZfb] ? PayType_AliZfb : PayType_BaofooAliapp;

    }

}

- (IBAction)toFeedback:(id)sender {
    
    YJYSuggestionController *vc = [YJYSuggestionController instanceWithStoryBoard];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableView Delegate 



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == OrderDetailTypeTip) {
        
        return self.orderDetailRsp.order.orderType == 1 && self.orderDetailRsp.order.status == 0 ? 60 : 0;
    }

    if (indexPath.row == OrderDetailTypePackage) {
       
        //package
        
        return 60;
        
    }else if(indexPath.row == OrderDetailTypeOrderID) {
    
        return 81;
        
    }else if(indexPath.row == OrderDetailTypeHospitalNumber) {
        
        return self.orderDetailRsp.order.orderType == 1 ? 60 : 0;
        
    }else if(indexPath.row == OrderDetailTypeBookBeginTime) {
        
        return self.orderDetailRsp.order.status >= 3 && self.orderDetailRsp.order.orderStartTime.length > 0 ? 70 : 0;
        
    }else if (indexPath.row >= OrderDetailTypeDoorPay &&
              indexPath.row <= OrderDetailTypePayWayDesc) {
        //pay
        
        if (self.isNeedPay) {
            
            if (indexPath.row == OrderDetailTypeTotal) {
                return 60;
            }
            return 50;

        }else {
            
            return 0;
        }
        
        
    }else if(indexPath.row == OrderDetailTypeTip) {
        
        return self.orderDetailRsp.order.status ==0 ? 80 : 0;
        
    }else if (indexPath.row == OrderDetailTypeLocation) {

        NSInteger lines = [NSString numberOfLinesWithLabel:self.addressLabel];
        if (lines > 1) {
            return 90;
        }else {
            return 74;
            
        }
    }else if (indexPath.row == OrderDetailTypePocket ||
              indexPath.row == OrderDetailTypeWechat ||
              indexPath.row == OrderDetailTypeAlipay){
      
        if (!self.isNeedPay) {
            return 0;
        }
        BOOL isExist = NO;
        
        if (indexPath.row == OrderDetailTypePocket){
            
            isExist = self.isShowPocket ;
            
        }else if (indexPath.row == OrderDetailTypeWechat) {
            
            isExist = self.isShowWeChat;
            
        }else if (indexPath.row == OrderDetailTypeAlipay){
            
            isExist = self.isShowAlipay;
            
            
        }
        
        
        return isExist ? 50 : 0;

    }
    
   
    
   
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}


@end

@interface YJYOrderDetailController ()<BaofooWebchatPaySDKDelegate>



@property (strong, nonatomic) YJYOrderDetailContentController *contentController;

//action

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

//data

@property (assign, nonatomic) BOOL isPaying;
@property (strong, nonatomic) GetOrderPayDetailRsp *payDetailRsp;
@property (strong, nonatomic) GPBUInt32Array *payTypeListArray;
//pay

@property (strong, nonatomic) BaofooPayClient *bfclent;;
@end



@implementation YJYOrderDetailController



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"Content"]) {
        self.contentController = (YJYOrderDetailContentController *)segue.destinationViewController;
        self.contentController.orderID = self.orderId;
        if (!self.orderId) {
            self.contentController.orderID = self.order.orderId;

        }
        
        self.contentController.cancelButton = self.cancelButton;
        self.contentController.actionButton = self.actionButton;
        
        __weak typeof(self) weakSelf = self;
        self.contentController.didLoadedBlock = ^(GetOrderPayDetailRsp *payDetailRsp) {
            weakSelf.payDetailRsp = payDetailRsp;
            [weakSelf reloadData];
        };
    }
    
}

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderDetailController *)[UIStoryboard storyboardWithName:@"YJYOrderDetail" viewControllerIdentifier:NSStringFromClass(self)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.layer.borderColor = APPMiddleGrayCOLOR.CGColor;

    self.actionButton.layer.borderWidth = 1;
    self.actionButton.layer.cornerRadius = 4;

    
    self.bfclent = [[BaofooPayClient alloc] init];
    self.bfclent.delegate = self;


    

    if (self.fromBooking) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(back)];
    }
 
    if (self.contentController.orderDetailRsp.order.status == -1) {
        
        self.toolView.backgroundColor = [UIColor clearColor];
    }
    
    
}



//data
- (void)reloadData {

    self.order = self.payDetailRsp.order;
    self.orderId = self.payDetailRsp.order.orderId;
   
   
}

#pragma mark - Action

- (void)back {
    
    
    [SYProgressHUD show];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYTabBarIndexSelectNotification object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    [SYProgressHUD hide];
    
  
}



- (IBAction)cancelAction:(id)sender {
    
    
    if (self.order.status == OrderStatus_WaitPayPrefee) {
    
        
        //cancel
        [UIAlertController showAlertInViewController:self withTitle:@"是否取消" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [SYProgressHUD show];
                GetOrderReq *req = [GetOrderReq new];
                req.orderId = self.order.orderId;
                [YJYNetworkManager requestWithUrlString:APPCancelOrder message:req controller:self command:APP_COMMAND_AppcancelOrder success:^(id response) {
                    
                    
                    if (self.detailDidActionBlock) {
                        self.detailDidActionBlock();
                    }
                    [SYProgressHUD hide];
                    [SYProgressHUD showToCenterText:@"成功取消"];
                    [self back];
                    
                } failure:^(NSError *error) {
                    [SYProgressHUD hide];
                    
                }];
                
            }
            
        }];
        
    }else {
    
        
        
        YJYOrderSettleController *vc = [YJYOrderSettleController instanceWithStoryBoard];
        vc.order = self.order;
        [self.navigationController pushViewController:vc animated:YES];
      
    
    }
    
    
}
- (IBAction)operationAction:(id)sender {
    
    if (self.order.status == OrderStatus_WaitAssign || self.order.status == OrderStatus_WaitService) {
    
  
        [SYProgressHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.order.kfPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [SYProgressHUD hide];
        });
        
    }else if (self.order.status == OrderStatus_WaitPayPrefee){
        
        
        if (self.order.orderType == 1) {
            __weak typeof(self) weakSelf = self;
            
            if (self.payDetailRsp.needNotice) {
                [self showDoorBan:^{
                    
                    [weakSelf toPay];
                    
                }];
            }else {
                    [self toPay];
            }
            
            
        }else {
            [self toPay];

        }
        
    
    }
    
}

- (void)toPay {
    
    
    if (self.contentController.payType == 0) {
        [SYProgressHUD showFailureText:@"请选择付款方式"];
        return;
    }
    
    [SYProgressHUD show];
    
   
    
    DoPayReq *req = [DoPayReq new];
    req.operation = @"PAY_PREAMOUNT";
    req.orderId = self.order.orderId;
    req.payType = (uint32_t)self.contentController.payType;
    
    
    
    [YJYNetworkManager requestWithUrlString:APPDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
        

        [YJYPaymentManager sharedInstance].payResult = [NSString stringWithFormat:@"%@",self.order.needPay] ;
        
        DoPayRsp *rsp = [DoPayRsp parseFromData:response error:nil];
        
        if (req.payType == PayType_Account) {
            

            [[YJYPaymentManager sharedInstance] handleStateCode:CDMStateCodeSuccess vc:self isOrder:NO isRoot:NO complete:^{
                [self.contentController loadNetWorkData];

            }];

            
        }else if (req.payType == PayType_WxApp|| req.payType == PayType_BaofooWxapp) {
        
            
            if (![WXApi isWXAppInstalled]) {
                [SYProgressHUD showFailureText:@"没有安装微信"];
                return;
            }
          
            
            id orderMessage = [[YJYPaymentManager sharedInstance]wechatPayReqWithOrderString:rsp.prePayId];
            if (req.payType == PayType_BaofooWxapp) {
                
                [self.bfclent payWebchatWithTokenID:orderMessage channelState:channel_weChat  withSelf:self];
                
            }else {
                
                [[YJYPaymentManager sharedInstance] cdm_payOrderMessage:orderMessage callBack:^(CDMPayStateCode stateCode, NSString *stateMsg) {
                   
                    [self.contentController loadNetWorkData];

                }];
            }
            

            [SYProgressHUD hide];

        }else if (req.payType == PayType_BaofooAliapp || req.payType == PayType_AliZfb){
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                [SYProgressHUD showFailureText:@"没有安装支付宝"];
                return;
            }
            
            id orderMessage = rsp.prePayId;

            
            if (req.payType == PayType_BaofooAliapp) {
                [self.bfclent payWebchatWithTokenID:orderMessage channelState:channel_alipay  withSelf:self];
                
            }else {
                
                [[YJYPaymentManager sharedInstance] cdm_payOrderMessage:orderMessage callBack:^(CDMPayStateCode stateCode, NSString *stateMsg) {
                    
                    [self.contentController loadNetWorkData];

                }];
            }

            
            
            [SYProgressHUD hide];

        }

        

        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)showDoorBan:(YJYOrderDetailDidPayBlock)complete{
    
    
    
    [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:self.payDetailRsp.extraAddrDesc message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex == 1) {
            if (complete) {
                complete();
            }
        }
    }];
    
    
    
}



#pragma mark -BaofooWebchatPaySDKDelegate
-(void)callBack:(NSString*)statusCode andMessage:(NSString *)message{
    
    [self.bfclent manualQuery];

    CDMPayStateCode code = (CDMPayStateCode)[statusCode integerValue];
    
    [[YJYPaymentManager sharedInstance] handleStateCode:code vc:self isOrder:YES isRoot:YES complete:^{
        
        [self.contentController loadNetWorkData];

    }];

    
}


@end
