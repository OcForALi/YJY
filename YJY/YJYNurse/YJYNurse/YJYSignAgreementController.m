
//
//  YJYSignAgreementController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/7/10.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYSignAgreementController.h"
#import "YJYOrderDetailController.h"

@interface YJYSignAgreementCell : UITableViewCell<MDHTMLLabelDelegate>
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




@property (weak, nonatomic) IBOutlet UIImageView * stateImageView;

@property (strong, nonatomic) OrderListVO *orderListVO;

@end

@implementation YJYSignAgreementCell

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
    self.branchLabel.text = [NSString stringWithFormat:@"%@",order.branchName];
    self.stateImageView.image = [UIImage imageNamed:statusImageName];
    self.nameLabel.text = order.kinsName;
    
    //    self.otherDesLabel.text = [NSString stringWithFormat:@"%@ %@岁 %@",order.sexStr,@(order.age),order.orgNo];
    self.otherDesLabel.text = [NSString stringWithFormat:@"%@",order.orgNo];
    
    self.orderTimeLabel.text = order.createTime;
    
    self.branchLabel.alpha = status == OrderStatus_OrderComplete ? 0.3 : 1;
    self.nameLabel.alpha = status == OrderStatus_OrderComplete ? 0.3 : 1;
    self.orderTimeLabel.alpha = status == OrderStatus_OrderComplete ? 0.3 : 1;
    
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}

@end

@interface YJYSignAgreementController ()<UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *orderListArray;
@property (assign, nonatomic) uint32_t pageNum;
@property (copy, nonatomic) NSString *searchText;
@end

@implementation YJYSignAgreementController
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYSignAgreementController *)[UIStoryboard storyboardWithName:@"YJYSignAgreement" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    self.searchBar.delegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    
    [self loadNetworkData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNetworkData];

}
- (void)loadNetworkDataWithSearchText:(NSString *)searchText{
    

    
    
    GetOrderListNewReq *req = [GetOrderListNewReq new];
    req.onlyNotSign = YES;
    req.pageNo = self.pageNum;
    
    
    if (searchText) {
        
        req.keyword = searchText;
        
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

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.orderListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYSignAgreementCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYSignAgreementCell"];
    cell.orderListVO = self.orderListArray[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
    vc.orderListVO = self.orderListArray[indexPath.row];
    vc.isReSign = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderListVO *order = self.orderListArray[indexPath.row];
    
    CGFloat addressWidth = self.tableView.frame.size.width - (35+80+5);
    
    CGFloat markExtraHeight = [order.addrDetail boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height - 10;
    
    return 140 + markExtraHeight;
    
}

#pragma mark - SearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.pageNum = 1;
    [self loadNetworkDataWithSearchText:searchBar.text];
    
}

@end
