//
//  YJYInsureEstimateFeeController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureEstimateFeeController.h"


@interface YJYInsureEstimateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mouthDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *mouthFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mouthDetailFeeLabel;


@property (strong, nonatomic) SubsidyVO *subsidyVO;
@end

@implementation YJYInsureEstimateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}
- (void)setSubsidyVO:(SubsidyVO *)subsidyVO {
    
    _subsidyVO = subsidyVO;
    self.mouthDesLabel.text = subsidyVO.monthDesc;
    self.mouthFeeLabel.text = [NSString stringWithFormat:@"%@元",subsidyVO.amountStr];
    self.mouthDetailFeeLabel.text = subsidyVO.subsidyDesc;
    
    // [NSString stringWithFormat:@"%@天*%@元",@(subsidyVO.days),@(subsidyVO.unit)];
}

@end

@interface YJYInsureEstimateFeeController ()


@property (strong, nonatomic) GetReckonSubsidyRsp *rsp;

@end

@implementation YJYInsureEstimateFeeController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderFee" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetReckonSubsidy message:req controller:self command:APP_COMMAND_SaasappgetReckonSubsidy success:^(id response) {
        
        self.rsp = [GetReckonSubsidyRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    [self reloadAllData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.subsidyListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureEstimateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureEstimateCell" forIndexPath:indexPath];
    
    
    SubsidyVO *subsidyVO = self.rsp.subsidyListArray[indexPath.row];
    cell.subsidyVO = subsidyVO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

@end