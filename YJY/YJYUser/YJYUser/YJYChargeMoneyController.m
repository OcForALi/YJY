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



@interface YJYChargeMoneyController ()

@property (weak, nonatomic) IBOutlet UIView *aliPayView;
@property (weak, nonatomic) IBOutlet UIView *weChatView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aliConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weChatConstraintH;


@property (weak, nonatomic) IBOutlet UIButton *aliPayItemButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatItemButton;

//data

@property (assign, nonatomic) CGFloat amount;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSArray *typeTags;

@property (assign, nonatomic) YJYChargeType chargeType;
@property (strong, nonatomic) YJYChargeMoneyItemsController *itemVC;


@end

@implementation YJYChargeMoneyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYChargeMoneyController *)[UIStoryboard storyboardWithName:@"YJYCharge" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chargeType = YJYChargeTypeWechat;
    
    PayType payType = [[YJYSettingManager sharedInstance].payTypeListArray valueAtIndex:index];

    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"YJYChargeMoneyItemsController"]) {
        self.itemVC = (YJYChargeMoneyItemsController *)segue.destinationViewController;
    }
    
}




#pragma mark - Action

- (IBAction)payAction:(UIButton *)sender {
    
    self.chargeType = sender.tag;
    
    
    [self.aliPayItemButton setImage:[UIImage imageNamed:@"app_unselect_icon"] forState:0];
    [self.wechatItemButton setImage:[UIImage imageNamed:@"app_unselect_icon"] forState:0];
    
    
    if (self.chargeType == YJYChargeTypeWechat) {
        
        [self.wechatItemButton setImage:[UIImage imageNamed:@"app_select_icon"] forState:0];

    }else {
        [self.aliPayItemButton setImage:[UIImage imageNamed:@"app_select_icon"] forState:0];

    }

    
}



- (IBAction)chargeMoneyAction:(id)sender {
    
    
    [SYProgressHUD show];
  
    DoPayReq *req = [DoPayReq new];
    req.payType = (self.chargeType == YJYChargeTypeWechat) ? 3: 1;
    req.operation = @"PAY_RECHARGE";
    req.rechargeId =  self.itemVC.currentSetting.id_p;

    
    [YJYNetworkManager requestWithUrlString:APPDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
        
        [SYProgressHUD hide];

        
        [YJYPaymentManager sharedInstance].payResult = [NSString stringWithFormat:@"%@", self.itemVC.currentSetting.feeStr] ;
        DoPayRsp *rsp = [DoPayRsp parseFromData:response error:nil];
        
        id orderMessage = (req.payType == 3) ? [[YJYPaymentManager sharedInstance]wechatPayReqWithOrderString:rsp.prePayId] : rsp.prePayId;
        
        [[YJYPaymentManager sharedInstance] cdm_payOrderMessage:orderMessage callBack:^(CDMPayStateCode stateCode, NSString *stateMsg) {
            
            if (stateCode == CDMStateCodeSuccess) {
                
                [SYProgressHUD hide];

                YJYChargeSuccessController *vc = [YJYChargeSuccessController instanceWithStoryBoard];
                vc.isCharge = YES;
                [[UIWindow currentViewController] presentViewController:vc animated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else {
            
                [SYProgressHUD showFailureText:@"支付失败"];
            }
            

            
        }];
        
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"加载失败"];

    }];
    
    
}








@end
