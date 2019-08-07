//
//  YJYOrderDailyDetailsCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/20.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderDailyDetailsCell.h"


@interface YJYOrderDailyDetailsItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *vLineView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (weak, nonatomic) IBOutlet UILabel *confirmCostStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidFeeStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *needPayStrLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkDetailButton;


@property (strong, nonatomic) SettlementVO *orderItem;
@property (copy, nonatomic) YJYOrderDailyDetailsToCellDetailBlock toCellDetailBlock;

@property (assign, nonatomic) BOOL doudaoConfig;
@property (assign, nonatomic) BOOL isDuoPei;


@end

@implementation YJYOrderDailyDetailsItemCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.stateButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.timeView yjy_setBottomShadow];
}

-(void)setOrderItem:(SettlementVO *)orderItem {

    _orderItem = orderItem;
    
    self.timeLabel.text = orderItem.serviceTime;
    BOOL hasPay = (orderItem.payState == 1);
    
    
    if (hasPay) {
        [self.stateButton setTitle:@"已支付" forState:0];
        [self.stateButton setImage:[UIImage new] forState:0];
        self.stateButton.backgroundColor = APPORANGECOLOR;

    }else {
        self.stateButton.backgroundColor = [UIColor clearColor];
        [self.stateButton setTitle:@"" forState:0];
        [self.stateButton setImage:[UIImage new] forState:0];

        
    }
   
    
    self.confirmCostStrLabel.text = orderItem.confirmCostStr;
    self.paidFeeStrLabel.text = orderItem.paidFeeStr;
    self.needPayStrLabel.text = orderItem.needPayStr;

}


- (IBAction)toDetailAction:(id)sender {
    
    if (self.toCellDetailBlock) {
        self.toCellDetailBlock(self.orderItem);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    //|| ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker && self.isDuoPei
    
    BOOL needPay = (self.orderItem.needPay > 0 && self.orderItem.payState == 0);
    BOOL needRole = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) || ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) || ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker);
    
    
    if (needPay && needRole) {
        
        if (!self.doudaoConfig && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
           
            return;
        }
    
        NSString *switchImageName = selected ? @"order_switchon_icon" : @"order_switchoff_icon";
       
        [self.stateButton setImage:[UIImage imageNamed:switchImageName] forState:0];
    }
 
}

@end


#pragma mark - YJYOrderDailyDetailsCell

@interface YJYOrderDailyDetailsCell()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation YJYOrderDailyDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
- (NSMutableArray<SettlementVO*> *)selectedOrderItemArray {

    NSMutableArray *arrM = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.tableView.indexPathsForSelectedRows.count; i++) {
        
        NSIndexPath *indexPath = self.tableView.indexPathsForSelectedRows[i];
        SettlementVO *orderItem = self.orderItemArray[indexPath.row];
        if (orderItem.confirmCost > 0) {
        }
        [arrM addObject:orderItem];

    }
    return arrM;
    
}
- (void)setOrderInfoRsp:(GetOrderInfoRsp *)orderInfoRsp {
    
    _orderInfoRsp = orderInfoRsp;
   
  
    //隐藏明细
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        if (orderInfoRsp.orderVo.orderType == 1 &&
            (orderInfoRsp.orderVo.status >=3 &&
             orderInfoRsp.orderVo.status <=6)) {

            self.isHiddenCheckButton = YES;
        }
    }
    //dev
    
    if ([BasePre isEqualToString:@"dev"]) {
        self.isHiddenCheckButton = NO;
    }
    

    
    
    self.orderItemArray = orderInfoRsp.orderItemArray;
    self.tableView.allowsMultipleSelection = YES;
    [self.tableView reloadAllData];

}

- (IBAction)toDetailAction:(id)sender {
    
    if (self.toDetailBlock) {
        self.toDetailBlock();
    }

}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderItemArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderDailyDetailsItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderDailyDetailsItemCell"];
    cell.doudaoConfig = self.orderInfoRsp.dudaoChargeConfig;
    cell.isDuoPei = self.orderInfoRsp.orderVo.serviceType == YJYWorkerServiceTypeMany ? YES : NO;
    
    
    SettlementVO *orderItem = self.orderItemArray[indexPath.row];
    cell.orderItem = orderItem;
    if (self.orderInfoRsp.orderVo.serviceType == YJYWorkerServiceTypeMany && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
//        角色——有收款权限的督导+有收款权限的多陪护工
//        订单状态——待结算
//        订单类型——机构订单
        
        cell.stateButton.hidden = YES;
    }
    
    if (self.orderInfoRsp.dudaoChargeConfig &&
        ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker || [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) &&
        self.orderInfoRsp.orderVo.orderType == 1 &&
        self.orderInfoRsp.orderVo.status == YJYOrderStateWaitPayOff) {
        cell.stateButton.hidden = YES;

    }
    
    cell.toCellDetailBlock = ^(SettlementVO *orderItem) {
        if (self.toCellDetailBlock) {
            self.toCellDetailBlock(orderItem);
        }
    };
    cell.checkDetailButton.hidden = self.isHiddenCheckButton;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettlementVO *orderItem = self.orderItemArray[indexPath.row];
    if (orderItem.payState == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if (orderItem.confirmCost <= 0) {
        
        if (self.toCellDetailBlock) {
            self.toCellDetailBlock(orderItem);
        }
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.allowsMultipleSelection &&
        [[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return nil;
    }
    return indexPath;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 242 - (self.isHiddenCheckButton ? 49 : 0);
}

- (CGFloat)cellHeight {
    
   
    CGFloat cellH = 242 - (self.isHiddenCheckButton ? 49 : 0);

    return (self.orderItemArray.count == 0) ? 0 : self.orderItemArray.count * cellH + [self headerHeight];
}

- (CGFloat)headerHeight {
 
//    CGFloat headerH = (self.orderInfoRsp.orderVo.insureType == 1 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) ? 220 : (220 - 100);
    
 
   
    return 0;
}

@end
