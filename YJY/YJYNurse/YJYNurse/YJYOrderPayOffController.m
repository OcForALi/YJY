//
//  YJYOrderPayOffController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/9.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPayOffController.h"
#import "YJYOrderPayOffCell.h"
#import "YJYPayOffComfireAddController.h"
#import "YJYOrderQRController.h"

#pragma mark - YJYOrderPayOffContentController

@interface YJYOrderPayOffContentController : YJYTableViewController

//data

@property (strong, nonatomic) NSString *orderId;
@property(nonatomic, readwrite) NSArray<NSString*> *settDateArray;
@property (strong, nonatomic) SettlPayDetailRsp *rsp;
@property (assign, nonatomic) BOOL isModifyPayOff;
@property (copy, nonatomic) YJYDidDoneBlock didDoneBlock;


@property (strong, nonatomic)  GetOrderInfoRsp *orderInfoRsp;

//view
@property (weak, nonatomic) IBOutlet YJYOrderPayOffCell *baseServiceCell;
@property (weak, nonatomic) IBOutlet YJYOrderPayOffCell *addServiceCell;

//fee
@property (weak, nonatomic) IBOutlet UILabel *baseServiceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addServiceFeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UILabel *preDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *primeLabel;


@property (weak, nonatomic) IBOutlet UILabel *shouldOutLabel;


@end

@implementation YJYOrderPayOffContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.shouldOutLabel.textColor = [UIColor redColor];
    self.shouldOutLabel.font = [UIFont boldSystemFontOfSize:16];

    __weak __typeof(self)weakSelf = self;
    
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
    
    SettlPayDetailReq *req = [SettlPayDetailReq new];
    req.orderId = self.orderId;
    req.settDateArray = [NSMutableArray arrayWithArray:self.settDateArray];
    if (self.settDateArray.count == 0) {
        req.status = 1;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSettlPayDetail message:req controller:self command:APP_COMMAND_SaasappsettlPayDetail success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp = [SettlPayDetailRsp parseFromData:response error:nil];
        
        
        [self reloadAllData];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)reloadRsp {
    
   // cell
    
    self.baseServiceCell.orderSettlPayListArray = self.rsp.serviceListArray;
    self.addServiceCell.orderSettlPayListArray = self.rsp.extraListArray;
    self.baseServiceFeeLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.serviceTotalFee];
    self.addServiceFeeLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.extraTotalFee];
    
    // price
    self.totalPayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.totalFee];
    self.paidLabel.text = [NSString stringWithFormat:@"-%@元",self.rsp.realPay];
    self.preDiscountLabel.text = [NSString stringWithFormat:@"-%@元",self.rsp.preRealFee];
    self.primeLabel.text = [NSString stringWithFormat:@"-%@元",self.rsp.hgRebateFee];
    
    if (self.rsp.order.status == YJYOrderStateWaitPayOff) {
        self.shouldOutLabel.text = [NSString stringWithFormat:@"%@%@元",self.rsp.payFlag != 1 ? @"待退款金额: " : @"待支付金额: ",(self.rsp.payFlag == 2 ? self.rsp.returnPay : self.rsp.needPay)];
        
    }else {
        
        self.shouldOutLabel.text = [NSString stringWithFormat:@"%@%@元",self.rsp.payFlag == 2 ? @"待退款金额: " : @"待支付金额: ",(self.rsp.payFlag == 2 ? self.rsp.returnPay : self.rsp.needPay)];

    }
    
    [self.tableView reloadData];
    [self.baseServiceCell.tableView reloadData];
    [self.addServiceCell.tableView reloadData];
  
}

#pragma mark - Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return [self.baseServiceCell cellHeight];
    }else if (indexPath.row == 2) {
        return [self.addServiceCell cellHeight];
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Action

- (IBAction)done:(id)sender {
    
    ///0-费用刚好 1-需要支付 2-需要退款
    
    if (self.rsp.order.status == YJYOrderStateServing) {
        
        if (self.rsp.payFlag == 2) {
            
            [self toReceiveMoney];
        }else {
            [self toShowActionPay];
            
        }
    }else if (self.rsp.order.status == YJYOrderStateWaitPayOff) {
        
        if (self.rsp.payFlag == 1) {
            
            [self toShowActionPay];

        }else if (self.rsp.payFlag == 0){
            
            [self toReceiveMoney];

        }else {
            [self toReturn];

        }
        
    }
    
}


- (void)toCashierSettlement{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请提示用户到收费处进行结算！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)toReceiveMoney {
    
    if (self.isModifyPayOff) {
        
        YJYPayOffComfireAddController *vc = [YJYPayOffComfireAddController instanceWithStoryBoard];
        vc.title = @"修改附加服务";
        vc.orderId = self.orderId;
        vc.orderState = self.rsp.order.status;
        vc.affirmTime = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        NSString *title = [NSString stringWithFormat:@"确认已收取现金%@元",self.rsp.needPay];
     
        if (self.rsp.order.status == YJYOrderStateWaitPayOff) {
            if (self.rsp.payFlag == 0) {
                title = @"是否确定结算订单？";
            }else if (self.rsp.payFlag == 2) {
                [self toReturn];
                return;
            }

        }
        
        [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                if (self.rsp.order.status == YJYOrderStateServing) {
                    self.rsp.payFlag == 2 ? [self toComfire] : [self toPayAction];
                }else {
                    
                    if (self.rsp.payFlag == 1) {
                        
                        [self toPayAction];
                        
                    }else if (self.rsp.payFlag == 0){
                        
                        [self toComfire];

                    }else {
                     
                        [self toReturn];
                    }
                    
                }
                
            }
            
        }];
        
    }
    
}
- (void)callDudao {

    
    NSString *des = [NSString stringWithFormat:@"是否向督导发送收款请求"];
    
    
    [UIAlertController showAlertInViewController:self withTitle:des message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            OrderJPushReq *req = [OrderJPushReq new];
            req.orderId = self.rsp.order.orderId;
            req.jpushType = 3;
            [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"发送成功"];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
    
}

- (void)toShowActionPay{

    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"线上收款" otherButtonTitles:@[@"现金收款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            YJYOrderQRController *vc = [YJYOrderQRController instanceWithStoryBoard];
            vc.orderId = self.rsp.order.orderId;
            vc.URLType = 2;
            vc.didDoneBlock = ^{
                if (self.didDoneBlock) {
                    self.didDoneBlock();
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (buttonIndex == 2){
            
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
                
                [self callDudao];
            }else {
                [self toReceiveMoney];
            }
            
            
        }
        
    }];
}

- (void)toPayAction {

    DoPayReq *req = [DoPayReq new];
    req.operation = @"PAY_ORDERSETTLE";
    req.payType = 5;
    req.orderId = self.orderId;
    req.monthsArray = [NSMutableArray arrayWithArray:self.settDateArray];;
    
    [YJYNetworkManager requestWithUrlString:SAASDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
        
        [SYProgressHUD hide];
        
        YJYOrderPayOffController *pvc = (YJYOrderPayOffController *)self.parentViewController;
        
        if (pvc.didDoneBlock) {
            pvc.didDoneBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 退款
- (void)toReturn {
    
    if (self.rsp.returnType == 2) {
        
        [self toReturnOnline];

    }else {
    
        [self toReturnCash];
        
    }
   
}
- (void)toReturnOnline {
    [UIAlertController showAlertInViewController:self withTitle:@"是否确定结算？（退款将在3-5个工作日内原路退回支付账户）" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self toReturnToUserWithRefundPayType:53];
            
        }
        
    }];
    
}
- (void)toReturnCash {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {

        // 1 = 无收退现金权限
        if (self.rsp.dudaoChargeConfig == 1) {

            [self toCashierSettlement];
            return;
        }else{

            NSString *title = [NSString stringWithFormat:@"是否确定已将现金%@元退回用户？",self.rsp.returnPay];
            [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [self toReturnToUserWithRefundPayType:72];
                    
                }
                
            }];
            return;

        }

    }
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        if (self.rsp.dudaoChargeConfig == 1) {
            
           [self toCashierSettlement];
            return;
            
        }else{
            
            [self toReturnCallDoudao];
            return;
            
        }
        
    }
    
    
    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"退款至账户余额" otherButtonTitles:@[@"现金退款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [self toReturnOnline];
            
        }else if (buttonIndex == 2) {
            
            if (self.rsp.dudaoChargeConfig == 2) {
                if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
                    
                    [self toReturnCallDoudao];
                    
                }else {
                    NSString *title = [NSString stringWithFormat:@"是否确定退现金%@元",self.rsp.returnPay];
                    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        
                        if (buttonIndex == 1) {
                            [self toReturnToUserWithRefundPayType:72];

                        }
                        
                    }];
                    
                    
                }
                
            }else {
                [UIAlertController showAlertInViewController:self withTitle:@"请提示用户到收费处进行结算！" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                }];
                
            }
            
        }
        
    }];
}
- (void)toReturnToUserWithRefundPayType:(uint32_t)refundPayType {
    
    [SYProgressHUD show];
    
    ConfirmOrderFinishNewReq *req = [ConfirmOrderFinishNewReq new];
    req.orderId = self.rsp.order.orderId;
    req.refundPayType = refundPayType;
    [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderFinishNew message:req controller:self command:APP_COMMAND_SaasappconfirmOrderFinishNew success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"退款成功"];
        YJYOrderPayOffController *pvc = (YJYOrderPayOffController *)self.parentViewController;
        if (pvc.didDoneBlock) {
            pvc.didDoneBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)toReturnCallDoudao {
    
    NSString *des = [NSString stringWithFormat:@"是否通知督导现金退款？"];
    
    
    [UIAlertController showAlertInViewController:self withTitle:des message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            OrderJPushReq *req = [OrderJPushReq new];
            req.orderId = self.rsp.order.orderId;
            req.jpushType = 3;
            [YJYNetworkManager requestWithUrlString:SAASAPPOrderJPush message:req controller:self command:APP_COMMAND_SaasapporderJpush success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"发送成功"];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
- (void)toComfire {
    
    
    if (self.rsp.dudaoChargeConfig == 2) {
        
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
            
            [self toReturnCallDoudao];
            
        }else {
            GetOrderReq *req = [GetOrderReq new];
            req.orderId  = self.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderFinish message:req controller:nil command:APP_COMMAND_SaasappconfirmOrderFinish success:^(id response) {
                
                [SYProgressHUD hide];
                
                YJYOrderPayOffController *pvc = (YJYOrderPayOffController *)self.parentViewController;
                if (pvc.didDoneBlock) {
                    pvc.didDoneBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }
        
       
        
    }else {
        [UIAlertController showAlertInViewController:self withTitle:@"请提示用户到收费处进行结算！" message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        
    }

   
}


@end

@interface YJYOrderPayOffController ()

@property (strong, nonatomic) YJYOrderPayOffContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@end

@implementation YJYOrderPayOffController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderPayOffContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.settDateArray = self.settDateArray;
        self.contentVC.isModifyPayOff = self.isModifyPayOff;
        self.contentVC.orderInfoRsp = self.orderInfoRsp;
        self.contentVC.didDoneBlock = ^{
            if (self.didDoneBlock) {
                self.didDoneBlock();
            }
        };
    }
}
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPayOffController *)[UIStoryboard storyboardWithName:@"YJYOrderPayOff" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.isModifyPayOff) {
        [self.operationButton setTitle:@"修改附加服务" forState:0];
    }else {
        [self.operationButton setTitle:@"结算" forState:0];
    }
}
- (IBAction)done:(id)sender {
    
    [self.contentVC done:nil];
    
}
@end
