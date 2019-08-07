//
//  YJYPeirenDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/8/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYPeirenDetailController.h"

@interface YJYPeirenDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property (strong, nonatomic) OrderPRCItemVO *orderPRCItemVO;

@end

@implementation YJYPeirenDetailCell

- (void)setOrderPRCItemVO:(OrderPRCItemVO *)orderPRCItemVO {
    
    _orderPRCItemVO = orderPRCItemVO;
    self.rentTimeLabel.text = orderPRCItemVO.serviceDate;
    self.rentMoneyLabel.text = orderPRCItemVO.feeStr;
    [self.signImageView xh_setImageWithURL:[NSURL URLWithString:orderPRCItemVO.picURL]];
}

@end

@interface YJYPeirenDetailController ()
@property (strong, nonatomic) GetOrderPRCItemRsp *rsp;
@end

@implementation YJYPeirenDetailController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYPeiRenDetail" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.noDataTitle = @"暂无陪人床租借记录";
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
}
- (void)loadNetworkData {
    
    GetOrderInfoReq*req = [GetOrderInfoReq new];
    req.orderId = self.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderPRCItemList message:req controller:nil command:APP_COMMAND_SaasappgetOrderPrcitemList    success:^(id response) {
        
        
        self.rsp = [GetOrderPRCItemRsp parseFromData:response error:nil];
        
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rsp.itemsArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYPeirenDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYPeirenDetailCell"];
    cell.orderPRCItemVO = self.rsp.itemsArray[indexPath.row];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

@end
