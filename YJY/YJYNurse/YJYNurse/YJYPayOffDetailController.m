//
//  YJYPayOffDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/8/2.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYPayOffDetailController.h"
#import "YJYOrderPayOffCell.h"
#import "YJYOrderQRController.h"

@interface YJYOrderPayOffDetailItemCell : UITableViewCell

@property (strong, nonatomic) OrderCurrent *orderCurrent;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

@implementation YJYOrderPayOffDetailItemCell

- (void)setOrderCurrent:(OrderCurrent *)orderCurrent {
    
    _orderCurrent = orderCurrent;
    self.orderIdLabel.text = orderCurrent.orderId;
    self.branchLabel.text = orderCurrent.serviceAddr;
    self.feeLabel.text = orderCurrent.totalFeeStr;
}

@end

@interface YJYOrderPayOffDetailCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<OrderCurrent*> *orderListArray;


- (CGFloat)cellHeight;

@end

@implementation YJYOrderPayOffDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderListArray = [NSMutableArray array];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderListArray.count + 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderPayOffDetailItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderPayOffDetailItemCell"];
    NSInteger row = indexPath.row - 1;
    if (row >= 0) {
        cell.orderCurrent = self.orderListArray[row];
    }else {
        
        cell.orderIdLabel.text = @"订单号";
        cell.branchLabel.text = @"科室";
        cell.feeLabel.text = @"费用";
    }
    
    return cell;
    
}
- (CGFloat)cellHeight {
    
    if (self.orderListArray.count == 0) {
        return 0;
    }
    return 50 * (self.orderListArray.count + 1);
}
@end


@interface YJYPayOffDetailContentController : YJYTableViewController

//data

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) BatchSettleOrderRsp *rsp;
@property (copy, nonatomic) YJYDidDoneBlock didDoneBlock;


//view
@property (weak, nonatomic) IBOutlet YJYOrderPayOffDetailCell *baseServiceCell;


@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UILabel *preDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *primeLabel;


@property (weak, nonatomic) IBOutlet UILabel *shouldOutLabel;


@end

@implementation YJYPayOffDetailContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    [SYProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    req.orderId = self.orderId;
  
    
    [YJYNetworkManager requestWithUrlString:SAASAPPBatchSettleOrder message:req controller:self command:APP_COMMAND_SaasappbatchSettleOrder success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp = [BatchSettleOrderRsp parseFromData:response error:nil];
        
        
        [self reloadAllData];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)reloadRsp {
    
    // cell
    
    self.baseServiceCell.orderListArray = self.rsp.orderListArray;
    
    // price
    self.totalPayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.totalFee];
    self.paidLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.paidFee];
    self.preDiscountLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.prePaidFee];
    self.primeLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.rebateFee];
    
    /// 0-待付 1-刚好 2-待退
    NSString *tip = @"";
    if (self.rsp.settlePayType == 0) {
        tip = @"应付金额: ";
    }else if (self.rsp.settlePayType == 1){
        tip = @"收款: ";
    }else {
        tip = @"应退金额: ";
    }
    
  
    self.shouldOutLabel.text = [NSString stringWithFormat:@"%@%@元",tip,self.rsp.fee];

    
    [self.tableView reloadData];
    [self.baseServiceCell.tableView reloadData];
    
    if (self.didDoneBlock) {
        self.didDoneBlock();
    }
    
    
}

#pragma mark - Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return [self.baseServiceCell cellHeight];
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


#pragma mark - Action

- (IBAction)done:(id)sender {
    
    /// 0-待付 1-刚好 2-待退
    if (self.rsp.settlePayType == 0) {
        //仍需支付
        [self toReceive];
        
    }else if (self.rsp.settlePayType == 1){
        
        //结算订单
        [self toFinishWithRefundPayType:53];
        
    }else {
        [self toReturn];
        
    }
    
    
    
}
#pragma mark - 收款
//选择收款方式
- (void)toReceive {
    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"线上收款" otherButtonTitles:@[@"现金收款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            YJYOrderQRController *vc = [YJYOrderQRController instanceWithStoryBoard];
            vc.orderId = self.orderId;
            vc.URLType = 5;
            vc.didDoneBlock = ^{
                if (self.didDoneBlock) {
                    self.didDoneBlock();
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (buttonIndex == 2){
            
            [self toReceiveMoney];

            
            
        }
        
    }];
}

//去现金收款
- (void)toReceiveMoney {
    
    
    if (self.rsp.ddFee == YES) {
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
            [self toPayReceiveMoney];
        }else {
            
            [self toCallDoudaoReceiveMoney];
            
        }
        
    }else {
        [self toTipCustomer];
        return;
    }
    
    
    
}
//提示用户
-(void)toTipCustomer {
    
    [UIAlertController showAlertInViewController:self withTitle:@"请提示用户到收费处进行结算！" message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
        }
        
    }];
}
//通知督导
-(void)toCallDoudaoReceiveMoney {
    
    NSString *des = [NSString stringWithFormat:@"是否向督导发送收款请求"];
    
    
    [UIAlertController showAlertInViewController:self withTitle:des message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            OrderJPushReq *req = [OrderJPushReq new];
            req.orderId = self.orderId;
            req.jpushType = 3;
            [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"发送成功"];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}


//现金收款
- (void)toPayReceiveMoney {
    NSString *title = @"";
    title = [NSString stringWithFormat:@"是否确定已现金收取%@元",self.rsp.fee];

    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            DoPayReq *req = [DoPayReq new];
            req.operation = @"PAY_ORDERBATCHSETTLE";
            req.payType = 5;
            
            NSMutableArray *orderIds = [NSMutableArray array];
            for (OrderCurrent *orderCurrent in self.rsp.orderListArray) {
                [orderIds addObject:orderCurrent.orderId];
            }
            
            req.orderIdsArray = orderIds;
            
            [YJYNetworkManager requestWithUrlString:SAASDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
                
                [SYProgressHUD hide];
                
                YJYPayOffDetailController *pvc = (YJYPayOffDetailController *)self.parentViewController;
                
                if (pvc.didDoneBlock) {
                    pvc.didDoneBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }
        
    }];
    
    
}

#pragma mark - 完成结算订单
//完成订单
/// 退款方式 53-退账户余额 72-退现金

- (void)toFinishWithRefundPayType:(uint32_t)refundPayType {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否确定结算订单" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            ConfirmOrderBatchFinishReq *req = [ConfirmOrderBatchFinishReq new];
            NSMutableArray *orderIds = [NSMutableArray array];
            for (OrderCurrent *orderCurrent in self.rsp.orderListArray) {
                [orderIds addObject:orderCurrent.orderId];
            }
            
            req.orderIdsArray = orderIds;
            req.refundPayType = refundPayType;

            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderBatchFinish message:req controller:nil command:APP_COMMAND_SaasappconfirmOrderBatchFinish success:^(id response) {
                
                [SYProgressHUD hide];
                
                YJYPayOffDetailController *pvc = (YJYPayOffDetailController *)self.parentViewController;
                if (pvc.didDoneBlock) {
                    pvc.didDoneBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
    
    
}
#pragma mark - 退款
- (void)toReturn {
    
    /// 是否可退余额    true-可以 false-不可以
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        if (self.rsp.ddFee == YES) {
            [self toCallDoudaoReturn];
        }else{
            [self toTipCustomer];
        }
        
    }else{
     
        if (self.rsp.refundType == YES) {
            
            [self toReturnOnline];
            
        }else {
            
            [self toReturnComfire];
            
        }
        
    }
    
}
- (void)toReturnOnline {
    [UIAlertController showAlertInViewController:self withTitle:@"是否确定结算？（退款将在3-5个工作日内原路退回支付账户）" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self toReturnToUserWithRefundPayType:53];
            
        }
        
    }];
    
}
- (void)toReturnComfire {
    /// 督导是否有收费权限 true-有收费权限 false-无收费权限

    if (self.rsp.ddFee) {
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ? [self toReturnDoudao] : [self toCallDoudaoReturn];
    }else {
        
        [self toTipCustomer];

    }
    

}
- (void)toReturnDoudao {
    
    NSString *title = [NSString stringWithFormat:@"是否确定退现金%@元",self.rsp.fee];
    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self toReturnToUserWithRefundPayType:72];
            
        }
        
    }];
}


- (void)toCallDoudaoReturn {
    
    NSString *des = [NSString stringWithFormat:@"是否通知督导现金退款？"];
    
    
    [UIAlertController showAlertInViewController:self withTitle:des message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            OrderJPushReq *req = [OrderJPushReq new];
            req.orderId = self.orderId;
            req.jpushType = 3;
            [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"发送成功"];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
- (void)toReturnToUserWithRefundPayType:(uint32_t)refundPayType {
    
    [SYProgressHUD show];
    
    ConfirmOrderBatchFinishReq *req = [ConfirmOrderBatchFinishReq new];
    NSMutableArray *orderIds = [NSMutableArray array];
    for (OrderCurrent *orderCurrent in self.rsp.orderListArray) {
        [orderIds addObject:orderCurrent.orderId];
    }
    
    req.orderIdsArray = orderIds;
    req.refundPayType = refundPayType;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderBatchFinish message:req controller:self command:APP_COMMAND_SaasappconfirmOrderBatchFinish success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"退款成功"];
        YJYPayOffDetailController *pvc = (YJYPayOffDetailController *)self.parentViewController;
        if (pvc.didDoneBlock) {
            pvc.didDoneBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}


@end

@interface YJYPayOffDetailController ()
@property (strong, nonatomic) YJYPayOffDetailContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@end

@implementation YJYPayOffDetailController



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYPayOffDetailContentController"]) {
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.didDoneBlock = ^{
          
            [weakSelf reloadButton];
        };
    }
}
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYPayOffDetailController *)[UIStoryboard storyboardWithName:@"YJYPayOffDetail" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

}

- (void)reloadButton {
    /// 0-待付 1-刚好 2-待退

    if (self.contentVC.rsp.settlePayType == 1) {
        [self.operationButton setTitle:@"完成" forState:0];
    }else if (self.contentVC.rsp.settlePayType == 0) {
        [self.operationButton setTitle:@"收款" forState:0];

    }else {
        NSString *title = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ? @"退款" : @"结算";
        [self.operationButton setTitle:title forState:0];

    }
 
}
- (IBAction)done:(id)sender {
    
    [self.contentVC done:nil];
    
}

@end
