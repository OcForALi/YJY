

//
//  YJYOrderPayoffController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/27.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPayoffController.h"
#import "YJYPaymentOptionView.h"

#pragma mark - YJYOrderPaidDetailController

typedef NS_ENUM(NSInteger, OrderPaidDetailType) {
    
    OrderPaidDetailTypePackage,
    OrderPaidDetailTypeOrderID ,
    OrderPaidDetailTypeCost,
    OrderPaidDetailTypeServiceFee,
    OrderPaidDetailTypeServiceAdd,
    OrderPaidDetailTypeServiceBlank,
    OrderPaidDetailTypeTotal,
    OrderPaidDetailTypePaid,
    OrderPaidDetailTypePreDiscount,
    OrderPaidDetailTypeCoupon,
    OrderPaidDetailTypeWaitPaid,
    OrderPaidDetailTypeShouldReturn,
    OrderPaidDetailTypePayMethod,
    OrderPaidDetailTypePocket,
    OrderPaidDetailTypeWechat,
    OrderPaidDetailTypeAlipay,
    
};



@interface YJYServiceItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (strong, nonatomic) OrderItemVO2 *item;

@end

@implementation YJYServiceItemCell


- (void)setItem:(OrderItemVO2 *)item {

    _item = item;
    
    self.nameLabel.text = item.service;
    self.dayLabel.text = [NSString stringWithFormat:@"+%@",@(item.serviceDays)] ;
    self.unitLabel.text = item.priceDesc;
    self.totalLabel.text = [NSString stringWithFormat:@"%@元",item.totalCostStr] ;;

}

@end

typedef void(^DetailDataDidLoadBlock)(SettlPayDetailRsp *payDetailRsp);

@interface YJYOrderPaidDetailController : UITableViewController
//data

@property (strong, nonatomic) OrderVO *order;
@property (strong, nonatomic) NSArray<NSString*> *settDateArray;


#define kListItemDefalutCount 13
#define kaddsDefalutH 50
#define kServiceDefalutH 50
#define kServiceItemDefalutH 44


//service

@property (weak, nonatomic) IBOutlet UITableView *serviceTableView;
@property (weak, nonatomic) IBOutlet UITableView *addsTableView;

@property (assign, nonatomic) BOOL isServiceExpand;
@property (assign, nonatomic) BOOL isAddsExpand;

@property(nonatomic, strong) NSMutableArray<OrderItemVO2*> *serviceListArray;
@property(nonatomic, strong) NSMutableArray<OrderItemVO2*> *extraListArray;

@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addsFeeLabel;


//data

@property (assign, nonatomic) uint32_t payType;
@property (copy, nonatomic) DetailDataDidLoadBlock detailDataDidLoadBlock;

@property (strong, nonatomic) SettlPayDetailRsp *payDetailRsp;
@property (assign, nonatomic) BOOL notExtraPay;


//order
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *preLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;


//pay


@property (weak, nonatomic) IBOutlet UIButton *pocketButton;
@property (weak, nonatomic) IBOutlet UIButton *pocketTinyButton;
@property (weak, nonatomic) IBOutlet UIImageView *pocketIcon;
@property (weak, nonatomic) IBOutlet UILabel *pocketLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *wechatTinyButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;


@property (weak, nonatomic) IBOutlet UIButton *alipayTinyButton;



@end
@implementation YJYOrderPaidDetailController


- (void)viewDidLoad {

    [super viewDidLoad];
  
    self.serviceListArray = [NSMutableArray array];
    self.extraListArray = [NSMutableArray array];
    self.isServiceExpand = YES;
    self.isAddsExpand = YES;
    
    [self payAction:self.pocketButton];
    self.balanceLabel.layer.cornerRadius = self.balanceLabel.frame.size.height/2;
    self.balanceLabel.layer.borderColor = self.balanceLabel.textColor.CGColor;
    self.balanceLabel.layer.borderWidth = 1;
    
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    SettlPayDetailReq *req = [SettlPayDetailReq new];
    req.settDateArray = [NSMutableArray arrayWithArray:self.settDateArray];
    req.orderId = self.order.orderId;
    
    
    [YJYNetworkManager requestWithUrlString:APPSettlPayDetail message:req controller:self command:APP_COMMAND_AppsettlPayDetail success:^(id response) {
        
        SettlPayDetailRsp *rsp = [SettlPayDetailRsp parseFromData:response error:nil];
        self.order = rsp.order;
        self.serviceListArray = rsp.serviceListArray;
        self.extraListArray = rsp.extraListArray;
        
        self.payDetailRsp = rsp;
        self.notExtraPay = !rsp.extraPay;
        
        if (self.detailDataDidLoadBlock) {
            self.detailDataDidLoadBlock(rsp);
        }
        
        [self setupOrder];
        
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - reload

- (void)setupOrder {
    
    
    self.packageLabel.text = self.order.service;
    self.orderIDLabel.text = [NSString stringWithFormat:@"订单号：%@",self.order.orderId];
    self.timeLabel.text = [NSString stringWithFormat:@"订单时间: %@",self.order.createTime];

    self.serviceFeeLabel.text = [NSString stringWithFormat:@"%@元",self.payDetailRsp.serviceTotalFee];
    self.addsFeeLabel.text = [NSString stringWithFormat:@"%@元",self.payDetailRsp.extraTotalFee];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@元",self.payDetailRsp.totalFee];
    self.paidLabel.text =  [NSString stringWithFormat:@"-%@元",self.payDetailRsp.realPay];

    self.preLabel.text = [NSString stringWithFormat:@"-%@元",self.payDetailRsp.preRealFee];
    self.youhuiLabel.text = [NSString stringWithFormat:@"-%@元",self.payDetailRsp.hgRebateFee];

    self.payTipLabel.text = [NSString stringWithFormat:@"%@%@元",self.payDetailRsp.payFlag == 2 ? @"应退金额:" : @"应付金额:",(self.payDetailRsp.payFlag == 2 ? self.payDetailRsp.returnPay : self.payDetailRsp.needPay)];


    [self loadWithPurse];
    [self reload];
    
    
}

- (void)loadWithPurse {
    
    
    
    self.balanceLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    if (self.payDetailRsp.usePurse) {
        self.balanceLabel.text = [NSString stringWithFormat:@" 余额 : %@元  ",self.payDetailRsp.purse];
        [self.balanceLabel sizeToFit];
        self.pocketLabel.textColor = APPDarkCOLOR;
        self.pocketButton.userInteractionEnabled = YES;
        
    }else {
        self.balanceLabel.text = @"  钱包余额不足  ";
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

#pragma mark - Action

- (void)reload {
    
    [self.tableView reloadData];
    [self.serviceTableView reloadData];
    [self.addsTableView reloadData];

}



- (IBAction)serviceExpandAction:(UIButton *)sender {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.selected = !sender.selected;

    }];
    
    
    [self.tableView beginUpdates];
    self.isServiceExpand = !self.isServiceExpand;
    [self.serviceTableView reloadData];
    [self.tableView reloadData];
    [self.tableView endUpdates];

}

- (IBAction)addsExpandAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.selected = !sender.selected;
        
    }];
    [self.tableView beginUpdates];
    self.isAddsExpand = !self.isAddsExpand;
    [self.addsTableView reloadData];
    [self.tableView reloadData];
    [self.tableView endUpdates];

}
#pragma mark - pay

- (IBAction)payAction:(UIButton *)sender {
    
    UIImage *selectImage = [UIImage imageNamed:@"pay_select_icon"];
    UIImage *unselectImage = [UIImage imageNamed:@"pay_unselect_icon"];
    
    
    [self.pocketTinyButton setImage:unselectImage forState:0];
    [self.alipayTinyButton setImage:unselectImage forState:0];
    [self.wechatTinyButton setImage:unselectImage forState:0];
    
    UIButton *tinyButton = [sender.superview viewWithTag:100];
    
    [tinyButton setImage:selectImage forState:0];
    
    self.payType = (uint32_t)sender.tag;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.serviceTableView == tableView) {
        
        if (self.serviceListArray.count > 0) {
            return self.serviceListArray.count + 1;
        }
        return 0;
    }else if (self.addsTableView == tableView) {
        
        if (self.extraListArray.count > 0) {
            return self.extraListArray.count + 1;
        }
        return 0;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.serviceTableView || tableView == self.addsTableView) {
        
       YJYServiceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYServiceItemCell" forIndexPath:indexPath];
        
        
        
        if (indexPath.row != 0) {
            
            id item;
            if (tableView == self.serviceTableView) {
               item = self.serviceListArray[indexPath.row - 1];
            }else {
               item = self.extraListArray[indexPath.row - 1];

            }
            cell.item = item;
            
            
            
        }else {
            
            cell.nameLabel.text = @"服务";
            cell.dayLabel.text = @"服务次/天数";
            cell.unitLabel.text = @"单价";
            cell.totalLabel.text = @"总计";

        }
        return cell;

    }
    
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.tableView == tableView) {
        
       if (indexPath.row == OrderPaidDetailTypeServiceFee) {

            if (self.serviceListArray.count > 0) {
                
                return kServiceDefalutH + (self.isServiceExpand ? (self.serviceListArray.count+1) * kServiceItemDefalutH - 1 : 0);// + ;
                
            }else {return 0;}
        
        }else if (indexPath.row == OrderPaidDetailTypeServiceAdd) {

            if (self.extraListArray.count > 0) {
                
                return kaddsDefalutH + (self.isAddsExpand ? (self.extraListArray.count+1) * kServiceItemDefalutH - 1 : 0);
                
            }else {
                
                return 0;
            
            }
            
        }else if(indexPath.row == OrderPaidDetailTypeWaitPaid){
            
            return 0;
        }else if (indexPath.row == OrderPaidDetailTypePayMethod) {
            
            if ((self.payDetailRsp.insureAccount.length >0 &&
                !self.payDetailRsp.extraPay) || self.payDetailRsp.payFlag != 1) {
                return 0;
            }
        }
        
      
        
    }else if(self.serviceTableView == tableView){
    
        return kServiceItemDefalutH;
        
    }else if(self.addsTableView == tableView){
        
        return kServiceItemDefalutH;
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}


@end

#pragma mark - YJYOrderPayoffController

@interface YJYOrderPayoffController ()
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *waitPayButton;
@property (strong, nonatomic) YJYOrderPaidDetailController *orderPaidDetailController;
@property (strong, nonatomic) SettlPayDetailRsp *payDetailRsp;
@end

@implementation YJYOrderPayoffController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderPaidDetailController"])   {
        
        self.orderPaidDetailController = (YJYOrderPaidDetailController *)segue.destinationViewController;
        self.orderPaidDetailController.order = self.order;
        self.orderPaidDetailController.settDateArray = self.settDateArray;
        self.orderPaidDetailController.payType = 6;
        
        __weak typeof(self) weakSelf = self;
        self.orderPaidDetailController.detailDataDidLoadBlock = ^(SettlPayDetailRsp *payDetailRsp) {
            
            weakSelf.payDetailRsp = payDetailRsp;
            if (payDetailRsp.payFlag == 0 || payDetailRsp.payFlag == 2) {
                [weakSelf.waitPayButton setTitle:@"完成" forState:0];

            }else {
            
                [weakSelf.waitPayButton setTitle:[NSString stringWithFormat:@"待付款 %@ 元",payDetailRsp.needPay] forState:0];
            }
            
            
        };
        
    }
}
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPayoffController *)[UIStoryboard storyboardWithName:@"YJYOrderPayoff" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = APPExtraGrayCOLOR;
    self.title = @"结算详情";
}


- (IBAction)doneAction:(id)sender {

    [SYProgressHUD show];
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.order.orderId;
    [YJYNetworkManager requestWithUrlString:APPConfirmOrderFinish message:req controller:self command:APP_COMMAND_AppconfirmOrderFinish success:^(id response) {
        
        
        [SYProgressHUD showSuccessText:@"订单已完成"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kYJYTabBarIndexSelectNotification object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    

       
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)payAction:(id)sender {

    if (self.payDetailRsp.payFlag == 0 || self.payDetailRsp.payFlag == 2) {
        
        [self doneAction:nil];
        return;
    }
    
    [SYProgressHUD show];
    
   
    
    DoPayReq *req = [DoPayReq new];
    req.operation = @"PAY_ORDERSETTLE";
    
    req.orderId = self.order.orderId;
    req.monthsArray = [NSMutableArray arrayWithArray:self.settDateArray];
    req.payType = self.orderPaidDetailController.payType;
    
    [YJYNetworkManager requestWithUrlString:APPDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
        
        [SYProgressHUD hide];

        
        [YJYPaymentManager sharedInstance].payResult = [NSString stringWithFormat:@"%@",self.orderPaidDetailController.payDetailRsp.needPay] ;

        
        DoPayRsp *rsp = [DoPayRsp parseFromData:response error:nil];
        
        if (req.payType == 6) {
            
            [[YJYPaymentManager sharedInstance] handleStateCode:CDMStateCodeSuccess vc:self isOrder:YES isRoot:YES  complete:nil];
            [SYProgressHUD showSuccessText:@"支付成功"];
            
            
            
        }else if (req.payType == 3 || req.payType == 1) {
            
            id orderMessage = (req.payType == 3) ? [[YJYPaymentManager sharedInstance]wechatPayReqWithOrderString:rsp.prePayId] : rsp.prePayId;
            
            [[YJYPaymentManager sharedInstance] cdm_payOrderMessage:orderMessage callBack:^(CDMPayStateCode stateCode, NSString *stateMsg) {
                
                [[YJYPaymentManager sharedInstance] handleStateCode:stateCode vc:self isOrder:YES isRoot:YES  complete:nil];
            }];
            
            [SYProgressHUD hide];
            
        }else {
            
            
            [SYProgressHUD hide];
            
        }

        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
