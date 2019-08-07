//
//  YJYChargeMoneyController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYChargeMoneyController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaoFuAggregatePay/WXApi.h>

#define kRadioTag 11
#define kMoneyLabelTag 111
#define kNameLabelTag 1111


#pragma mark - YJYChargeMoneyCell

@class RechargeSetting;


@interface YJYChargeMoneyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) RechargeSetting *rechargeSetting;

@end


@implementation YJYChargeMoneyCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.moneyLabel.backgroundColor = [UIColor clearColor];
    self.moneyLabel.layer.masksToBounds = YES;
    self.moneyLabel.layer.borderWidth = 1;
    self.moneyLabel.layer.cornerRadius = 1.5;
    self.moneyLabel.layer.borderColor = APPGrayCOLOR.CGColor;
    self.moneyLabel.textColor = APPDarkGrayCOLOR;

}

- (void)setRechargeSetting:(RechargeSetting *)rechargeSetting {

    _rechargeSetting = rechargeSetting;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ 元",rechargeSetting.feeStr];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected) {
        self.moneyLabel.layer.borderColor = APPHEXCOLOR.CGColor;
        self.moneyLabel.textColor = APPHEXCOLOR;
    }else {
        
        self.moneyLabel.layer.borderColor = APPGrayCOLOR.CGColor;
        self.moneyLabel.textColor = APPDarkGrayCOLOR;
    }
}


@end


#pragma mark - YJYChargeMoneyItemsController


@interface YJYChargeMoneyItemsController : YJYTableViewController

@property (strong, nonatomic) NSMutableArray<RechargeSetting*> *rsListArray;
@property (strong, nonatomic) RechargeSetting *currentSetting;
@property (assign, nonatomic) NSInteger row;

@end

@implementation YJYChargeMoneyItemsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.row = 0;
    self.rsListArray = [NSMutableArray array];
    [self loadNetwork];
    
}

- (void)loadNetwork {
    
    
    [YJYNetworkManager requestWithUrlString:GetRechargeSetting message:nil controller:self command:APP_COMMAND_GetRechargeSetting success:^(id response) {
        
        GetRechargeSettingRsp *rsp = [GetRechargeSettingRsp parseFromData:response error:nil];
        self.rsListArray = rsp.rsListArray;
        self.currentSetting = self.rsListArray.firstObject;
        [self.tableView reloadData];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - UITableView



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rsListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYChargeMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYChargeMoneyCell"];
    cell.rechargeSetting = self.rsListArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentSetting = self.rsListArray[indexPath.row];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

@end

#pragma mark - YJYChargeMoneyController


typedef NS_ENUM(NSInteger, YJYChargeType) {
    
    YJYChargeTypeWechat = 88,
    YJYChargeTypeAlipay = 99
    
};



@interface YJYChargeMoneyController ()<BaofooWebchatPaySDKDelegate>

@property (weak, nonatomic) IBOutlet UIView *aliPayView;
@property (weak, nonatomic) IBOutlet UIView *weChatView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aliConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weChatConstraintH;

@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

@property (weak, nonatomic) IBOutlet UIButton *aliPayItemButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatItemButton;

//data

@property (assign, nonatomic) CGFloat amount;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSArray *typeTags;

@property (assign, nonatomic) uint32_t payType;
@property (strong, nonatomic) YJYChargeMoneyItemsController *itemVC;
@property (strong, nonatomic) BaofooPayClient *bfclent;;


@property (assign, nonatomic) BOOL isShowWeChat;
@property (assign, nonatomic) BOOL isShowAlipay;

@end

@implementation YJYChargeMoneyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYChargeMoneyController *)[UIStoryboard storyboardWithName:@"YJYCharge" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPayTypeHidden];
    self.bfclent = [[BaofooPayClient alloc] init];
    self.bfclent.delegate = self;
    
    [self loadConfigure];
    
}
- (void)loadConfigure {
    
    [YJYNetworkManager requestWithUrlString:APPGetPayType message:nil controller:nil command:APP_COMMAND_GetPayType success:^(id response) {
        
        GetPayTypeRsp *rsp = [GetPayTypeRsp parseFromData:response error:nil];
        [YJYSettingManager sharedInstance].payTypeListArray = rsp.payTypeListArray;
        
        [self loadPayTypeHidden];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"YJYChargeMoneyItemsController"]) {
        self.itemVC = (YJYChargeMoneyItemsController *)segue.destinationViewController;
    }
    
}





#pragma mark - payType

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
    
    self.isShowWeChat = ([self isExistPayType:PayType_WxApp]  || [self isExistPayType:PayType_BaofooWxapp]);
    self.weChatConstraintH.constant = self.isShowWeChat ? 45 : 0;
    self.weChatView.hidden = !self.isShowWeChat;
    
    self.isShowAlipay = ([self isExistPayType:PayType_AliZfb]  || [self isExistPayType:PayType_BaofooAliapp]);
    self.aliConstraintH.constant = self.isShowAlipay ? 45 : 0;
    self.aliPayView.hidden = !self.isShowAlipay;
}



- (IBAction)payAction:(UIButton *)sender {
    
    
    
    [self.aliPayItemButton setImage:[UIImage imageNamed:@"app_unselect_icon"] forState:0];
    [self.wechatItemButton setImage:[UIImage imageNamed:@"app_unselect_icon"] forState:0];
    
    
    if (sender == self.weChatButton) {
        
        [self.wechatItemButton setImage:[UIImage imageNamed:@"app_select_icon"] forState:0];

    }else {
        [self.aliPayItemButton setImage:[UIImage imageNamed:@"app_select_icon"] forState:0];

    }

    
   if (sender == self.weChatButton){
        
        self.payType = [self isExistPayType:PayType_WxApp] ? PayType_WxApp : PayType_BaofooWxapp;
        
    }else{
        
        self.payType = [self isExistPayType:PayType_AliZfb] ? PayType_AliZfb : PayType_BaofooAliapp;
        
    }
    
}

#pragma mark - Action


- (IBAction)chargeMoneyAction:(id)sender {
    
    if (self.payType == 0) {
        [SYProgressHUD showFailureText:@"请选择付款方式"];
        return;
    }
    
    [SYProgressHUD show];
  
    DoPayReq *req = [DoPayReq new];
    req.payType =  self.payType;
    req.operation = @"PAY_RECHARGE";
    req.rechargeId =  self.itemVC.currentSetting.id_p;

    
    [YJYNetworkManager requestWithUrlString:APPDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
        
        [SYProgressHUD hide];

        
        [YJYPaymentManager sharedInstance].payResult = [NSString stringWithFormat:@"%@", self.itemVC.currentSetting.feeStr] ;
        DoPayRsp *rsp = [DoPayRsp parseFromData:response error:nil];
        
        if (req.payType == PayType_WxApp|| req.payType == PayType_BaofooWxapp) {
            
            
            if (![WXApi isWXAppInstalled]) {
                [SYProgressHUD showFailureText:@"没有安装微信"];
                return;
            }
            
            
            id orderMessage = [[YJYPaymentManager sharedInstance]wechatPayReqWithOrderString:rsp.prePayId];
            if (req.payType == PayType_BaofooWxapp) {
                
                [self.bfclent payWebchatWithTokenID:orderMessage channelState:channel_weChat  withSelf:self];
                
            }else {
                
            
                [[YJYPaymentManager sharedInstance] cdm_payOrderMessage:orderMessage callBack:^(CDMPayStateCode stateCode, NSString *stateMsg) {
                    
                    [[YJYPaymentManager sharedInstance] handleStateCode:stateCode vc:self isOrder:NO isRoot:NO complete:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
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
                    
                    [[YJYPaymentManager sharedInstance] handleStateCode:stateCode vc:self isOrder:NO isRoot:NO complete:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }];
            }
            
            
            
            [SYProgressHUD hide];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"加载失败"];

    }];
    
    
}


#pragma mark -BaofooWebchatPaySDKDelegate
-(void)callBack:(NSString*)statusCode andMessage:(NSString *)message{
    
    [self.bfclent manualQuery];
    
    CDMPayStateCode stateCode = (CDMPayStateCode)[statusCode integerValue];
    
    [[YJYPaymentManager sharedInstance] handleStateCode:stateCode vc:self isOrder:NO isRoot:NO complete:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}





@end
