//
//  YJYOrderListController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderListController.h"
#import "YJYOrderDetailController.h"
#import "YJYOrderReviewController.h"
#import "YJYOrderPayOffListController.h"
#import "YJYOrderSettleController.h"
#import "YJYInsureOrderDetailController.h"

/////订单状态  0 - 待付款 1 - 代派工 2 - 待服务 3 - 服务中 4 - 待支付 5 - 待评价 6 - 已完成

typedef void(^OrdersItemCellDidActionBlock)(id string);
typedef void(^OrdersItemCellDidCheckPlanBlock)();


@interface YJYOrdersItemCell : UITableViewCell

@property (strong, nonatomic) OrderVO *order;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *servicerLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServicerLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

//完成
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView * stateImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (copy, nonatomic) OrdersItemCellDidActionBlock ordersItemCellDidActionBlock;
@property (copy, nonatomic) OrdersItemCellDidCheckPlanBlock didCheckPlanBlock;

@end

@implementation YJYOrdersItemCell

- (void)setOrder:(OrderVO *)order {
    
    _order = order;

   
    self.placeLabel.text = (order.orderType == 1) ? order.hospital : order.location;
    self.timeLabel.text = order.createTime;
    self.packageLabel.text = order.service;
    self.beServicerLabel.text = order.kinsName;
    
 
    self.servicerLabel.text = order.serviceStaff;
    
    
    self.numberLabel.hidden = !(order.status == OrderStatus_WaitPayPrefee || order.status == OrderStatus_ServiceComplete);
    self.numberLabel.hidden = (order.needPay.length == 0);
    
    if (order.status == OrderStatus_ServiceComplete) {
        
        self.numberLabel.text = [NSString stringWithFormat:@"%@ %@ 元",(order.payFlag == 2 ? @"待退款" : @"待付款"),(order.payFlag == 2 ? order.needRefundFee : order.needPay)];

    }else {
        self.numberLabel.text = [NSString stringWithFormat:@"待付款 %@ 元",order.needPay];

    }
    self.checkButton.hidden = !(order.insureType == 1 && order.status == OrderStatus_ServiceIng);
 
    UIColor  *statusColor;
    NSString  *statusImageName;

    
    
    if (order.status == OrderStatus_WaitPayPrefee) {
        
        statusColor = kWaitPayPrefeeColor;
        statusImageName = @"order_wait_pay_icon";
        
    }else if (order.status == OrderStatus_WaitAssign) {
    
     
        statusColor = kWaitAssignColor;
        statusImageName = @"order_wait_guide_icon";

    }else if (order.status == OrderStatus_WaitService) {
       
        statusColor = kWaitAssignColor;
        statusImageName = @"order_wait_server_icon";
     
        
    }else if (order.status == OrderStatus_ServiceIng) {
        
        
    
        statusColor = kServiceIngColor;
       statusImageName = @"order_serving_icon";
        
    }else if (order.status == OrderStatus_ServiceComplete) {
       
        statusColor = kWaitCheckoutColor;
        statusImageName = @"order_wait_payoff_icon";
        
    }else if (order.status == OrderStatus_WaitAppraise) {
       
        statusColor = kWaitAppraiseColor;
        statusImageName = @"order_wait_review_icon";

        
    }else if (order.status == OrderStatus_OrderComplete) {
     
        statusColor = kOrderCompleteColor;
        statusImageName = @"order_reviewed_icon";
        
    }else {
        statusColor = APPGrayCOLOR;
        statusImageName = @"order_canceled_icon";
    }
    
    self.stateImageView.image = [UIImage imageNamed:statusImageName];
    
    self.stateLabel.text = order.statusStr;
    self.stateLabel.textColor = statusColor;
    
    
    self.actionButton.hidden = (order.actionStr.length == 0);
    [self.actionButton setTitle:order.actionStr forState:0];
    [self.actionButton setTitleColor:statusColor forState:0];
    self.actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.actionButton.backgroundColor = [UIColor clearColor];
    self.actionButton.layer.cornerRadius = 4;//self.actionButton.frame.size.height/2;
    self.actionButton.layer.borderColor = statusColor.CGColor;
    self.actionButton.layer.borderWidth = 1;

}

- (IBAction)operationAction:(UIButton *)sender {
    
    if (self.ordersItemCellDidActionBlock) {
        self.ordersItemCellDidActionBlock(sender.currentTitle);
    }
    
}

- (IBAction)checkPlanAction:(id)sender {
    
    if (self.didCheckPlanBlock) {
        self.didCheckPlanBlock();
    }
}
@end

@interface YJYOrderListController ()


@property (strong, nonatomic) NSMutableArray<OrderVO*> *orderListArray;
@property (assign, nonatomic) uint32_t pageNum;
@property (assign, nonatomic) BOOL isSetting;


@end

@implementation YJYOrderListController



+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderListController *)[UIStoryboard storyboardWithName:@"YJYOrder" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
  
    self.isNaviError = YES;

    [super viewDidLoad];
    
    

    self.orderListArray  = [NSMutableArray array];
    self.pageNum = 1;
    

    
    self.reloadButton.frame = CGRectMake(self.reloadButton.frame.origin.x, self.reloadButton.frame.origin.x, 100, 35);
    self.reloadButton.layer.cornerRadius = 5;
    self.reloadButton.layer.borderColor = APPGrayCOLOR.CGColor;
    self.reloadButton.layer.borderWidth = 1;
    self.reloadButton.backgroundColor = [UIColor clearColor];
    [self.reloadButton setTitleColor:APPGrayCOLOR forState:0];
    [self.reloadButton addTarget:self action:@selector(goToCreate:) forControlEvents:UIControlEventTouchUpInside];
    
   
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
   
    
    if (self.orderListArray.count == 0) {
        [SYProgressHUD show];
        
    }
    
    
    //notification
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadOrderList) name:kYJYOrderListUpdateNotification object:nil];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
        [self loadNetworkData];

    });
}


- (void)viewWillLayoutSubviews {
    
    if (!self.isSetting) {
        [self reloadError];

    }
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];


}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    [self loadNetworkData];

}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadOrderList {
    
    
    self.pageNum = 1;
    [self loadNetworkData];

}



- (void)loadNetworkData {


    GetOrderListReq *req = [GetOrderListReq new];
    req.tabType = self.orderListType-10;
    req.pageNum = self.pageNum;
    req.pageSize = 10;
    
    [YJYNetworkManager requestWithUrlString:AppgetOrderList message:req controller:nil command:APP_COMMAND_AppgetOrderList success:^(id response) {
        
        
        GetOrderListRsp *rsp = [GetOrderListRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.orderListArray.count >= rsp.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.orderListArray addObjectsFromArray:rsp.orderListArray];

            }

        }else {
            self.orderListArray = rsp.orderListArray;
            [self.tableView.mj_footer resetNoMoreData];

        }
        self.isLayout = NO;

        [self reloadAllData];

        
    } failure:^(NSError *error) {
        self.isLayout = NO;

        [self reloadErrorData];


    }];
    
}

- (void)reloadError {
    
    self.dataShowType = NoDataShowTypeDesButton;

    if (self.orderListType == OrderListTypeAll) {
        self.descTitle = @"你还没有使用过我们的服务\n  如有需要请在首页下单";
        self.noDataTitle = @"去下单";
    }else if (self.orderListType == OrderListTypeProcess) {
        self.descTitle = @"你还没有没有进行中的订单\n如需要服务,请到首页选择";
        self.noDataTitle = @"去下单";
    }else if (self.orderListType == OrderListTypeFinish) {
        self.descTitle = @"当前没有已完成的订单";
        self.noDataTitle = @"去下单";
    }
    self.isSetting = YES;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //Second
    YJYOrdersItemCell * cell =(YJYOrdersItemCell *) [tableView dequeueReusableCellWithIdentifier:@"YJYOrdersItemCell" forIndexPath:indexPath];
    
    OrderVO *order = self.orderListArray[indexPath.row];
    cell.order = order;
    cell.ordersItemCellDidActionBlock = ^(id string) {
        [self operationActionWithOrder:order];
    };
    
    cell.didCheckPlanBlock = ^{
        [self toCheckPlanWithOrder:order];
    };
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OrderVO *order = self.orderListArray[indexPath.row];
    
    if (order.insureType == 1) {
        
        YJYInsureOrderDetailController *vc= [YJYInsureOrderDetailController instanceWithStoryBoard];
        vc.insureNo = order.insureNo;
        vc.orderId = order.orderId;
        vc.orderState = order.status;
        [self.navigationController pushViewController:vc animated:YES];

        return;
        
    }
    
    if(order.status == OrderStatus_ServiceIng ||
       order.status == OrderStatus_ServiceComplete ||
       order.status == OrderStatus_WaitAppraise||
       order.status == OrderStatus_OrderComplete){
        
        //有子订单
        YJYOrderSettleController *vc = [YJYOrderSettleController instanceWithStoryBoard];
        vc.order = order;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        //没开始或者结束了订单
        YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
        vc.order = order;
        vc.detailDidActionBlock = ^{
            [self loadNetworkData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderVO *order = self.orderListArray[indexPath.row];
    
    
//    BOOL actionHidden = !(order.status == OrderStatus_WaitPayPrefee || order.status == OrderStatus_ServiceComplete);
//    actionHidden = (order.needPay.length == 0);
    
    return 260 - (order.status == OrderStatus_Cancel ? 70 : 0);
}
- (void)goToCreate:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"去下单"]) {
        [self.parentViewController.tabBarController setSelectedIndex:0];

    }
    
}

- (void)toCheckPlanWithOrder:(OrderVO *)order{
    
    
}
- (void)operationActionWithOrder:(OrderVO *)order{
    
    
    if (order.status == OrderStatus_WaitAssign || order.status == OrderStatus_WaitService) {
        
//        UIWebView *callWebView = [[UIWebView alloc] init];        
//        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",order.kfPhone]];
//        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
//        [self.view addSubview:callWebView];
        [SYProgressHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",order.kfPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [SYProgressHUD hide];
        });
       
        
    }else if(order.status == OrderStatus_ServiceComplete  || order.status == OrderStatus_ServiceIng){
        
        YJYOrderSettleController *vc = [YJYOrderSettleController instanceWithStoryBoard];
        vc.order = order;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (order.status == OrderStatus_WaitAppraise || order.status ==  OrderStatus_OrderComplete){
        
        YJYOrderReviewController *vc = [YJYOrderReviewController instanceWithStoryBoard];
        vc.order = order;
        vc.isEdit = (order.status != OrderStatus_OrderComplete);

        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
        vc.order = order;
        vc.detailDidActionBlock = ^{
            [self loadNetworkData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    }
@end
