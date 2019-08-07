//
//  YJYAbnormalController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/6/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYAbnormalController.h"
typedef void(^YJYAbnormalCellDidDoneBlock)();


@interface YJYAbnormalCell : UITableViewCell
@property (strong, nonatomic) OrderListVO *orderListVO;

@property (weak, nonatomic) IBOutlet UILabel *carePeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UIButton *recoverButton;
@property (copy, nonatomic) YJYAbnormalCellDidDoneBlock didDoneBlock;
@end

@implementation YJYAbnormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.recoverButton.layer.cornerRadius = 5;
}
- (IBAction)toRecover:(id)sender {
    if (self.didDoneBlock) {
        self.didDoneBlock();
    }
}

-(void)setOrderListVO:(OrderListVO *)orderListVO {
    
    _orderListVO = orderListVO;
    
    self.carePeopleLabel.text = orderListVO.kinsName;
    self.orderIdLabel.text = orderListVO.orderId;
    self.serviceLabel.text = orderListVO.serviceItem;
    self.addressLabel.text = orderListVO.addrDetail;
    
    
    ///-1-已取消 0-待付款预交金,1-待派工,2-待服务,3-服务中,4-服务完成,5-待评价,6-已完成

    
    uint32_t status = orderListVO.status;
    NSString *statusImageName;
    
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
    [self.stateImageView setImage:[UIImage imageNamed:statusImageName]];
    
    
    
}

@end

@interface YJYAbnormalController ()<UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (copy, nonatomic) NSString *key;
@property (strong, nonatomic) SearchAbnormalOrderRsp *rsp;
@end

@implementation YJYAbnormalController
+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYAbnormal" viewControllerIdentifier:className];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noDataTitle = @"未查询到可恢复的订单";
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNetworkData];

    });
    
}

- (void)loadNetworkData {
    
    
    SearchAbnormalOrderReq *req = [SearchAbnormalOrderReq new];
    if (self.key && self.key.length > 0) {
        [SYProgressHUD show];
        req.key = self.key;
        [YJYNetworkManager requestWithUrlString:SAASAPPSearchAbnormalOrder message:req controller:self command:APP_COMMAND_SaasappsearchAbnormalOrder success:^(id response) {
            
            [SYProgressHUD hide];
            self.rsp = [SearchAbnormalOrderRsp parseFromData:response error:nil];
            
            [self reloadAllData];
            
        } failure:^(NSError *error) {
            
            [self reloadErrorData];
        }];

    }else {
        
        [self reloadAllData];

    }
    

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.rsp.voListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJYAbnormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYAbnormalCell" forIndexPath:indexPath];
    
    OrderListVO *orderListVO = self.rsp.voListArray[indexPath.row];
    cell.orderListVO = orderListVO;
    cell.didDoneBlock = ^{
        
        [self toRecoverWithOrderListVO:orderListVO];
        
    };
    return cell;
}

- (void)toRecoverWithOrderListVO:(OrderListVO *)orderListVO  {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否确认将该订单恢复服务？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            OrderItemNightReq *req = [OrderItemNightReq new];
            req.orderId = orderListVO.orderId;
            [YJYNetworkManager requestWithUrlString:SAASAPPRecoverOrder message:req controller:self command:APP_COMMAND_SaasapprecoverOrder success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"恢复成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadNetworkData];
                });
                
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
}
- (IBAction)toSearch:(id)sender {
    
    self.key = self.searchBar.text;
    [self loadNetworkData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {
//
//    self.key = self.searchBar.text;
//    [self loadNetworkData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 240;
}
@end
