//
//  YJYInsureOrderDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderDetailController.h"
#import "YJYWorkDetailController.h"
#import "YJYInsureEstimateFeeController.h"
#import "YJYInsureOtherFeeController.h"
#import "YJYInsureReturnrFeeController.h"
#import "YJYInsureOrderTotalFeeController.h"
#import "YJYInsureContinuelFeeController.h"
#import "YJYInsureReviewApplyController.h"

#import "YJYInsureBackVisitListController.h"
#import "YJYInsureCarePlanController.h"
#import "YJYInsureDailyListController.h"

#import "YJYInsureReApplyDetailController.h"


#import "MDHTMLLabel.h"

typedef NS_ENUM(NSInteger, YJYInsureOrderDetailType) {
    
    YJYInsureOrderDetailTypeHeader,
    YJYInsureOrderDetailTypeHeaderProcessReviewed,
    YJYInsureOrderDetailTypeHeaderProcessReviewing,

    //1.
    YJYInsureOrderDetailTypeServerInfo,
    YJYInsureOrderDetailTypeServerInfoPlan,
    YJYInsureOrderDetailTypeServerInfoIssue,
    YJYInsureOrderDetailTypeServerInfoVisit,
    YJYInsureOrderDetailTypeServerInfoReturnTime,
    YJYInsureOrderDetailTypeServerInfoBlank,

    //2.
    YJYInsureOrderDetailTypeServer,
    YJYInsureOrderDetailTypeServerWorker,
    YJYInsureOrderDetailTypeServerNurse,
    YJYInsureOrderDetailTypeServerHealthManager,
    YJYInsureOrderDetailTypeServerBlank,
    
    //3.
    YJYInsureOrderDetailTypeOrder,
    YJYInsureOrderDetailTypeOrderInfo,
    YJYInsureOrderDetailTypeOrderInfoBlank,
    
    //4.
    YJYInsureOrderDetailTypeBeServerTitle,
    YJYInsureOrderDetailTypeBeServer,
    YJYInsureOrderDetailTypeBeServerContact,
    YJYInsureOrderDetailTypeBeServerContactBlank,
    
    //5.
    YJYInsureOrderDetailTypeReturnInfo,
    YJYInsureOrderDetailTypeReturnInfoMoney,
    YJYInsureOrderDetailTypeReturnInfoProcess,
    YJYInsureOrderDetailTypeReturnInfoBlank,
    
    //6.
    YJYInsureOrderDetailTypeOtherFee,
    YJYInsureOrderDetailTypeOtherReturnFee,
    YJYInsureOrderDetailTypeOtherReturnBlank,
    
    //7.
    YJYInsureOrderDetailTypeZizhaoFamily,
    YJYInsureOrderDetailTypeZizhaoFamilyInfo,
    YJYInsureOrderDetailTypeZizhaoFamilyBlank,
    
    //8.
    YJYInsureOrderDetailTypeServerTime,
    YJYInsureOrderDetailTypeServerOrderMoney,
    YJYInsureOrderDetailTypeServerOrderDiscount,

};

@interface YJYInsureOrderDetailContentController : UITableViewController

//头部
@property (weak, nonatomic) IBOutlet UIView  *serverInfoView;
@property (weak, nonatomic) IBOutlet UILabel *serverItemLabel;
@property (weak, nonatomic) IBOutlet UIButton *serverItemActionButton;
@property (weak, nonatomic) IBOutlet UILabel *serverStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverTipLabel;

//服务信息
@property (weak, nonatomic) IBOutlet UILabel *workerServedDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *workerReturnTimeLabel;

//服务人员
@property (weak, nonatomic) IBOutlet UILabel* workerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* nurseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* healthManagerNameLabel;

//订单信息
@property (weak, nonatomic) IBOutlet UILabel* serverBusinesserLabel;
@property (weak, nonatomic) IBOutlet UILabel* orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel* orderCreateLabel;
@property (weak, nonatomic) IBOutlet UILabel* orderBookLabel;
@property (weak, nonatomic) IBOutlet UILabel* orderEndLabel;

//被服务人
@property (weak, nonatomic) IBOutlet UILabel* beServerLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel* contactLabel;
@property (weak, nonatomic) IBOutlet UILabel* contactAddressLabel;

//退款
@property (weak, nonatomic) IBOutlet UILabel* returnMoneyLabel;


//额外费用
@property (weak, nonatomic) IBOutlet UILabel* otherReturnMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel* otherReceiverMoneyLabel;


//自照家属

@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyRelationLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *familyContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyQualificationLabel;

//other

@property (weak, nonatomic) IBOutlet UILabel *serverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDiscountLabel;


//data

@property (strong, nonatomic) GetHomeOrderDetailRsp *rsp;
@property (strong, nonatomic) NSMutableArray<OrderStatusVO*> *statusVolistArray;


//非自照
@property (weak, nonatomic) IBOutlet UIView *noZiZhaoProcessView;


//自照

@property (weak, nonatomic) IBOutlet UIView *ziZhaoProcessView;


//退款
@property (weak, nonatomic) IBOutlet UIView *returnProcessView;


//data

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverItemViewHConstraint;

@property(nonatomic, readwrite) NSString *orderId;

@end

@implementation YJYInsureOrderDetailContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [self navigationBarAlphaWithWhiteTint];
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];

    
    
}

- (void)loadNetworkData {
    
   
    [SYProgressHUD show];
    
    GetOrderReq *req = [GetOrderReq new];
    req.orderId =  [self orderId];

    [YJYNetworkManager requestWithUrlString:APPGetHomeOrderDetail message:req controller:self command:APP_COMMAND_AppgetHomeOrderDetail success:^(id response) {
    
        [SYProgressHUD hide];
        self.rsp = [GetHomeOrderDetailRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadRsp {
    
    self.orderIdLabel.text = self.rsp.order.orderId;
    self.serverStateLabel.text = self.rsp.statusStr;
    self.serverTipLabel.text = self.rsp.statusDesc;
    self.serverItemLabel.text = self.rsp.order.serviceItem;
    self.orderTotalLabel.text = [NSString stringWithFormat:@"%@元",@(self.rsp.order.fee)];

    //
    self.workerServedDayLabel.text = [NSString stringWithFormat:@"已服务%@天",@(self.rsp.serviceDateNum)];
    
    NSString *actionTitle;

    if (self.rsp.order.status == OrderStatus_WaitPayPrefee) {
        actionTitle = @"取消订单";
        self.serverItemActionButton.hidden = NO;
        
    }else if (self.rsp.order.status == OrderStatus_Cancel) {
        actionTitle = @"重新下单";
        self.serverItemActionButton.hidden = NO;
    }else {
        self.serverItemActionButton.hidden = YES;

    }
    self.serverItemActionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.serverItemActionButton.layer.borderWidth = 1;
    self.serverItemActionButton.layer.cornerRadius = 5;
    
    [self.serverItemActionButton setTitle:actionTitle forState:0];
    
    //
    self.serverItemViewHConstraint.constant = self.rsp.order.serviceType == 82 ? 60 : 90;
    self.serverInfoView.layer.cornerRadius = 10;
    [self.serverInfoView yjy_setTopShadow];
    [self.serverInfoView yjy_setBottomShadow];
    
    //服务人员
    self.workerNameLabel.text = self.rsp.order.hgName;
    self.nurseNameLabel.text = self.rsp.order.insureHsName;
    self.healthManagerNameLabel.text = self.rsp.order.managerName;
    
    //订单信息
    self.orderIdLabel.text = self.rsp.order.orderId;
    self.serverBusinesserLabel.text = self.rsp.companyName;
    self.orderCreateLabel.text = self.rsp.createTime;
    self.orderBookLabel.text = self.rsp.orderStartTime;
    self.orderEndLabel.text = self.rsp.orderEndTime;
    
    //联系方式
    self.beServerLabel.text = self.rsp.order.relationName;
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:self.rsp.order.fullName phone:self.rsp.order.contactPhone];
    self.contactAddressLabel.text = self.rsp.order.addrDetail;

    //自照家属
    self.familyNameLabel.text = self.rsp.order.relationName;
    self.familyRelationLabel.text = self.rsp.order.relation;
    self.familyContactLabel.htmlText = [NSString yjy_PhoneNumberStringWithOrigin:self.rsp.order.contactPhone];
    self.familyQualificationLabel.text = self.rsp.isHg ? @"已获取":@"未获取";
    
    //process
    
    if (self.rsp.isTendNew) {
        
        [self setupProcessWithView:self.ziZhaoProcessView];
        
    }else {
        
        [self setupProcessWithView:self.noZiZhaoProcessView];
    }
}

- (void)setupProcessWithView:(UIView *)view {
    
    for (NSInteger i = 0; i < self.rsp.statusVolistArray.count; i++) {
        OrderStatusVO *orderStatusVO = self.rsp.statusVolistArray[i];
        
        UIImageView *imgView = [view viewWithTag:i+1];
        UIImageView *lastView = [view viewWithTag:(i) * 10];
        UIImageView *barView = [view viewWithTag:(i+1) * 10];
        
        if (orderStatusVO.isLight) {
            
            imgView.image = [UIImage imageNamed:@"insure_done_progress_icon"];
            
            if (lastView && [lastView isKindOfClass:[UIImageView class]]) {
                lastView.image = [UIImage imageNamed:@"insure_progress_bg"];
                
            }
            if (barView && [barView isKindOfClass:[UIImageView class]]) {
                barView.image = [UIImage imageNamed:@"insure_progress_orange_white"];
            }
            
            
            
        }else {
            
            if (i == 0) {
                imgView.image = [UIImage imageNamed:@"insure_process_white_orange_icon"];
                if (barView && [barView isKindOfClass:[UIImageView class]]) {
                    barView.image = [UIImage imageNamed:@"insure_progress_orange_white"];
                    
                }
            }else {
                
                imgView.image = [UIImage imageNamed:@"insure_progress_white"];
                if (barView && [barView isKindOfClass:[UIImageView class]]) {
                    barView.image = [UIImage imageNamed:@"insure_progress_white"];
                    
                }
                
            }
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];

    
    if (indexPath.row == YJYInsureOrderDetailTypeHeaderProcessReviewed) {
        
        return self.rsp.isTendNew && self.rsp.order.status != OrderStatus_ServiceComplete ? height : 0;
    
    }else if (indexPath.row == YJYInsureOrderDetailTypeHeaderProcessReviewing) {
    
        return !self.rsp.isTendNew && self.rsp.order.status != OrderStatus_ServiceComplete ?  height : 0;

    }else if (indexPath.row >= YJYInsureOrderDetailTypeServerInfo &&
              indexPath.row <= YJYInsureOrderDetailTypeServerInfoBlank) {
        
        if (self.rsp.order.status == OrderStatus_ServiceIng || self.rsp.order.status == OrderStatus_ServiceComplete) {
            return height;
        }else {
            return 0;
        }
    }else if (indexPath.row == YJYInsureOrderDetailTypeOrderInfo){
        
        if (self.rsp.order.status == OrderStatus_ServiceIng){
            
            height = 130;
            
        }else if (self.rsp.order.status == OrderStatus_ServiceComplete) {
           
            height = 170;
            
        }else {
            
            height = 100;
        }
        return height;

        
    }else if (indexPath.row == YJYInsureOrderDetailTypeServer) {
        
        return self.rsp.order.status == OrderStatus_WaitPayPrefee ? 0 : height;
        
    }else if (indexPath.row == YJYInsureOrderDetailTypeServerNurse) {
        
        return self.rsp.order.status > OrderStatus_WaitService ? 0 : height;

    }else if (indexPath.row == YJYInsureOrderDetailTypeServerHealthManager) {
        
        return self.rsp.order.status != OrderStatus_WaitPayPrefee ? 0 : height;
       
        
    }
    //非自照
    else if (indexPath.row >= YJYInsureOrderDetailTypeReturnInfo &&
              indexPath.row <= YJYInsureOrderDetailTypeReturnInfoBlank) {
        return 0;
        
    }else if (indexPath.row >= YJYInsureOrderDetailTypeOtherFee &&
              indexPath.row <= YJYInsureOrderDetailTypeOtherReturnBlank) {
        return 0;
        
    }else if (indexPath.row >= YJYInsureOrderDetailTypeServerTime &&
              indexPath.row <= YJYInsureOrderDetailTypeServerOrderDiscount) {
        
        return 0;
        
    }else if (indexPath.row == YJYInsureOrderDetailTypeServerWorker) {
        
        return 0;
        
    }
    
    return height;
}

#pragma mark - Action
- (IBAction)toOperaAction:(id)sender {
    
    if (self.rsp.order.status == OrderStatus_Cancel) {
       
        
        YJYInsureReviewApplyController *vc = [YJYInsureReviewApplyController instanceWithStoryBoard];
        vc.insureNo = self.rsp.order.insureNo;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (self.rsp.order.status == OrderStatus_WaitPayPrefee) {
      
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否取消" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [SYProgressHUD show];
                CancelOrderReq *req = [CancelOrderReq new];
                req.orderId = self.rsp.order.orderId;
                req.serviceDate = self.rsp.orderEndTime;
                
                [YJYNetworkManager requestWithUrlString:APPCancelOrder message:req controller:self command:APP_COMMAND_AppcancelOrder success:^(id response) {
                    
                    [self loadNetworkData];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
            
        }];
        
    }
}

#pragma mark - Action
//回访记录
- (IBAction)toBackVisitPlan:(id)sender {
    
    YJYInsureBackVisitListController *vc = [YJYInsureBackVisitListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}

//陪护计划

- (IBAction)toPeihuPlan:(id)sender {

    YJYInsureCarePlanController *vc = [YJYInsureCarePlanController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}
//每日明细

- (IBAction)toDailyListPlan:(id)sender {
    
    
    YJYInsureDailyListController *vc = [YJYInsureDailyListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.rsp;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//续费服务

- (IBAction)toContinuePay:(id)sender {
    
    YJYInsureContinuelFeeController *vc = [YJYInsureContinuelFeeController instanceWithStoryBoard];
    vc.orderDetailRsp = self.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}
//补贴

- (IBAction)toButiePay:(id)sender {
    
    YJYInsureEstimateFeeController *vc = [YJYInsureEstimateFeeController instanceWithStoryBoard];
    vc.orderDetailRsp = self.rsp;
    vc.title = @"补贴";
    [self.navigationController pushViewController:vc animated:YES];
}

/// 1-护工 2-护士

- (IBAction)toCheckHG:(id)sender {
    
    YJYWorkDetailController *vc = [YJYWorkDetailController instanceWithStoryBoard];
    vc.orderId = self.rsp.order.orderId;
    vc.hgType = 1;
    vc.title = @"护理师资料";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)toCheckHS:(id)sender {
    
    YJYWorkDetailController *vc = [YJYWorkDetailController instanceWithStoryBoard];
    vc.orderId = self.rsp.order.orderId;
    vc.hgType = 2;
    vc.title = @"护士资料";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)toCheckApply:(id)sender {
    
    YJYInsureReApplyDetailController *vc = [YJYInsureReApplyDetailController instanceWithStoryBoard];
    vc.orderDetailRsp = self.rsp;
    vc.title = @"申请详情";
    [self.navigationController pushViewController:vc animated:YES];

    
}

@end

@interface YJYInsureOrderDetailController ()
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (strong, nonatomic) YJYInsureOrderDetailContentController *contentVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarViewHConstraint;

@end

@implementation YJYInsureOrderDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureOrderDetailController *)[UIStoryboard storyboardWithName:@"YJYInsureOrderDetail" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"YJYInsureOrderDetailContentController"]) {
        
        self.contentVC = (YJYInsureOrderDetailContentController *)segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstButton.hidden = self.orderState != OrderStatus_ServiceIng;
    self.toolbarViewHConstraint.constant = self.orderState != OrderStatus_ServiceIng ? 0 : 60;
}

//补贴
- (IBAction)toButiePay:(id)sender {
    
    [self.contentVC toButiePay:nil];
    
}

//续费
- (IBAction)toContinuePay:(id)sender {

    [self.contentVC toContinuePay:nil];

}


@end
