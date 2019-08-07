//
//  YJYOrderAddAdjustController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/10.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderAddAdjustController.h"

@interface YJYOrderAddAdjustCell : UITableViewCell

@property (strong, nonatomic) OrderItemInvertVO *orderItemInvert;

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

@implementation YJYOrderAddAdjustCell

- (void)setOrderItemInvert:(OrderItemInvertVO *)orderItemInvert {
    
    _orderItemInvert = orderItemInvert;
    
    self.serviceLabel.text = orderItemInvert.service;
    self.unitLabel.text = orderItemInvert.priceStr;
    self.numberLabel.text = orderItemInvert.numberStr;
    self.feeLabel.text = orderItemInvert.costStr;
}

@end


@interface YJYOrderAddAdjustController ()

@property (strong, nonatomic)OrderItemInvertRsp *rsp;
@property (weak, nonatomic) IBOutlet UILabel *adjustMoneyLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation YJYOrderAddAdjustController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderAddAdjustController *)[UIStoryboard storyboardWithName:@"YJYOrderService" viewControllerIdentifier:NSStringFromClass([self class])];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView.tableFooterView = self.bottomView;
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    GetOrderProcessReq *req = [GetOrderProcessReq new];
    req.orderId = self.orderVo.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASGetOrderItemInvertList message:req controller:self command:APP_COMMAND_SaasappgetOrderItemInvertList success:^(id response) {
        
        
        self.rsp = [OrderItemInvertRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)reloadRsp {
    
    self.adjustMoneyLabel.text = [NSString stringWithFormat:@"附加服务：%@元",self.orderVo.reviseFee];
}

#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rsp.orderItemInverArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderAddAdjustCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderAddAdjustCell"];
    
    cell.orderItemInvert = self.rsp.orderItemInverArray[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55;
}


@end
