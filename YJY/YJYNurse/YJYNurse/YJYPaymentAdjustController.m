//
//  YJYPaymentAdjustController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/18.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYPaymentAdjustController.h"

#import "YJYAdjustServicesCell.h"
#import "YJYAdjustExpandContractCell.h"
#import "YJYAdjustAddServiceCell.h"

#import "YJYAdjustRebateView.h"
#import "YJYInsurePaymentListView.h"
#import "YJYOrderNightCareController.h"
#import "YJYOrderDetailController.h"

typedef void(^YJYPaymentAdjustContentControllerDidCalculatePriceBlock)(int64_t price);
typedef void(^YJYPaymentAdjustContentControllerDidLoadBlock)();

//列表
typedef NS_ENUM(NSInteger, YJYPaymentAdjustType) {
    
    YJYPaymentAdjustTypeBasic,
    
    YJYPaymentAdjustTypeAdjustTotal,

    YJYPaymentAdjustTypeAdjustAdd,
    YJYPaymentAdjustTypeWorkerExpand,
    YJYPaymentAdjustTypeNormalAddExpand,
    YJYPaymentAdjustTypePeopleBedExpand,
    
    //结束
    YJYPaymentAdjustTypeYouhuiTitle,
    YJYPaymentAdjustTypeYouhui,
    YJYPaymentAdjustTypeCareBedTitle,
    YJYPaymentAdjustTypeCareBed,

};

@interface YJYPaymentAdjustContentController : YJYTableViewController


//data
@property (copy, nonatomic) NSString *orderId;
@property (nonatomic, strong) NSMutableArray<NSString*> *monthsArray;
@property (assign, nonatomic) BOOL isAdjustPage;
@property (assign, nonatomic) YJYOrderPaymentAdjustType jumpType;
//@property(nonatomic, readwrite) uint64_t branchId;
//@property(nonatomic, readwrite) uint64_t priceId;
//@property(nonatomic, readwrite) uint64_t userId;

@property (strong, nonatomic) GetOrderItemRsp *rsp;
@property (strong, nonatomic) GetOrderAdjustStatusRsp *getOrderAdjustStatusRsp;
@property (copy, nonatomic) YJYPaymentAdjustContentControllerDidCalculatePriceBlock didCalculatePriceBlock;
@property (copy, nonatomic) YJYPaymentAdjustContentControllerDidLoadBlock didLoadBlock;
@property (copy, nonatomic) YJYPaymentAdjustDidDismissBlock didDismissBlock;
@property (copy, nonatomic) YJYPaymentAdjustDidDismissBlock didToListBlock;

@property (strong, nonatomic) NSMutableArray *extraListArray;
//UI

@property (weak, nonatomic) IBOutlet YJYAdjustServicesCell *serviceListCell;
@property (weak, nonatomic) IBOutlet UILabel *adjustTotalPriceLabel;

//调整list
@property (weak, nonatomic) IBOutlet YJYAdjustAddServiceCell *adjustAddServiceCell;


@property (weak, nonatomic) IBOutlet YJYAdjustExpandContractCell *workerExpandContractCell;
@property (weak, nonatomic) IBOutlet YJYAdjustExpandContractCell *normalAddExpandContractCell;
@property (weak, nonatomic) IBOutlet YJYAdjustExpandContractCell *peopleBedExpandContractCell;

//bed
@property (weak, nonatomic) IBOutlet UILabel *bedPriceLabel;


//优惠 陪人床
@property (weak, nonatomic) IBOutlet UILabel *youhuiPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *prcPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *prcNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *prcButton;

@property (strong, nonatomic) UIImageView *arrowImageView;

@property (strong, nonatomic) YJYInsurePaymentListView *paymentListView;
@property (assign, nonatomic) YJYWorkerServiceType workerServiceType;

@end

@implementation YJYPaymentAdjustContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    self.extraListArray = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
        [weakSelf loadTranBranch];

    }];
    
    [self loadNetworkData];
    [self loadTranBranch];

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self loadNetworkData];
    [self loadTranBranch];

}

- (void)loadNetworkData {
    [SYProgressHUD show];

    
    CheckOrderPaiedReq*req = [CheckOrderPaiedReq new];
    req.orderId = self.orderId;
    req.monthsArray = self.monthsArray;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderItemDetail message:req controller:self command:APP_COMMAND_SaasappgetOrderItemDetail success:^(id response) {
        
        self.rsp = [GetOrderItemRsp parseFromData:response error:nil];
        [self setupRsp];
        [self reloadAllData];
        [SYProgressHUD hide];

        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}
- (void)loadTranBranch{
    
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    req.orderId = self.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderAdjustStatus message:req controller:self command:APP_COMMAND_SaasappgetOrderAdjustStatus success:^(id response) {
        
        self.getOrderAdjustStatusRsp = [GetOrderAdjustStatusRsp parseFromData:response error:nil];
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
    }];
}



- (void)setupRsp {
    
    
    __weak typeof(self) weakSelf = self;
    
    self.bedPriceLabel.text =  [NSString stringWithFormat:@"%@元",self.rsp.totalCostPrcstr];

    //基础
    
    self.serviceListCell.serviceListArray = [NSMutableArray array];
    self.serviceListCell.serviceListArray = self.rsp.serviceListArray;
    
    // 调整附加服务
    
    self.extraListArray = [NSMutableArray array];
    self.extraListArray = self.rsp.extraListArray;
    
    self.adjustAddServiceCell.extraListArray = [NSMutableArray array];
    self.adjustAddServiceCell.extraListArray = self.rsp.extraListArray;
    self.adjustAddServiceCell.didReloadBlock = ^{
        
        [weakSelf.tableView reloadData];
    };

    
    //护工费调整
    
    self.adjustTotalPriceLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.totalFeeStr];
    
    self.workerExpandContractCell.priceList = self.rsp.priceVoadjustListArray;
    self.peopleBedExpandContractCell.adjustExpandType = YJYAdjustExpandTypeVoadjust;
    self.workerExpandContractCell.didExpandBlock = ^{
        
        [weakSelf.tableView reloadData];
    };
    self.workerExpandContractCell.didSelectPriceBlock = ^(CompanyPriceVO *price) {
        
        [weakSelf reloadAdjustAddServiceCellWithPrice:price];
    };
    //普通附加服务
    
    self.normalAddExpandContractCell.priceList = self.rsp.priceVoordinaryListArray;
    self.peopleBedExpandContractCell.adjustExpandType = YJYAdjustExpandTypeVoordinary;
    self.normalAddExpandContractCell.didExpandBlock = ^{
        
        [weakSelf.tableView reloadData];
    };
    
    self.normalAddExpandContractCell.didSelectPriceBlock = ^(CompanyPriceVO *price) {
        
        [weakSelf reloadAdjustAddServiceCellWithPrice:price];
    };
    
    //陪人床
    /// 是否可以调整陪人床费用

    self.peopleBedExpandContractCell.priceList = self.rsp.priceVoprcListArray;
    self.peopleBedExpandContractCell.adjustExpandType = YJYAdjustExpandTypeVoprc;
    self.peopleBedExpandContractCell.didExpandBlock = ^{
        
        [weakSelf.tableView reloadData];
    };
    self.peopleBedExpandContractCell.didSelectPriceBlock = ^(CompanyPriceVO *price) {
        
        [weakSelf reloadAdjustBedWithPrice:price];
    };
    [self reloadAdjustBedWithPrice:nil];
    
    self.youhuiPriceLabel.text = [NSString stringWithFormat:@"%@元", self.rsp.hgRebateFeeStr];
    self.youhuiLabel.text = [NSString stringWithFormat:@"%@", self.rsp.hgRebateTypeStr];

    self.prcPriceLabel.text = [NSString stringWithFormat:@"%@元", self.rsp.totalCostPrcstr];
    self.prcNumberLabel.text = [NSString stringWithFormat:@"%@个",@(self.rsp.numberPrc)];
    
    // 刷新
    
    [self.tableView reloadData];

}

#pragma mark - 价格调整

- (void)reloadAdjustAddServiceCellWithPrice:(CompanyPriceVO *)price {
    
    
     
    BOOL isUpdate = NO;
    for (NSInteger i = 0; i < self.extraListArray.count; i++) {
        
        OrderItemVO2 *orderItemVO2 = self.extraListArray[i];
        if (orderItemVO2.priceId == price.price.priceId ||
            orderItemVO2.service == price.price.serviceItem) {
            
            orderItemVO2.serviceDays = price.number;
            orderItemVO2.paidPayNum = price.payNumber;
            
            if (orderItemVO2.serviceDays == 0) {
                
                [self.extraListArray removeObjectAtIndex:i];

                
            }else {
                
                self.extraListArray[i] = orderItemVO2;

            }

            isUpdate = YES;
            break;
        }
    }
    
    //是否更新
    
    if (!isUpdate) {
        
        OrderItemVO2 *orderItemVO2 = [OrderItemVO2 new];
        orderItemVO2.service = price.price.serviceItem;
        orderItemVO2.price = price.price.price;
        orderItemVO2.serviceDays = price.number;
        orderItemVO2.paidPayNum = price.payNumber;

        
        [self.extraListArray addObject:orderItemVO2];
    }
    
    [self calculatePrice];
    [self.tableView reloadData];
    
}
- (void)reloadAdjustBedWithPrice:(CompanyPriceVO *)price {

    for (NSInteger i = 0; i < self.peopleBedExpandContractCell.priceList.count; i++) {
        CompanyPriceVO *a_price = self.peopleBedExpandContractCell.priceList[i];
        if (a_price.price.priceId == price.price.priceId) {
            
            self.peopleBedExpandContractCell.priceList[i] = price;
            break;
        }
    }
    
    //计算
    
    NSInteger days = 0;
    int64_t prices = 0.0;
    for (CompanyPriceVO *price in self.peopleBedExpandContractCell.priceList) {
        days+=price.number;
        prices += price.number * price.price.price;
    }
    
//    self.bedNumberLabel.text = [NSString stringWithFormat:@"%@个",@(days)];
    self.bedPriceLabel.text = [NSString stringWithFormat:@"%.2f元",prices*0.01];
    
    
    [self calculatePrice];
    
    
}
#pragma mark - 计算

- (void)calculatePrice {
    
    
    //调整
    int64_t mixPrice = 0.0;
    for (OrderItemVO2 *orderItemVO2 in self.extraListArray) {
        
        mixPrice += orderItemVO2.serviceDays * orderItemVO2.price;

    }
    //基本
    int64_t basicPrice = 0.0;
    for (OrderItemVO3 *orderItemVO3 in self.rsp.serviceListArray) {
        
        basicPrice += orderItemVO3.totalCost;
    }
    
    int64_t workerPrice = basicPrice + mixPrice;
    
    //陪人床费
    int64_t prcPrice = 0;
    for (CompanyPriceVO *price in self.peopleBedExpandContractCell.priceList) {
        prcPrice += (price.number * price.price.price);
    }
    
    if (self.didCalculatePriceBlock) {
        self.didCalculatePriceBlock(workerPrice + prcPrice);
    }
    
    YJYPaymentAdjustController *parentVC = (YJYPaymentAdjustController *)[self parentViewController];
    parentVC.workerPriceLabel.text = [NSString stringWithFormat:@"%.2f元",workerPrice*0.01];
    
    //调整总费用
    self.adjustTotalPriceLabel.text = [NSString stringWithFormat:@"%@.00元",@(mixPrice*0.01)];
    
}


#pragma mark - Action
- (void)toShowTotal:(id)sender {
    
    if (self.tableView.scrollEnabled == NO) {
        [self.paymentListView hidden];
        return;
    }
    
    YJYInsurePaymentListView *view = [YJYInsurePaymentListView instancetypeWithXIB];
    self.paymentListView = view;
    view.bounds = self.view.frame;
    
    NSMutableArray *dictM = [NSMutableArray array];
    
    //一对多
    
    for (OrderItemVO3 *orderItemVO3 in self.serviceListCell.serviceListArray) {
        
        NSString *price = [NSString stringWithFormat:@"%@元",orderItemVO3.totalCostStr];

        NSDictionary *dict = @{@"title":orderItemVO3.service,@"number":@"",@"price":price};
        if (orderItemVO3.totalCost != 0) {
            [dictM addObject:dict];

        }

    }
    
    //调整项目
    
    for (OrderItemVO2 *orderItemVO2 in self.extraListArray) {
        
        NSString *number = [NSString stringWithFormat:@"%@次",@(orderItemVO2.serviceDays)];
        NSString *price = [NSString stringWithFormat:@"%@元",@(orderItemVO2.price * orderItemVO2.serviceDays / 100)];

        NSDictionary *dict = @{@"title":orderItemVO2.service,@"number":number,@"price":price};
        if (orderItemVO2.price * orderItemVO2.serviceDays != 0) {
            [dictM addObject:dict];
            
        }

    }
    
    //陪人床
    
    for (CompanyPriceVO * companyPriceVO in self.peopleBedExpandContractCell.priceList) {
        
        NSString *number = [NSString stringWithFormat:@"%@个",@(companyPriceVO.number)];
        NSString *price = [NSString stringWithFormat:@"%@元",@(companyPriceVO.price.price * companyPriceVO.number / 100)];

        NSDictionary *dict = @{@"title":companyPriceVO.price.serviceItem,@"number":number,@"price":price};
        if (companyPriceVO.price.price * companyPriceVO.number != 0) {
            [dictM addObject:dict];
            
        }
        
    }
    view.datasource = [NSMutableArray arrayWithArray:dictM];
    
    

    view.didHidden = ^{
        
        self.tableView.scrollEnabled = YES;
        self.arrowImageView.image = [UIImage imageNamed:@"order_down_icon"];
    };
    [view showInView:self.view];
    
    self.arrowImageView.image = [UIImage imageNamed:@"order_up_icon"];
    
    self.tableView.scrollEnabled = NO;
}
- (void)toAdjust {
    
    
    YJYPaymentAdjustController *vc = [YJYPaymentAdjustController instanceWithStoryBoard];
    vc.jumpType = self.jumpType;
    vc.workerServiceType = self.workerServiceType;
    vc.didDismissBlock = ^{
        if (self.didDismissBlock) {
            self.didDismissBlock();
            
        }
    };
    vc.monthsArray = self.monthsArray;
    vc.orderId = self.orderId;
    vc.isAdjustPage = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)toAdjustComfire {
    
    if (self.jumpType == YJYOrderPaymentAdjustTypeAdjustSection) {
        
        [self toVerifyAndShowCoupon];

    }else if (self.jumpType == YJYOrderPaymentAdjustTypeServingModify){
        
        
        [self toAdjustFinish];
    }else if (self.jumpType == YJYOrderPaymentAdjustTypeServingPayoffEnding) {
        
        [self toVerifyAndShowCoupon];
    }else if (self.jumpType == YJYOrderPaymentAdjustTypePayoffPaymentCheck) {
        
        [self toVerifyAndShowCoupon];
    }else {
        [self toAdjustFinish];

    }
}

- (void)toVerifyAndShowCoupon{
    
    
    // && self.rsp.order.status == YJYOrderStateWaitPayOff
    [self toGetOrderAdjustStatusSuccess:^(id response) {
        
        
        GetOrderAdjustStatusRsp *rsp = [GetOrderAdjustStatusRsp parseFromData:response error:nil];
        if (rsp.settleItemStatus == 1) {
            //确认
            [UIAlertController showAlertInViewController:self withTitle:@"调整失败，费用已确认，校正请在电脑上操作" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                
            }];
            
        }else {
            
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
                [self toAdjustFinish];

                return;
            }
          
            
            YJYAdjustRebateView *rebateView = [YJYAdjustRebateView instancetypeWithXIB];
            rebateView.orderId = self.orderId;
            rebateView.frame = self.view.bounds;
            [rebateView showInView:nil];
            rebateView.didComfireBlock = ^{
                
                [self toGetOrderAdjustStatusSuccess:^(id response) {
                    
                    GetOrderAdjustStatusRsp *rsp = [GetOrderAdjustStatusRsp parseFromData:response error:nil];
                    if (rsp.settleItemStatus == 1) {
                        //确认
                        [UIAlertController showAlertInViewController:self withTitle:@"调整失败，费用已确认，校正请在电脑上操作" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                            
                            
                        }];
                        
                    }else {
                        
                        [self toAdjustFinish];
                        
                    }
                }failure:^(NSError *error) {
                    
                }];
                
                
            };
            
        }

        
    }failure:^(NSError *error) {
        
    }];
    
   
}
- (void)toOrderDetail {
    
    
    if (self.jumpType == YJYOrderPaymentAdjustTypePayoffPaymentCheck ||
        self.jumpType == YJYOrderPaymentAdjustTypeServingPayoffEnding) {
        if (self.didDismissBlock) {
            self.didDismissBlock();
        }
        return;
    }
    YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
    vc.orderId = self.rsp.order.orderId;
    vc.isToRoot = YES;
    vc.didDismiss = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.didToListBlock) {
            self.didToListBlock();
        }
    
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}
//请确认此订单的最终费用？
- (void)toConfirmOrderAdjustStatusSuccess:(Success)success
                                  failure:(Failure)failure{
    
    NSString *comfireTitle = @"";
    if (self.rsp.hgRebateFeeStr.length > 0 && [self.rsp.hgRebateFeeStr integerValue] > 0) {
        comfireTitle = [NSString stringWithFormat:@"请确认%@元（优惠减免%@元，应收%@元）是否此订单的最终费用",self.rsp.totalAllfeeStr,self.rsp.hgRebateFeeStr,self.rsp.totalFeeStr];
        
        if (self.jumpType == YJYOrderPaymentAdjustTypeAdjustSection) {
            
            comfireTitle = [NSString stringWithFormat:@"请确认%@元（优惠减免%@元，应收%@元）是否此订单的最终费用",self.getOrderAdjustStatusRsp.totalFeeStr,self.getOrderAdjustStatusRsp.hgRebateFeeStr,self.getOrderAdjustStatusRsp.feeStr];
        }
    }else {
        comfireTitle = [NSString stringWithFormat:@"请确认%@元是不是此订单的最终费用？",self.rsp.totalFeeStr];
        
    }
    
    [UIAlertController showAlertInViewController:self withTitle:comfireTitle message:nil alertControllerStyle:1 cancelButtonTitle:@"不是" destructiveButtonTitle:@"是的" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            GetOrderInfoReq *req = [GetOrderInfoReq new];
            req.orderId = self.rsp.order.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderAdjustStatus message:req controller:self command:APP_COMMAND_SaasappconfirmOrderAdjustStatus success:^(id response) {
                
                if (self.isAdjustPage == NO) {
                    success(response);
                    return;
                }
                [self toGetOrderAdjustStatusSuccess:^(id response) {
                    
                    success(response);
                    
                    
                }failure:^(NSError *error) {
                    failure(error);
                    
                }];
                
            } failure:^(NSError *error) {
                failure(error);
            }];
        }else {
            
            [self toOrderDetail];
            
            
        }
        
    }];
    
   
    
}

//获取调整账单
- (void)toGetOrderAdjustStatusSuccess:(Success)success
                              failure:(Failure)failure{
    
    
    GetOrderInfoReq *req = [GetOrderInfoReq new];
    req.orderId = self.rsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderAdjustStatus message:req controller:self command:APP_COMMAND_SaasappgetOrderAdjustStatus success:^(id response) {
        
        success(response);

       
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 调整页确认

- (void)toAdjustFinish {
    
    
    [SYProgressHUD show];
    AddOrderPriceReviseReq *req = [AddOrderPriceReviseReq new];
    req.orderId = self.orderId;
    
    GPBUInt64Int32Dictionary *mapPrice = [GPBUInt64Int32Dictionary dictionary];
    
    NSMutableArray *allPriceList = [NSMutableArray array];
    [allPriceList addObjectsFromArray:self.workerExpandContractCell.priceList];
    [allPriceList addObjectsFromArray:self.normalAddExpandContractCell.priceList];
    [allPriceList addObjectsFromArray:self.peopleBedExpandContractCell.priceList];
    
    for (CompanyPriceVO *price in allPriceList) {
        [mapPrice addEntriesFromDictionary:[GPBUInt64Int32Dictionary dictionaryWithInt32:price.number forKey:price.price.priceId]];
    }
    req.mapPrice = mapPrice;
    req.istoday = 1;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCreateOrUpdateOrderItemPrice message:req controller:self command:APP_COMMAND_SaasappcreateOrUpdateOrderItemPrice success:^(id response) {
        
        [SYProgressHUD hide];
       
        CreateOrUpdateOrderItemPriceRsp *rsp = [CreateOrUpdateOrderItemPriceRsp parseFromData:response error:nil];
        
        if (!rsp.isUpdateNight) {
            
            [self dismissAction];

        }else {
         
            [UIAlertController showAlertInViewController:self withTitle:@"您添加了夜陪服务，是否立即去指派夜陪服务人员" message:nil alertControllerStyle:1 cancelButtonTitle:@"不指派" destructiveButtonTitle:@"指派" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    YJYOrderNightCareController *vc = [YJYOrderNightCareController instanceWithStoryBoard];
                    vc.orderId = self.orderId;
                    vc.didBackBlock = ^{
                        if (self.didDismissBlock) {
                            self.didDismissBlock();
                        }
                    };
                    vc.jumpType = [(YJYPaymentAdjustController *)self.parentViewController jumpType];
//                    vc.workerServiceType = self.workerServiceType;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else {
                   
                    [self.navigationController popViewControllerAnimated:YES];

                    

                }
                
            }];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 请求完毕
- (void)dismissAction{

    
    
    if (self.jumpType == YJYOrderPaymentAdjustTypePayoffPaymentCheck ||
        self.jumpType == YJYOrderPaymentAdjustTypeAdjustSection ||
        self.jumpType == YJYOrderPaymentAdjustTypeServingPayoffEnding) {
        
        if (self.isAdjustPage == NO) {
            [self toOrderDetail];

        }else {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else if(self.jumpType == YJYOrderPaymentAdjustTypeServingPayoffEnding){
        
        
        [self toOrderDetail];
        
    }else {
        
        if ([self isPushController]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            if (self.didDismissBlock) {
                self.didDismissBlock();
            }
        }
    }
    
}
- (void)toOrderDetailWithResponse:(id)response {
    
    
    GetOrderAdjustStatusRsp *rsp = [GetOrderAdjustStatusRsp parseFromData:response error:nil];
    if (rsp.status == 5 || rsp.status == 6) {
        [SYProgressHUD showInfoText:@"确认失败"];
    }else if (rsp.settleItemStatus == 1) {
        [SYProgressHUD showInfoText:@"确认失败"];
        
    }
    [self toOrderDetail];
    
   
    
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    
    if (indexPath.row == YJYPaymentAdjustTypeBasic) {
        
        return [self.serviceListCell cellHeight];
        
    }else if (indexPath.row == YJYPaymentAdjustTypeAdjustAdd) {
        
        if (self.isAdjustPage == YES) {
    
            return 0;
        }
        
        return [self.adjustAddServiceCell cellHeight];
        
    }else if (indexPath.row == YJYPaymentAdjustTypeAdjustTotal) {
        
        if (self.isAdjustPage == YES) {
            
            return H;
        }
        
        return 0;
        
    }else if (indexPath.row >= YJYPaymentAdjustTypeWorkerExpand &&
        indexPath.row <= YJYPaymentAdjustTypePeopleBedExpand) {
        //self.rsp.isUpdatePrcfee
        if (self.isAdjustPage == NO) {

            return 0;
        }else {
            
            if (indexPath.row == YJYPaymentAdjustTypeWorkerExpand) {
                
                return [self.workerExpandContractCell cellHeight];
                
            }else if (indexPath.row == YJYPaymentAdjustTypeNormalAddExpand) {
                
                return [self.normalAddExpandContractCell cellHeight];
                
            }else if (indexPath.row == YJYPaymentAdjustTypePeopleBedExpand) {
//                if (!self.rsp.isUpdatePrcfee) {
//                    return 40;
//
//                }
                return [self.peopleBedExpandContractCell cellHeight];

                
            }
            
        }
        
    }else if (indexPath.row >= YJYPaymentAdjustTypeYouhuiTitle &&
        indexPath.row <= YJYPaymentAdjustTypeCareBed) {
        
        if (self.isAdjustPage) {
            return 0;
        }else {
            
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];

        }
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

@end


@interface YJYPaymentAdjustController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *adjustTotalLabel;

@property (weak, nonatomic) IBOutlet UIButton *comfireButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@property (weak, nonatomic) IBOutlet UIView *mingxiView;
@property (weak, nonatomic) IBOutlet UIView *adjustView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mingxiBottomConstraint;

@property (strong, nonatomic) YJYPaymentAdjustContentController *contentVC;
@end

@implementation YJYPaymentAdjustController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYPaymentAdjustController *)[UIStoryboard storyboardWithName:@"YJYPayment" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYPaymentAdjustContentController"]) {
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYPaymentAdjustContentController *)segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.monthsArray = self.monthsArray;
        self.contentVC.workerServiceType = self.workerServiceType;

        self.contentVC.jumpType = self.jumpType;
        self.contentVC.isAdjustPage = self.isAdjustPage;
        self.contentVC.arrowImageView = self.arrowImageView;

        self.contentVC.didCalculatePriceBlock = ^(int64_t price) {
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"合计:%.2f元",price*0.01];
            weakSelf.adjustTotalLabel.text = weakSelf.totalLabel.text;
        };
        
        self.contentVC.didLoadBlock = ^{
            
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"合计:%@元",weakSelf.contentVC.rsp.totalFeeStr];
            weakSelf.adjustTotalLabel.text = weakSelf.totalLabel.text;
            weakSelf.workerPriceLabel.text = [NSString stringWithFormat:@"%@元",weakSelf.contentVC.rsp.serviceTotalFeeStr];

            
        };
        self.contentVC.didDismissBlock = ^{
            if (weakSelf.didDismissBlock) {
                weakSelf.didDismissBlock();
            }
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        self.contentVC.didToListBlock = ^{
            if (weakSelf.didToListBlock) {
                weakSelf.didToListBlock();
            }
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    self.title = (self.isAdjustPage == NO) ? @"账单明细" : @"账单调整";
    
    UIBarButtonItem *titleBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = titleBar;
    
    if (self.isAdjustPage) {
        
        self.arrowImageView.hidden = NO;
    }else {
        
        self.arrowImageView.hidden = YES;
    }
    
    [self setupAdjust];
    
   

}

- (void)setupAdjust {
    
    if (self.isAdjustPage == NO) {
        
        self.mingxiView.hidden = NO;
        self.adjustView.hidden = YES;
        
        self.mingxiBottomConstraint.constant = 0;
        self.containViewBottomConstraint.constant = 100;
        
    }else {
        
        self.mingxiView.hidden = YES;
        self.adjustView.hidden = NO;
        
        self.mingxiBottomConstraint.constant = 61;
        self.containViewBottomConstraint.constant = 60;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.didDoneBlock) {
        self.didDoneBlock();
        
    }
}
- (IBAction)totalAction:(id)sender {
    if (self.isAdjustPage) {
        [self.contentVC toShowTotal:nil];

    }

}
- (IBAction)done:(id)sender {
    
    
    if (self.jumpType == YJYOrderPaymentAdjustTypeAdjustSection) {
        
        [self toComfireFee];
    }else if (self.jumpType == YJYOrderPaymentAdjustTypePayoffPaymentCheck) {
        
        [self toComfireFee];
    }else if (self.jumpType == YJYOrderPaymentAdjustTypeServingPayoffEnding) {
        [self toComfireFee];

    }

}

- (IBAction)toAdjust:(id)sender {

    [self.contentVC toAdjust];
}

- (IBAction)toAdjustComfire:(id)sender {
    
    [self.contentVC toAdjustComfire];
}

- (void)toComfireFee {
    
    [self.contentVC toConfirmOrderAdjustStatusSuccess:^(id response) {
        [self.contentVC toOrderDetailWithResponse:response];
    }failure:^(NSError *error) {
        
        [self.contentVC toOrderDetail];
        
    }];
    
}
- (void)back {
    
    
    
    //请核对账单费用
    if (self.isAdjustPage == NO) {
        if (self.jumpType == YJYOrderPaymentAdjustTypePayoffPaymentCheck ||
            self.jumpType == YJYOrderPaymentAdjustTypeAdjustSection ) {
            [self toComfireFee];
            return;
            
        }
    }
    
    //来自调整页
    if (![self.navigationController.viewControllers.firstObject isEqual:self] && self.isAdjustPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
