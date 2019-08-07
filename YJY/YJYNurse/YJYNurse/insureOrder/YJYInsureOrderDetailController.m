//
//  YJYInsureOrderDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderDetailController.h"
#import "YJYInsureNurseDetailController.h"
#import "YJYInsureEstimateFeeController.h"
#import "YJYInsureDailyComfireController.h"

#import "YJYInsureReviewApplyController.h"

#import "YJYInsureBackVisitListController.h"
#import "YJYInsureCarePlanController.h"
#import "YJYInsureDailyListController.h"

#import "YJYInsureReApplyDetailController.h"
#import "YJYInsureOrderRelationController.h"
#import "YJYInsureOrderUpdateController.h"
#import "YJYInsureOrderNurseListController.h"
#import "YJYInsureCarePlanController.h"
#import "YJYInsureChooseServiceController.h"
#import "YJYInsureReviewListController.h"
#import "YJYInsureDailyListController.h"
#import "YJYInsureOrderFamilyController.h"
#import "YJYInsureAddReviewController.h"


#import "YJYInsureGuideTeachListController.h"
#import "YJYInsureCarePlanDetailController.h"
#import "YJYInsureDailyDetailController.h"
#import "YJYInsureGuideTeachListController.h"
#import "YJYInsureGuideTeachDetailController.h"
typedef void(^InsureOrderDetailDidLoadBlock)();
typedef NS_ENUM(NSInteger,YJYInsureOrderDetailType) {
    
    
    YJYInsureOrderDetailTypeTitle,
    
    YJYInsureOrderDetailTypeOrderTime,
    YJYInsureOrderDetailTypeServeTime,
    YJYInsureOrderDetailTypeZZTryUseTime,
    
    YJYInsureOrderDetailTypeBeServer,
    YJYInsureOrderDetailTypeContact,
    YJYInsureOrderDetailTypeContactAddress,
    YJYInsureOrderDetailTypeOneBlank,
    
    YJYInsureOrderDetailTypeBeDaijiao,
    YJYInsureOrderDetailTypeDaijiaoBlankOne,
    YJYInsureOrderDetailTypeDaijiao,
    
    YJYInsureOrderDetailTypePeihuFamily,
    YJYInsureOrderDetailTypeNurse,
    YJYInsureOrderDetailTypeCustomManger,

    YJYInsureOrderDetailTypeServeTitle,
    YJYInsureOrderDetailTypeServeRecord,
    YJYInsureOrderDetailTypeServePlan,
    YJYInsureOrderDetailTypeBackVisitRecord,
    
};

@interface YJYInsureOrderDetailContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UIButton* stateButton;

@property (weak, nonatomic) IBOutlet UILabel* orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel* serverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel* zizhaoTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel * beServerLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel* addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *adlLabel;

@property (weak, nonatomic) IBOutlet MDHTMLLabel *familyRelationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nurseLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthManagerLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dajiaoObjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *guideObjectLabel;


@property (strong, nonatomic) GetInsureOrderDetailRsp *rsp;
@property(nonatomic, readwrite) NSString *orderId;
@property (strong, nonatomic) OrderVO *orderVO;

@property (copy, nonatomic) InsureOrderDetailDidLoadBlock didLoadBlock;


@property (weak, nonatomic) IBOutlet UIButton *toNurseButton;
@property (weak, nonatomic) IBOutlet UIButton *toGuideButton;

@end

@implementation YJYInsureOrderDetailContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkData];

}
- (void)loadNetworkData {
    
    
    [SYProgressHUD show];
    
    GetInsureOrderDetailReq  *req = [GetInsureOrderDetailReq new];
    req.orderId = self.orderVO.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderDetail message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderDetail success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp = [GetInsureOrderDetailRsp parseFromData:response error:nil];
        [self reloadAllData];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadRsp {
    
    [self.stateButton setTitle:self.rsp.conditionStr forState:0];
    
//订单状态(-1-已取消0-待接单, 1-待支付,2-待派工,3-待服务, （三块不展示）    4-服务中, 5-待结算 6-待评价（陪护特有）7-已完成)
    UIColor *stateColor;
    uint32_t status = self.rsp.order.status;
    
    
    if (status == 0 ||
        status == 1 ||
        status == 2 ||
        status == 3 ||
        status == 7) {
        
        stateColor = APPREDCOLOR;
        
    }else if (status == 4){
        
        stateColor = APPHEXCOLOR;
        
    }else if (status == 5 ||
              status == 6){
        
        stateColor = APPORANGECOLOR;
       
        
    }else if (status == -1){
        
        stateColor = APPNurseGrayRGBCOLOR;
        
        
    }
    self.stateButton.backgroundColor = stateColor;
    
    
    self.orderIdLabel.text = self.rsp.order.serviceItem;
    
    self.orderTimeLabel.text = self.rsp.createTimeStr;
    self.serverTimeLabel.text = [NSString stringWithFormat:@"%@至%@",self.rsp.orderStartDate,self.rsp.orderEndDate] ;
    self.zizhaoTimeLabel.text = [NSString stringWithFormat:@"%@至%@",self.rsp.tryStartDate,self.rsp.tryEndDate];
    self.beServerLabel.text = self.rsp.order.fullName;
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:self.rsp.order.contacts phone:self.rsp.order.contactPhone];
    self.addressLabel.text = self.rsp.addrDetail;
    self.adlLabel.text = [NSString stringWithFormat:@"(ADL%@分)",@(self.rsp.adlScore)];
    //
    
    self.toGuideButton.hidden = NO;
    if (self.rsp.order.hgId > 0) {
        self.guideObjectLabel.text = self.rsp.order.hgName;
    }else if (self.rsp.order.insureHsId > 0) {
        self.guideObjectLabel.text = self.rsp.order.insureHsName;
    }else {
        
        self.guideObjectLabel.text = @"待指派";
        self.toGuideButton.hidden = YES;

    }
    
    
    self.dajiaoObjectLabel.text = self.rsp.order.relationName;
    
    NSString * relationStr = [NSString yjy_ContactStringWithContact:[NSString stringWithFormat:@"%@  %@  ",self.rsp.order.relationName,self.rsp.order.relation] phone:self.rsp.order.relationPhone];
    self.familyRelationLabel.htmlText = self.rsp.order.relationName.length > 0 ? relationStr : @"无";

    self.nurseLabel.text = self.rsp.order.insureHsName.length > 0 ? self.rsp.order.insureHsName : @"无";
    self.toNurseButton.hidden = self.rsp.order.insureHsName.length == 0;
    self.healthManagerLabel.text = self.rsp.order.managerName;
    
    //
    self.recordNumLabel.text = [NSString stringWithFormat:@"已经服务%@天",@(self.rsp.serviceDateNum)];
    
    if (self.didLoadBlock) {
        self.didLoadBlock();
    }

}

#pragma mark - Action

- (IBAction)toReviewDetail:(id)sender {
    
    YJYInsureReviewListController *vc = [YJYInsureReviewListController instanceWithStoryBoard];
    vc.orderDetailRsp = self.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toBeServerDetail:(id)sender {
    
    YJYInsureReApplyDetailController*vc = [YJYInsureReApplyDetailController instanceWithStoryBoard];
    vc.orderDetailRsp = self.rsp;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)toGuideTeachPersonDetail:(id)sender {
    
    YJYInsureNurseDetailController *vc = [YJYInsureNurseDetailController instanceWithStoryBoard];
    vc.orderId = self.rsp.order.orderId;
    
    if (self.rsp.order.hgId > 0) {
        vc.hgId = self.rsp.order.hgId;
        vc.hgType = 1;
    }else if (self.rsp.order.insureHsId > 0) {
        vc.hgId = self.rsp.order.insureHsId;
        vc.hgType = 2;
    }
    
    if (vc.hgId == 0) {
        [SYProgressHUD showFailureText:@"没有相应带教人员"];
        return;
    }
    
    
    
//    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
//        vc.hgId = self.rsp.order.hgId;
//        vc.hgType = 1;
//    }else {
//
//        vc.hgId = self.rsp.order.insureHsId;
//        vc.hgType = 2;
//    }
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)toFamilyPersonDetail:(id)sender {
    
    if (self.rsp.order.relationName.length == 0) {
        return;
    }else {
        
        YJYInsureOrderFamilyController *vc = [YJYInsureOrderFamilyController instanceWithStoryBoard];
        vc.orderDetailRsp  = self.rsp;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (IBAction)toServeRecordDetail:(id)sender {
    
    if (self.rsp.order.serviceType == 182) {
        YJYInsureDailyListController *vc = [YJYInsureDailyListController instanceWithStoryBoard];
        vc.orderDetailRsp  = self.rsp;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        YJYInsureGuideTeachListController *vc = [YJYInsureGuideTeachListController instanceWithStoryBoard];
        vc.orderDetailRsp  = self.rsp;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
    
}
- (IBAction)toCarePlanDetail:(id)sender {
 
    YJYInsureCarePlanDetailController *vc = [YJYInsureCarePlanDetailController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.rsp;
    vc.isEnter = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toVisitRecordDetail:(id)sender {
    
    YJYInsureBackVisitListController *vc = [YJYInsureBackVisitListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.rsp;
    vc.status = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)toNurseDetail:(id)sender {
    
    YJYInsureNurseDetailController *vc = [YJYInsureNurseDetailController instanceWithStoryBoard];
    vc.orderId = self.rsp.order.orderId;
    vc.hgId = self.rsp.order.insureHsId;
    vc.hgType = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.row >= YJYInsureOrderDetailTypeServeTime &&
        indexPath.row <= YJYInsureOrderDetailTypeZZTryUseTime) {
        
        if (indexPath.row == YJYInsureOrderDetailTypeZZTryUseTime) {
            if (self.rsp.order.serviceType != 182) {
                H = 0;
            }
        }
        
        if (self.rsp.order.status >= YJYOrderInsureTypeCancel &&
            self.rsp.order.status <= YJYOrderInsureTypeWaitServe) {
            H = 0;
        }
        
    }else if (indexPath.row == YJYInsureOrderDetailTypeNurse) {
        if (self.rsp.order.status == YJYOrderInsureTypeReceive || self.rsp.order.serviceType != 182){ //自照
            H = 0;
        }
        
    }else if (indexPath.row >= YJYInsureOrderDetailTypeServeTitle &&
              indexPath.row <= YJYInsureOrderDetailTypeServeRecord) {
        
        
        
        if (self.rsp.order.status >= YJYOrderInsureTypeReceive &&
            self.rsp.order.status <= YJYOrderInsureTypeWaitServe) {
            H = 0;
        }
        if (self.rsp.order.status == OrderStatus_Cancel) {
            H = 0;
        }
        
    }else if (indexPath.row >= YJYInsureOrderDetailTypeServePlan &&
              indexPath.row <= YJYInsureOrderDetailTypeBackVisitRecord) {
        
        if (self.rsp.order.status >= YJYOrderInsureTypeReceive &&
            self.rsp.order.status <= YJYOrderInsureTypeWaitServe) {
            H = 0;
        }
        if (self.rsp.order.status == OrderStatus_Cancel) {
            H = 0;
        }
        if (self.rsp.order.serviceType == 181) {
            H = 0;
        }
        
    }else if (indexPath.row == YJYInsureOrderDetailTypePeihuFamily) {
        
        CGFloat width = self.tableView.frame.size.width - (17 + 17);
        CGFloat height = [MDHTMLLabel sizeThatFitsHTMLString:self.familyRelationLabel.text withFont:[UIFont systemFontOfSize:16] constraints:CGSizeMake(width, 0) limitedToNumberOfLines:0 autoDetectUrls:NO];
        
        H = 65 + (height - 21);
        
        if (self.rsp.order.serviceType == 181) {
            H = 0;
        }
    }else if (indexPath.row == YJYInsureOrderDetailTypeContactAddress) {
        
        CGSize size = [self.addressLabel.text boundingRectWithSize:CGSizeMake(self.addressLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.addressLabel.font} context:nil].size;
        double height = ceil(size.height);
        
        return 70 + (height - 17);
        
    }else if (indexPath.row >= YJYInsureOrderDetailTypeBeDaijiao &&
              indexPath.row <= YJYInsureOrderDetailTypeDaijiao) {
        
        H = self.rsp.order.serviceType == 181 ? H: 0;
        
    }else if (indexPath.row == YJYInsureOrderDetailTypeOrderTime) {
        
        H = self.rsp.order.serviceType == 181 ? H: 0;
        
    }
    
    return H;
}
@end

@interface YJYInsureOrderDetailController ()

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewHConstraint;


@property (strong, nonatomic) YJYInsureOrderDetailContentController *contentVC;
@property (strong, nonatomic) NSMutableArray *buttonViews;
@property (strong, nonatomic) NSDictionary *dictInfo;

@end

@implementation YJYInsureOrderDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureOrderDetailController *)[UIStoryboard storyboardWithName:@"YJYInsureOrderDetail" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonViews = [NSMutableArray array];
    self.dictInfo = [self assembleDictM];
    
    if (self.hasToBackRoot) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];
    }
    
}

- (void)close {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureOrderDetailContentController"]) {
        
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYInsureOrderDetailContentController *)segue.destinationViewController;
        self.contentVC.orderVO = self.orderVO;
        self.contentVC.orderId = self.orderId;
        
        if (!self.orderVO) {
            OrderVO *orderVO = [OrderVO new];
            orderVO.orderId = self.orderId;
            self.contentVC.orderVO = orderVO;
            self.contentVC.orderId = self.orderId;

        }
        self.contentVC.didLoadBlock = ^{
        
            [weakSelf reloadToolView];
            
        };
    }
}


- (void)reloadToolView {
    
    //先清空
    for (UIView *subView in self.buttonViews) {
        [subView removeFromSuperview];
    }
    self.buttonViews = [NSMutableArray array];
    
    
    NSMutableArray *dictS = [NSMutableArray array];
    [self.contentVC.rsp.buttonsArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *menuDict = [self.dictInfo valueForKey:[NSString stringWithFormat:@"%@",@(value)]];
        [dictS addObject:menuDict];

    }];
    
    NSArray *menuItems = [OrderMenuItem mj_objectArrayWithKeyValuesArray:dictS];
    [self reloadButtonsWithArray:menuItems];
    
    self.toolViewHConstraint.constant = (menuItems.count > 0) ? 60 : 0;
    self.toolView.hidden = (menuItems.count == 0);
    
    
}

- (void)reloadButtonsWithArray:(NSArray *)serviceItems {
    
    CGFloat width = self.toolView.frame.size.width/serviceItems.count+1;
    
    for (NSInteger i = 0; i < serviceItems.count; i ++) {
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(i * width, 0, width, self.toolView.frame.size.height)];
        
        OrderMenuItem *orderMenuItem = serviceItems[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonView.bounds;
        [button setTitle:orderMenuItem.title forState:0];
        [button addTarget:self action:NSSelectorFromString(orderMenuItem.func) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.minimumScaleFactor = 0.2;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitleColor:[UIColor whiteColor] forState:0];
        
        [buttonView addSubview:button];
        
        
        //line
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width - 1, 15, 1, button.frame.size.height - 30)];
        line.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.3];
        line.alpha = 0.3;
        [buttonView addSubview:line];
        
        [self.toolView addSubview:buttonView];
        
        [self.buttonViews addObject:buttonView];
        
    }
}




#pragma mark - Action

//取消订单
- (void)toCancelOrder {
    
    
    /// 1-上门不及时 2-病情变化不需要了 3-订单填写错误 4-其他原因

    [UIAlertController showAlertInViewController:self withTitle:@"是否取消订单" message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"上门不及时" otherButtonTitles:@[@"病情变化不需要了",@"订单填写错误",@"其他原因"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex > 0) {
            
            [SYProgressHUD show];
            CancelOrderNewReq *req = [CancelOrderNewReq new];
            req.cancelOrderId = (uint32_t)buttonIndex;
            req.orderId = self.contentVC.rsp.order.orderId;
            [YJYNetworkManager requestWithUrlString:SAASAPPCancelOrderNew message:req controller:self command:APP_COMMAND_SaasappcancelOrderNew success:^(id response) {
                
                [self.contentVC loadNetworkData];
                [SYProgressHUD hide];
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
    }];
    
    
}
//接单
- (void)toJiedan {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否接单" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            GetKinsInsureReq *req = [GetKinsInsureReq new];
            req.hgnoName = self.contentVC.rsp.order.hgName;
            req.orderId = self.contentVC.rsp.order.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPAcceptInsureOrder message:req controller:self command:APP_COMMAND_SaasappacceptInsureOrder success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
}
//安排带教
- (void)toCreateTeachRecord {
    
    
    GetInsurePriceListReq *req = [GetInsurePriceListReq new];
    req.insureNo = self.contentVC.rsp.order.insureNo;
    req.serviceType = 181;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsurePriceList message:req controller:self command:APP_COMMAND_SaasappgetInsurePriceList success:^(id response) {
        
        GetInsurePriceListRsp *rsp = [GetInsurePriceListRsp parseFromData:response error:nil];
        InsurePriceVO *insurePriceVO = rsp.priceListArray.firstObject;
        
        YJYInsureReviewApplyController *vc = [YJYInsureReviewApplyController instanceWithStoryBoard];
        vc.insureNo = self.contentVC.rsp.order.insureNo;
        vc.orderId = self.contentVC.rsp.order.orderId;
        vc.orderDetailRsp = self.contentVC.rsp;
        vc.insurePriceVO = insurePriceVO;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
    

}
//修改订单
- (void)toUpdateOrder {
    
    YJYInsureOrderUpdateController *vc = [YJYInsureOrderUpdateController instanceWithStoryBoard];
    vc.orderDetailRsp = self.contentVC.rsp;
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//发放资质
- (void)toSendCert {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否发放资质" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            GetKinsInsureReq *req = [GetKinsInsureReq new];
            req.hgnoName = self.contentVC.rsp.order.hgName;
            req.orderId = self.contentVC.rsp.order.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPGrantInsureOrder message:req controller:self command:APP_COMMAND_SaasappgrantInsureOrder success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
   
    
}
//变更陪护家属
- (void)toUpdateKins {
    
    YJYInsureOrderRelationController *vc = [YJYInsureOrderRelationController instanceWithStoryBoard];
    vc.orderDetailRsp = self.contentVC.rsp;
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//开启服务
- (void)toStartService {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否开启服务" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            GetKinsInsureReq *req = [GetKinsInsureReq new];
            req.hgnoName = self.contentVC.rsp.order.hgName;
            req.orderId = self.contentVC.rsp.order.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPOpenInsureOrder message:req controller:self command:APP_COMMAND_SaasappopenInsureOrder success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
  
}
//结束服务
- (void)toEndService {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager && self.orderVO.status == 4 && self.contentVC.rsp.isOrderTendItem == 2) {
        
        //自照订单 客户经理 该订单是否有未完成 ->存在
        
        [UIAlertController showAlertInViewController:self withTitle:@"订单今日服务尚未完成，是否直接结束订单？（未完成服务当天的补贴不会计算）" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
           
            if (buttonIndex == 1) {
                [self toFinishReq];
            }
        }];
        
        return;
    }
   
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否结束服务" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self toFinishReq];
        }
        
    }];
}
- (void)toFinishReq {
    GetKinsInsureReq *req = [GetKinsInsureReq new];
    req.hgnoName = self.contentVC.rsp.order.hgName;
    req.orderId = self.contentVC.rsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPFinishInsureOrder message:req controller:self command:APP_COMMAND_SaasappfinishInsureOrder success:^(id response) {
        
        [self.contentVC loadNetworkData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//补贴估算
- (void)toSubsidy {
    
    YJYInsureEstimateFeeController *vc = [YJYInsureEstimateFeeController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//再次下单
- (void)toAgainOrder {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否再次下单" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            YJYInsureReviewApplyController *vc = [YJYInsureReviewApplyController instanceWithStoryBoard];
            vc.insureNo = self.contentVC.rsp.order.insureNo;
            vc.orderDetailRsp = self.contentVC.rsp;
            vc.priceId = self.contentVC.rsp.order.priceId;
            [self.navigationController pushViewController:vc animated:YES];
      
        }
        
    }];
    

}
//服务确认
- (void)toServiceConfirm {
    
    if (self.contentVC.rsp.serviceAddr == 0) {
        
        YJYInsureDailyComfireController *vc = [YJYInsureDailyComfireController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
//        [SYProgressHUD showFailureText:@"今天休假"];
        return;
    }
   
//    self.contentVC.rsp.serviceAddr >= 0 &&
    if (self.contentVC.rsp.serviceAddr <= 2) {
        
        GetInsureOrderTendItemDetailReq *req = [GetInsureOrderTendItemDetailReq new];
        req.orderId = self.contentVC.rsp.order.orderId;
        
        [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderTendItemDetail  message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderTendItemDetail success:^(id response) {
            
            YJYInsureDailyDetailController *vc = [YJYInsureDailyDetailController instanceWithStoryBoard];
            vc.toComfire = YES;
            vc.orderId = self.contentVC.rsp.order.orderId;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
    }else {
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否确认服务" message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"在家服务" otherButtonTitles:@[@"在医院服务",@"今天休假"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            ConfirmInsureOrderTendItemAddrReq *req = [ConfirmInsureOrderTendItemAddrReq new];
            req.orderId = self.contentVC.rsp.order.orderId;
            req.status = (uint32_t)buttonIndex - 1;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmInsureOrderTendItemAddr message:req controller:self command:APP_COMMAND_SaasappconfirmInsureOrderTendItemAddr success:^(id response) {
                
                
                if (buttonIndex == 1) {
                    
                    YJYInsureDailyDetailController *vc = [YJYInsureDailyDetailController instanceWithStoryBoard];
                    vc.toComfire = YES;
                    vc.orderId = self.contentVC.rsp.order.orderId;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (buttonIndex == 2) {
                    
                    YJYInsureDailyDetailController *vc = [YJYInsureDailyDetailController instanceWithStoryBoard];
                    vc.toComfire = YES;
                    vc.orderId = self.contentVC.rsp.order.orderId;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (buttonIndex == 3) {
                    
                    [self.contentVC loadNetworkData];
                    
                    
                }
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }];
        
        
    }
    
    
    
}
//申请结束服务
- (void)toApplyEndService {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否申请结束服务" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            OrderJPushReq *req = [OrderJPushReq new];
            req.jpushType = 1;
            req.orderId = self.contentVC.rsp.order.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPInsureOrderJPush message:req controller:self command:APP_COMMAND_SaasappinsureOrderJpush success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
       
    }];
    
    
    
    
}
//指派护士
- (void)toAssignHs {
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    vc.isGuide = YES;
    vc.isNurse = YES;
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        
        [self.contentVC loadNetworkData];

    };
    [self.navigationController pushViewController:vc animated:YES];
}
//更换护士
- (void)toUpdateHs {
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    vc.isNurse = YES;
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        
        [self.contentVC loadNetworkData];

    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//照护计划审核
- (void)toCheckTend {
    
    YJYInsureCarePlanController *vc = [YJYInsureCarePlanController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    vc.title = @"审核照护计划";
    [self.navigationController pushViewController:vc animated:YES];
    
}
//照护计划管理
- (void)toTendManage {
    
    YJYInsureCarePlanController *vc = [YJYInsureCarePlanController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    vc.title =@"照护计划列表";
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//回访记录
- (void)toVisitRecord {
    
    YJYInsureBackVisitListController *vc = [YJYInsureBackVisitListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}
//自照考核
- (void)toSelfAssess {
    
    YJYInsureAddReviewController *vc = [YJYInsureAddReviewController instanceWithStoryBoard];
    vc.orderDetailRsp = self.contentVC.rsp;
    [self.navigationController pushViewController:vc animated:YES];
}
//指派带教人员
- (void)toAssignTeach {
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    vc.isNurse = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ? YES: NO;
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        
        [self.contentVC loadNetworkData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

//转出订单
- (void)toTransferOrder {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否转出订单" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            TransferInsureOrderReq *req = [TransferInsureOrderReq new];
            req.hgId = self.contentVC.rsp.order.hgId;
            req.orderId = self.contentVC.rsp.order.orderId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPTransferInsureOrder message:req controller:self command:APP_COMMAND_SaasapptransferInsureOrder success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
}
//更换带教人员
- (void)toUpdateHgTeach {
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.orderDetailRsp  = self.contentVC.rsp;
    vc.isNurse = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ? YES: NO;
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        
        [self.contentVC loadNetworkData];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toTeachRecord {
    
    YJYInsureGuideTeachDetailController *vc = [YJYInsureGuideTeachDetailController instanceWithStoryBoard];
    vc.orderId  = self.contentVC.rsp.order.orderId;
    vc.didDoneBlock = ^{
        
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Dict

- (NSDictionary *)assembleDictWithNumber:(NSInteger)number title:(NSString *)title func:(NSString *)func {
    
    NSString *key = [NSString stringWithFormat:@"%@",@(number)];
    NSDictionary *dict = @{key:@{@"title":title,@"func":func}};
    
    return dict;
    
}

- (NSMutableDictionary *)assembleDictM {
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_CancelOrder title:@"取消订单" func:@"toCancelOrder"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_Jiedan title:@"接单" func:@"toJiedan"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_Teach title:@"安排带教" func:@"toCreateTeachRecord"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_UpdateOrder title:@"修改订单" func:@"toUpdateOrder"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_SendCert title:@"发放资质" func:@"toSendCert"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_UpdateKins title:@"变更陪护家属" func:@"toUpdateKins"]];
    
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_StartService title:@"开启服务" func:@"toStartService"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_EndService title:@"结束服务" func:@"toEndService"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_Subsidy title:@"补贴估算" func:@"toSubsidy"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_AgainOrder title:@"再次下单" func:@"toAgainOrder"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_ServiceConfirm title:@"服务确认" func:@"toServiceConfirm"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_ApplyEndService title:@"申请结束服务" func:@"toApplyEndService"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_AssignHs title:@"指派护士" func:@"toAssignHs"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_UpdateHs title:@"更换护士" func:@"toUpdateHs"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_CheckTend title:@"照护计划审核" func:@"toCheckTend"]];
    
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_TendManage title:@"照护计划管理" func:@"toTendManage"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_VisitRecord title:@"回访记录" func:@"toVisitRecord"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_SelfAssess title:@"自照考核" func:@"toSelfAssess"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_AssignTeach title:@"指派带教人员" func:@"toAssignTeach"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_TransferOrder title:@"转出订单" func:@"toTransferOrder"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_UpdateHgTeach title:@"更换带教人员" func:@"toUpdateHgTeach"]];
    [dictM addEntriesFromDictionary:[self assembleDictWithNumber:OrderButton_TeachRecord title:@"记录本次带教情况" func:@"toTeachRecord"]];
    
    return dictM;
    
}


@end
