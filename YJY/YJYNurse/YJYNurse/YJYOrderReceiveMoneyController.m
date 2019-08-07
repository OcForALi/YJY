//
//  YJYOrderReceiveMoneyController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/22.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderReceiveMoneyController.h"
#import "YJYOrderSettlPayCell.h"
#import "YJYOrderQRController.h"
#import "YJYRoleManager.h"

@interface YJYOrderReceiveMoneyContentController : YJYTableViewController

@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSArray<NSString*> *settDateArray;
@property (strong, nonatomic) SettlPayDetailRsp *rsp;
@property (copy, nonatomic) YJYOrderReceiveMoneyDidDoneBlock didDoneBlock;
@property(nonatomic, readwrite) uint32_t workType;
//cell



@property (weak, nonatomic) IBOutlet YJYOrderSettlPayCell *serviceListCell;
@property (weak, nonatomic) IBOutlet UILabel *servicePayLabel;


@property (weak, nonatomic) IBOutlet YJYOrderSettlPayCell *extraListCell;
@property (weak, nonatomic) IBOutlet UILabel *extraPayLabel;


@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *preDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *preLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *needPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;

@end

@implementation YJYOrderReceiveMoneyContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    [SYProgressHUD show];
    [self loadNetworkData];

}

- (void)loadNetworkData {
    
    SettlPayDetailReq *req = [SettlPayDetailReq new];
    req.orderId = self.orderId;
    req.settDateArray = [NSMutableArray arrayWithArray:self.settDateArray];
    
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
    
    
//    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@", self.rsp.order.orderId];
//    self.beServerLabel.text = self.rsp.order.kinsName;
//    self.serverLabel.text = self.rsp.order.serviceStaff.length > 0 ? self.rsp.order.serviceStaff : @"无";
//    self.timeLabel.text =  self.rsp.serviceTime;
    
    
//    UIColor *stateColor = APPREDCOLOR;
//    NSString *statusStr = self.rsp.order.status == 4 ? @"待结算" : @"待付款";
    
//    [self.stateButton setTitle:statusStr forState:0];
//    self.stateButton.backgroundColor = stateColor;
    
    [self.tableView reloadData];
    
    [self reloadServiceOrderItems];
    [self reloadExtraOrderItems];
    
    //
    self.totalPayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.expense];
    self.preDiscountLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.order.prepayAmount];
    self.preDiscountLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.preRealFee];
    self.needPayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.needPay];
    self.youhuiLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.hgRebateFee];

    self.preLeftLabel.text = [NSString stringWithFormat:@"%@%@元",self.rsp.payFlag == 2 ? @"待退款金额" : @"待收款金额",self.rsp.payFlag == 2 ? self.rsp.returnPay : self.rsp.expense];
    [self.tableView reloadData];


}

- (void)reloadServiceOrderItems {

    self.serviceListCell.expandView.expandType = OrderItemsExpandTypeSettleDetail;

    self.serviceListCell.orderSettlPayListArray = [NSMutableArray array];
    self.serviceListCell.orderSettlPayListArray = self.rsp.serviceListArray;
    
    self.servicePayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.serviceFee];
    __weak typeof(self) weakSelf = self;
    self.serviceListCell.didExpandBlock = ^{
        [weakSelf.tableView reloadData];
    };
}


- (void)reloadExtraOrderItems {
    self.extraListCell.expandView.expandType = OrderItemsExpandTypeSettleDetail;
    
    self.extraListCell.orderSettlPayListArray = [NSMutableArray array];
    self.extraListCell.orderSettlPayListArray = self.rsp.extraListArray;
    self.extraPayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.extraFee];

    __weak typeof(self) weakSelf = self;
    self.extraListCell.didExpandBlock = ^{
        [weakSelf.tableView reloadData];
    };
}
#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 1) {
        
        return [self.serviceListCell cellHeight];
        
    }else if(indexPath.row == 3){
    
        return [self.extraListCell cellHeight];
        
    } else if(indexPath.row == 7){
        
        return self.rsp.order.orderType == 2 ? 0 : 50;
        
    }else {
        
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        [cell.superview bringSubviewToFront:cell];
        cell.contentView.superview.clipsToBounds = NO;
    }
    
}
#pragma mark - Action 

- (IBAction)done:(id)sender {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
        
        // 1 = 无收退现金权限
        if (self.rsp.dudaoChargeConfig == 1) {
            
            [self toCashierSettlement];
            return;
        }
        
    }
    
    if (self.rsp.payFlag == 2) {
        [self toReceiveMoney];

    }else {

        [self toShowActionPay];

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

- (void)toShowActionPay {
    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"线上收款" otherButtonTitles:@[@"现金收款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            YJYOrderQRController *vc = [YJYOrderQRController instanceWithStoryBoard];
            vc.orderId = self.orderId;
            vc.URLType = 4;
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
- (void)toReceiveMoney {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否收到款项" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            [SYProgressHUD show];
            
            DoPayReq *req = [DoPayReq new];
            req.operation = @"PAY_ORDERSETTLE";
            req.payType = 5;
            req.orderId = self.orderId;
            req.monthsArray = [NSMutableArray arrayWithArray:self.settDateArray];;
            
            [YJYNetworkManager requestWithUrlString:SAASDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
                
                [SYProgressHUD hide];
                if (self.didDoneBlock) {
                    self.didDoneBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
            }];
            
        }
    }];
    
}
@end

@interface YJYOrderReceiveMoneyController ()

@property (strong, nonatomic) YJYOrderReceiveMoneyContentController *contentVC;

@end

@implementation YJYOrderReceiveMoneyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderReceiveMoneyController *)[UIStoryboard storyboardWithName:@"YJYOrderServices" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderReceiveMoneyContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.settDateArray = self.settDateArray;
        self.contentVC.workType = self.workType;
        
        __weak typeof(self) weakSelf = self;
        self.contentVC.didDoneBlock = ^{
            if (weakSelf.didDoneBlock) {
                weakSelf.didDoneBlock();
            }
        };
    }
    
}

- (IBAction)done:(id)sender {
    
    [self.contentVC done:nil];
    
}




@end
