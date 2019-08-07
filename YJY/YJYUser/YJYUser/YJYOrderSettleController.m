//
//  YJYOrderSettleController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/27.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderSettleController.h"
#import "YJYOrderPayoffController.h"
#import "YJYOrderPayOffDailyController.h"
#import "YJYInsureBonusController.h"
#import "YJYOrderAddAdjustController.h"
#import "YJYOrderReviewController.h"
#import "YJYOrderSettleListCell.h"
#import "YJYSuggestionController.h"

typedef NS_ENUM(NSInteger, OrderSettleType) {
    
    OrderSettleTypePackage,
    OrderSettleTypeOrderID ,
    OrderSettleTypeContact ,
    OrderSettleTypeLocation,
    OrderSettleTypeBookTime,
    OrderSettleTypeBookBeginTime,
    OrderSettleTypeService,
    OrderSettleTypeHospitalNumber,
    OrderSettleTypeCostTotal,
    OrderSettleTypeFeedback,
    OrderSettleTypeAdjust,
    OrderSettleTypeAdjustList,
    
};

@interface YJYOrderInfoController : UITableViewController

//package
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;


//orderid

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStartTimeLabel;

//info
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderBeginLabel;

@property (weak, nonatomic) IBOutlet UILabel *beServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *preCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *extraCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *insureDetailButton;
@property (weak, nonatomic) IBOutlet YJYOrderSettleListCell *settleListCell;

@property (weak, nonatomic) IBOutlet UILabel *adjustMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *adjustTimeLabel;

//data

@property (strong, nonatomic) GetOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) OrderVO *order;
@property (strong, nonatomic) NSString *orderID;

@end

@implementation YJYOrderInfoController


- (void)setupOrder {

        
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号: %@",self.order.orderId];
    
    OrderVO *order = self.order;

    NSString *statusText;
    UIColor  *statusColor;
    
    if (order.status == OrderStatus_ServiceIng) {
        
        
        statusText = @"服务中";
        statusColor = kServiceIngColor;
        
        
    }else if (order.status == OrderStatus_ServiceComplete) {
        statusText = @"待结算";
        statusColor = kWaitCheckoutColor;
        
        
    }else if (order.status == OrderStatus_WaitAppraise) {
        statusText = @"待服务";
        statusColor = kWaitAppraiseColor;
        
        
        
    }else if (order.status == OrderStatus_OrderComplete) {
        statusText = @"已完成";
        statusColor = kOrderCompleteColor;
        
    }
    self.stateLabel.textColor = statusColor;
    self.stateLabel.text = order.statusStr;
    
    //time
    
    self.orderTimeLabel.text = self.order.serviceTime;
    self.orderBeginLabel.text = self.order.orderStartTime;

    self.orderStartTimeLabel.text = [NSString stringWithFormat:@"订单时间: %@",self.order.createTime];
    
    
    //address
    
    self.packageLabel.text = self.order.service;
    [self.packageLabel sizeToFit];
    
    self.beServiceLabel.text = self.order.kinsName;
    self.serviceLabel.text = self.order.serviceStaff;
    self.nameLabel.text = self.order.contactName;
    self.phoneLabel.text = self.order.contactPhone;
    self.hospitalNumberLabel.text = self.order.orgNo;
    
    if (self.order.orderType == 2) {
        
        self.addressLabel.attributedText = [self.order.location attributedStringWithLineSpacing:8];;
        [self.addressLabel sizeToFit];
        
    }else {
        
        NSString *des = [NSString stringWithFormat:@"%@ %@ %@ %@",self.order.hospital,self.order.branch,self.order.room,self.order.bed];
        self.addressLabel.attributedText = [des attributedStringWithLineSpacing:8];;
        [self.addressLabel sizeToFit];
        
        
    }
    
      //
    self.totalCostLabel.text = self.orderDetailRsp.confirmCost;
    self.preCostLabel.text = self.orderDetailRsp.order.preRealFee;
    
    
    [self.totalCostLabel sizeToFit];
    [self.preCostLabel sizeToFit];
    
    //insure
    
    self.insureDetailButton.hidden = !(self.orderDetailRsp.order.insureType == 1);
    
    self.stateLabel.text = order.statusStr;
    
    //adjust
    
    self.adjustTimeLabel.text = [NSString stringWithFormat:@"服务调整时间:%@",self.orderDetailRsp.order.updateTime];
    
    self.adjustMoneyLabel.text = [NSString stringWithFormat:@"附加服务:%@元",self.orderDetailRsp.order.reviseFee];

    [self.tableView reloadData];
    
    
    
}

- (void)setupListCell {
    
    __weak typeof(self) weakSelf = self;
    
    self.settleListCell.didDetailAction = ^(SettlementVO *settlement) {
     

        YJYOrderPayOffDailyController *vc = [YJYOrderPayOffDailyController instanceWithStoryBoard];
        vc.order = weakSelf.orderDetailRsp.order;
        vc.settDate = settlement.settleDate;
        
        [weakSelf.navigationController pushViewController:vc animated:YES];

    };
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == OrderSettleTypeLocation) {
        
        //addressLabel
        NSInteger lines = [NSString numberOfLinesWithLabel:self.addressLabel];
        if (lines > 1) {
            
            return 74 + 25;
        }else {
        
            return 74;
        }
        
        
    }else if(indexPath.row == OrderSettleTypeBookBeginTime) {
        
        return self.orderDetailRsp.order.status >= 3 && self.orderDetailRsp.order.orderStartTime.length > 0 ? 70 : 0;
        
    }else if (indexPath.row == OrderSettleTypeHospitalNumber) {
        
        //住院号
        return self.orderDetailRsp.order.orderType == 1  ? 50 : 0;
        
    }else if (indexPath.row >= OrderSettleTypeCostTotal && indexPath.row <= OrderSettleTypeFeedback) {
        
        //补贴余额
        return self.orderDetailRsp.order.status >= 3 ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
        
    }else if (indexPath.row == OrderSettleTypeAdjust) {
        
        //调整
        return self.orderDetailRsp.order.reviseFee.length > 0 ? 120 : 0;
        
    }else if (indexPath.row == OrderSettleTypeAdjustList) {
        
        //子订单
        return [self.settleListCell cellHeight];
        
    }else {
    
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        
    }
    
    
}
#pragma mark - Action

- (IBAction)insureDetailAction:(id)sender {


    YJYInsureBonusController *vc = [YJYInsureBonusController instanceWithStoryBoard];
    vc.orderId = self.order.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toAddServiceAdjustAction:(id)sender {
    
    YJYOrderAddAdjustController *vc = [YJYOrderAddAdjustController instanceWithStoryBoard];
    vc.orderVo = self.orderDetailRsp.order;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)toFeedback {
    
    YJYSuggestionController *vc = [YJYSuggestionController instanceWithStoryBoard];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end




#pragma mark - YJYOrderSettleController

@interface YJYOrderSettleController ()

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) YJYOrderInfoController *orderInfoController;
@property (strong, nonatomic) GetOrderDetailRsp *orderDetailRsp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;


@end

@implementation YJYOrderSettleController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYOrderInfoController"]) {
        
        
        self.orderInfoController = (YJYOrderInfoController *)segue.destinationViewController;
        self.orderInfoController.order = self.order;
        self.orderInfoController.orderID = self.orderId;
    }
    
}

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderSettleController *)[UIStoryboard storyboardWithName:@"YJYOrderDetail" viewControllerIdentifier:NSStringFromClass(self)];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isToRoot) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];
    }
}
- (void)close {
    
    
    
    [SYProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SYProgressHUD hide];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    GetOrderReq *req = [GetOrderReq new];
    
    if (self.order) {
        req.orderId = self.order.orderId;
        
    }else {
        
        req.orderId = self.orderId;
    }
    
    [SYProgressHUD show];
    
    
    [YJYNetworkManager requestWithUrlString:APPGetOrderDetail message:req controller:self command:APP_COMMAND_AppgetOrderDetail success:^(id response) {
        
        GetOrderDetailRsp *rsp = [GetOrderDetailRsp parseFromData:response error:nil];
        self.orderDetailRsp = rsp;
        self.order = rsp.order;
        
        
        
        [self reloadInfoControllerData];
        
        [SYProgressHUD hide];
        
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];

        if (error.code == 8 && error.userInfo[@"msg"]) {
            [UIAlertController showAlertInViewController:self withTitle:error.userInfo[@"msg"] message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];

            }];
        }
        
    }];
    
}

- (void)reloadInfoControllerData {
    
    self.orderInfoController.orderDetailRsp = self.orderDetailRsp;

    self.orderInfoController.order = self.orderDetailRsp.order;
    [self.orderInfoController setupOrder];
    
    [self setupListCell];

    if (self.order.status == OrderStatus_ServiceIng) {
        [self.actionButton setTitle:@"客服电话" forState:0];
        self.actionButton.hidden = (self.orderDetailRsp.voListArray_Count == 0);

    }else if (self.order.status == OrderStatus_ServiceComplete) {
        
        [self.actionButton setTitle:@"结 算" forState:0];
        self.actionButton.hidden = (self.orderDetailRsp.voListArray_Count == 0);
        
    }else if (self.order.status == OrderStatus_WaitAppraise) {
        [self.actionButton setTitle:@"去评价" forState:0];
        
    }else if (self.order.status == OrderStatus_OrderComplete) {
        [self.actionButton setTitle:@"查看评价" forState:0];
        
    }
    self.tableBottomConstraint.constant = self.actionButton.hidden ? 0 : 60;
    
    [self.orderInfoController.tableView reloadData];
}
- (void)setupListCell {

    self.orderInfoController.settleListCell.order = self.orderDetailRsp.order;
    self.orderInfoController.settleListCell.voListArray = self.orderDetailRsp.voListArray;
    [self.orderInfoController.settleListCell.tableView reloadData];
    [self.orderInfoController setupListCell];

}

#pragma mark - Action


- (IBAction)operationAction:(id)sender {
    
    NSMutableArray *settDateArray = [NSMutableArray array];

    if (self.orderDetailRsp.order.status == OrderStatus_ServiceIng) {

        [SYProgressHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.order.kfPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [SYProgressHUD hide];
        });
        
//        BOOL allPaid = NO;
//        for (SettlementVO *aSettlement in self.orderDetailRsp.voListArray) {
//            if (aSettlement.payState == 1) {
//                allPaid = YES;
//            }
//        }
//
//        NSString *title = @"请勾选收款项";
//        if (allPaid) {
//            title = @"暂无待缴金额";
//        }
//
//        if (settDateArray.count > 0 || [self.orderInfoController.settleListCell settDateArray].count == 0) {
//
//            [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:title message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//
//            }];
//            return;
//        }
//        //服务中
//
//
//        YJYOrderPayoffController *vc = [YJYOrderPayoffController instanceWithStoryBoard];
//        vc.order = self.order;
//        vc.settDateArray = [self.orderInfoController.settleListCell settDateArray];
//
//
//        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.orderDetailRsp.order.status == 4) {
        //结算
        for (SettlementVO *aSettlement in self.orderDetailRsp.voListArray) {
            [settDateArray addObject:aSettlement.settleDate];
            
        }
        
        if (settDateArray.count == 0) {
            [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"暂无待缴金额" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
            }];
            return;
        }
        
        YJYOrderPayoffController *vc = [YJYOrderPayoffController instanceWithStoryBoard];
        vc.order = self.order;
        vc.settDateArray = settDateArray;
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.order.status == OrderStatus_WaitAppraise || self.order.status == OrderStatus_OrderComplete){
        
        //评价
        YJYOrderReviewController *vc = [YJYOrderReviewController instanceWithStoryBoard];
        vc.order = self.order;
        vc.isEdit = (self.order.status != OrderStatus_OrderComplete);
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
    
    
 
}




@end
