//
//  YJYOrderListController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/20.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderListController.h"
#import "YJYOrderDetailController.h"
#import "YJYInsureOrderDetailController.h"

@interface YJYOrderListItemCell : UITableViewCell <MDHTMLLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;


//完成
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *curServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView * stateImageView;

@property (strong, nonatomic) OrderListVO *orderListVO;
@property (strong, nonatomic) OrderListVO *orderVO;
@end

@implementation YJYOrderListItemCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.typeLabel.layer.borderColor = APPHEXCOLOR.CGColor;
    self.typeLabel.layer.borderWidth = 1;
}

- (void)setOrderVO:(OrderListVO *)orderVO {
    
   //长护险 带教 自照
    
    _orderVO = orderVO;
    
    self.nameLabel.text = orderVO.kinsName;
    self.curServiceLabel.text = orderVO.serviceItem;
    self.orderTimeLabel.text = orderVO.createTime;
    
   
    /// 订单类型 1-机构订单 2-居家订单 3-长护险订单
    UIColor *typeColor;

    if (orderVO.serviceType == 180) {
        
        self.typeLabel.text = @"长护险";
        typeColor = APPHEXCOLOR;
        
    }else if (orderVO.serviceType == 181) {
        
        self.typeLabel.text = @"带教";
        typeColor = APPORANGECOLOR;

    }else {
        self.typeLabel.text = @"自照";
        typeColor = APPPurpleCOLOR;
        
    }
    self.typeLabel.textColor = typeColor;
    self.typeLabel.layer.borderColor = typeColor.CGColor;
    self.typeLabel.layer.borderWidth = 1;
    
    ///-1-已取消 0-待付款预交金,1-待派工,2-待服务,3-服务中,4-服务完成,5-待评价,6-已完成
    UIColor *stateColor;
    uint32_t status = orderVO.status;
    NSString  *statusImageName;
    
    
    if (status == 0 ||
        status == 1 ||
        status == 2 ||
        status == 6) {
        
        stateColor = APPREDCOLOR;
        
    }else if (status == 3){
        
        stateColor = APPHEXCOLOR;
        
    }else if (status == 4 ||
              status == 5){
        
        stateColor = APPORANGECOLOR;
        
        if (status == 4 && orderVO.settleItemStatus == 0) {
            stateColor = APPREDCOLOR;
            
        }
        
    }else if (status == -1){
        
        stateColor = APPNurseGrayRGBCOLOR;
        
        
    }
    /// 订单流转状态（不同于status）-1-已取消 0-待接单 1-待支付 2-待发放 3-已发放 4-待指派 5-已指派 6-待服务 7-服务中8-待结算  9-待评价 10-已完成

    uint32_t condition = orderVO.condition;

    
    if (condition == -1) {
        
        statusImageName = @"insure_canceled_icon";
        
    }else if (condition == 0) {
        
        
        statusImageName = @"insure_picked_icon";
        
    }else if (condition == 1) {
        
        
        statusImageName = @"insure_wait_pay_icon";
        
    }else if (condition == 2) {
        
        
        statusImageName = @"insure_released_icon";
        
    }else if (condition == 3) {
        
        
        statusImageName = @"insure_released_gray_icon";
        
    }else if (condition == 4) {
        
        
        statusImageName = @"insure_appoint_icon";
        
    }else if (condition == 5) {
        
        
        statusImageName = @"insure_appoint_gray_icon";
        
    }else if (condition == 6) {
        
        
        statusImageName = @"insure_serviced_icon";
        
    }else if (condition == 7) {
        
        
        statusImageName = @"insure_servicing_icon";
        
    }else if (condition == 8) {
        
        
        statusImageName = @"insure_wait_payoff_icon";
        
    }else if (condition == 9) {
        
        
        statusImageName = @"insure_assessed_icon";
        
    }else if (condition == 10) {
        
        
        statusImageName = @"insure_finished_icon";
        
    }
    
    
    
    self.stateButton.backgroundColor = stateColor;
    [self.stateImageView setImage:[UIImage imageNamed:statusImageName]];
}

- (void)setOrderListVO:(OrderListVO *)orderListVO {
    
    //普通订单
    _orderListVO = orderListVO;
    
    OrderListVO *order = orderListVO;
 
    self.nameLabel.text = order.kinsName;
    self.numberLabel.text = order.orderId;
    self.orderTimeLabel.text = order.createTime;

    self.contactLabel.delegate = self;
    

    
    
    if (order.contactPhone.length == 0) {
        self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:order.contacts phone:@""];

    }else {
        NSString *phone = orderListVO.showPhone ? order.contactPhone : [order.contactPhone stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        
        self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:order.contacts phone:phone];
        
    }
   
    self.contactLabel.userInteractionEnabled = orderListVO.showPhone;
    self.addressLabel.text = order.addrDetail;


    ///-1-已取消 0-待付款预交金,1-待派工,2-待服务,3-服务中,4-服务完成,5-待评价,6-已完成

    UIColor *stateColor;
    uint32_t status = order.status;
    NSString  *statusImageName;

    
    if (status == 0 ||
        status == 1 ||
        status == 2 ||
        status == 6) {
        
        stateColor = APPREDCOLOR;
        
    }else if (status == 3){
        
        stateColor = APPHEXCOLOR;
        
    }else if (status == 4 ||
              status == 5){
        
        stateColor = APPORANGECOLOR;
        
        if (status == 4 && order.settleItemStatus == 0) {
            stateColor = APPREDCOLOR;
            
        }
        
    }else if (status == -1){
        
        stateColor = APPNurseGrayRGBCOLOR;

        
    }
    self.stateButton.backgroundColor = stateColor;
    [self.stateButton setTitle:order.statusStr forState:0];

    
    
    
    //新增
   
    if (status == OrderStatus_Cancel) {
        
        statusImageName = @"insure_canceled_icon";
        
    }else if (status == OrderStatus_WaitPayPrefee) {
        
        
        statusImageName = @"insure_wait_pay_icon";
        
    }else if (status == OrderStatus_WaitAssign) {
        
        
        statusImageName =  @"insure_appoint_icon";
        
    }else if (status == OrderStatus_WaitService) {
        
        
        statusImageName = @"insure_serviced_icon";
        
    }else if (status == OrderStatus_ServiceIng) {
        
        
        statusImageName = @"insure_servicing_icon";
        
    }else if (status == OrderStatus_ServiceComplete) {
        
        
        statusImageName = @"insure_wait_payoff_icon";
        
        if (orderListVO.settleItemStatus == 0){
            
            statusImageName = @"insure_unconfirm_icon";
            
            
        }
        
    }else if (status == OrderStatus_WaitAppraise) {
        
        
        statusImageName = @"insure_assessed_icon";
        
    }else if (status == OrderStatus_OrderComplete) {
        
        
        statusImageName = @"insure_finished_icon";
        
    }

    
    self.bedLabel.text = [NSString stringWithFormat:@"%@",order.bedNo];
    self.branchLabel.text = [NSString stringWithFormat:@"%@%@",order.bedNo.length > 0 ? @"  ":@"",order.branchName];
    self.stateImageView.image = [UIImage imageNamed:statusImageName];
    self.nameLabel.text = order.kinsName;
    
//    self.otherDesLabel.text = [NSString stringWithFormat:@"%@ %@岁 %@",order.sexStr,@(order.age),order.orgNo];
    self.otherDesLabel.text = [NSString stringWithFormat:@"%@",order.orgNo];

    self.orderTimeLabel.text = order.createTime;
    
    self.branchLabel.alpha = status == OrderStatus_OrderComplete ? 0.3 : 1;
    self.nameLabel.alpha = status == OrderStatus_OrderComplete ? 0.3 : 1;
    self.orderTimeLabel.alpha = status == OrderStatus_OrderComplete ? 0.3 : 1;

    self.titleWidthConstraint.constant = order.bedNo.length == 0 ? 0 : self.titleWidthConstraint.constant;

}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}

@end


@interface YJYOrderListController ()

@property (strong, nonatomic) NSMutableArray *orderListArray;
@property (assign, nonatomic) uint32_t pageNum;
@property (copy, nonatomic) NSString *searchText;

@property (copy, nonatomic) NSString *orgId;
@property (nonatomic, strong) GPBUInt64Array *branchIdsArray;

@property (nonatomic, strong) OrgDistanceModel *currentOrgDistanceModel;
@property (nonatomic, strong) BranchModel *currentBranch;
@property (assign, nonatomic) uint32_t currentSortType;
@end

@implementation YJYOrderListController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderListController *)[UIStoryboard storyboardWithName:@"YJYOrder" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.orderListArray  = [NSMutableArray array];
    self.pageNum = 1;
    
 
   
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSearchData:) name:kYJYOrderUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadFilter:) name:kYJYOrderListFilterNotification object:nil];

    [self loadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkDataWithSearchText:self.searchText];

}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setListItem:(OrderListItem *)listItem {
    
    _listItem = listItem;
    [self loadNetworkData];

}
- (void)loadZZNetworkDataWithSearchText:(NSString *)searchText {
    
    GetOrderListNewReq *req = [GetOrderListNewReq new];
    req.tabType = self.listItem.type == YJYOrderInsureTypeAll ? -1 : self.listItem.type;
    req.pageNo = self.pageNum;
    
    if (searchText) {
        
        req.keyword = searchText;
        
    }
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderListNew message:req controller:nil command:APP_COMMAND_SaasappgetOrderListNew success:^(id response) {
        
        
        GetOrderListNewRsp *rsp = [GetOrderListNewRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (rsp.orderListArray.count == 0) {
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
#pragma mark - Network 

- (void)loadNetworkDataWithSearchText:(NSString *)searchText{

    
    
    if ([YJYRoleManager isZizhao]) {
        [self loadZZNetworkDataWithSearchText:searchText];
        return;
    }

    
    GetOrderListNewReq *req = [GetOrderListNewReq new];
    req.tabType = self.listItem.type;
    req.pageNo = self.pageNum;
    
   
    if (searchText) {
      
        req.keyword = searchText;

    }
    if (self.currentOrgDistanceModel && self.currentOrgDistanceModel.orgVo.orgId > 0) {
        req.orgId = self.currentOrgDistanceModel.orgVo.orgId;
    }
    
    if (self.currentBranch && self.currentBranch.id_p > 0) {
        GPBUInt64Array *branchIdsArray = [GPBUInt64Array array];
        [branchIdsArray addValue:self.currentBranch.id_p];
        req.branchIdsArray =  branchIdsArray;
    }
    /// 1-下单时间排序 2-床号排序
    req.sortType = 1;
    if (self.currentSortType > 0) {
        req.sortType =  self.currentSortType;

    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderListNew message:req controller:self command:APP_COMMAND_SaasappgetOrderListNew success:^(id response) {
        
        
        GetOrderListNewRsp *rsp = [GetOrderListNewRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (rsp.orderListArray.count == 0) {
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

- (void)loadNetworkData {
    
    [self loadNetworkDataWithSearchText:self.searchText];

    
}
- (void)reloadFilter:(NSNotification *)nofi {
    
    if (nofi.userInfo) {
        
        if ([nofi.userInfo valueForKey:@"currentOrgDistanceModel"]) {
            self.currentOrgDistanceModel = nofi.userInfo[@"currentOrgDistanceModel"];

        }
        
        if ([nofi.userInfo valueForKey:@"currentBranch"]) {
            self.currentBranch = nofi.userInfo[@"currentBranch"];
            
        }
        
        if ([nofi.userInfo valueForKey:@"currentSortType"]) {
            self.currentSortType = [nofi.userInfo[@"currentSortType"] integerValue];

        }

        [SYProgressHUD show];
        self.pageNum = 1;
        [self loadNetworkData];

        
        
    }
    
}
- (void)reloadSearchData:(NSNotification *)nofi {
    
    NSString *searchText = nofi.object;
    if (nofi.userInfo) {
        NSNumber *typeNumber = nofi.userInfo[@"type"];
        if ([typeNumber integerValue] == self.listItem.type) {
            self.searchText = searchText;
            self.pageNum = 1;
            [self loadNetworkDataWithSearchText:self.searchText];
        }
    }
    
    

    
    
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.orderListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = [YJYRoleManager isZizhao] ? @"YJYOrderListItemCellZZ" : @"YJYOrderListItemCellNew";
    YJYOrderListItemCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if ([YJYRoleManager isZizhao]) {
    
        cell.orderVO = self.orderListArray[indexPath.row];

    }else {
        cell.orderListVO = self.orderListArray[indexPath.row];
        
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([YJYRoleManager isZizhao]) {
        
        YJYInsureOrderDetailController *vc =  [YJYInsureOrderDetailController instanceWithStoryBoard];
        vc.orderVO = self.orderListArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
        vc.orderListVO = self.orderListArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([YJYRoleManager isZizhao]) {
        
        return 150;
    }else {
        
    
        OrderListVO *order = self.orderListArray[indexPath.row];
        
        CGFloat addressWidth = self.tableView.frame.size.width - (35+80+5);
        
        
//        NSString *orgName = [NSString stringWithFormat:@"%@ %@ %@ %@",order.orgName,order.branchName,order.roomNo,order.bedNo];
//        NSString *addressName = [NSString stringWithFormat:@"%@%@%@%@",order.province,order.city,order.district,order.addrDetail];
        
        CGFloat markExtraHeight = [order.addrDetail boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height - 10;
        
        return 140 + markExtraHeight;
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock();
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock();
    }
}



@end
