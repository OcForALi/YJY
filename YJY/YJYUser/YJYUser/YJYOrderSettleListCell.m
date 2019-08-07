//
//  YJYOrderSettleListCell.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderSettleListCell.h"

#pragma mark - YJYOrderSettleCell

typedef void(^OrderSettleCellDidDetailAction)();


@interface YJYOrderSettleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView  *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitPaidLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *paidIcon;

@property (strong, nonatomic) SettlementVO *settle;
@property(nonatomic, readwrite) uint32_t status;
@property (assign, nonatomic) BOOL isSelect;
@property (assign, nonatomic) NSInteger payType;


@property (copy, nonatomic) OrderSettleCellDidDetailAction didDetailAction;

@end

@implementation YJYOrderSettleCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius  = 8;
    self.payType = 4;
    
}



- (void)setSettle:(SettlementVO *)settle {
    
    _settle = settle;
    self.timeLabel.text = settle.serviceTime;
    self.payLabel.text = settle.confirmCostStr;
    self.paidLabel.text = settle.paidFeeStr;
    self.waitPaidLabel.text = settle.needPayStr;
    
    
    if (self.status == 3 || self.status == OrderStatus_WaitAppraise) {
        if (self.settle.payState == 0) {
            
            self.selectButton.hidden = NO;
            self.paidIcon.hidden = YES;
            
            
        }else {
            self.selectButton.hidden = YES;
            self.paidIcon.hidden = NO;
            
        }
    }else if (self.status == OrderStatus_ServiceComplete) {
        
        self.selectButton.hidden = YES;
        self.paidIcon.hidden = YES;
    }
    
    self.selectButton.hidden = YES;

}

- (void)setIsSelect:(BOOL)isSelect {
    
    _isSelect = isSelect;
    if (isSelect) {
        
        [self.selectButton setImage:[UIImage imageNamed:@"order_checkbox_select_icon"] forState:0];
        
    }else {
        
        [self.selectButton setImage:[UIImage imageNamed:@"order_checkbox_unselect_icon"] forState:0];
        
    }
}

- (IBAction)detailAction:(id)sender {
    
    if (self.didDetailAction) {
        self.didDetailAction();
    }
}

@end

@interface YJYOrderSettleListCell()

@property (strong, nonatomic) NSMutableArray *selecteds;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation YJYOrderSettleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.currentIndex = 0;
    self.voListArray = [NSMutableArray array];
    self.selecteds = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVoListArray:(NSMutableArray<SettlementVO *> *)voListArray {
    _voListArray = voListArray;
    
    for (NSInteger i = 0; i < voListArray.count; i++) {
        
        [self.selecteds addObject:@(NO)];
    }
    
    
}

- (NSArray *)settDateArray {

    NSMutableArray *settDateArray = [NSMutableArray array];

    //服务中
    if (self.selecteds.count == 0) {
        [SYProgressHUD showFailureText:@"请选择服务"];
        return nil;
    }
    
  
    for (NSInteger i = 0; i < self.selecteds.count; i++) {
        
        if ([self.selecteds[i] boolValue]) {
            SettlementVO *aSettlement = self.voListArray[i];
            [settDateArray addObject:aSettlement.settleDate];
        }
        
    }
    
    return settDateArray;
}
- (CGFloat)cellHeight {
    
    return self.voListArray.count * 146;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.voListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderSettleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderSettleCell"];
    SettlementVO *settlement = self.voListArray[indexPath.row];
    cell.status = self.order.status;
    cell.settle = settlement;
    
    cell.isSelect = [self.selecteds[indexPath.row] boolValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.didDetailAction = ^{
        
        if (self.didDetailAction) {
            self.didDetailAction(settlement);
        }
        
    };
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 146;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //0.结算状态不能点
    if (self.order.status == 4) {
        return;
    }
    //1.
    if (self.currentIndex > 0 && indexPath.row < self.currentIndex) {
        return;
    }
    
    //2.
    SettlementVO *settlement = self.voListArray[indexPath.row];
    if (settlement.payState == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
        
    }
    
    //3.
    [self.tableView beginUpdates];
    self.currentIndex  = indexPath.row;
    BOOL currentSelect = [self.selecteds[self.currentIndex] boolValue];
    if (!currentSelect) {
        
        for (NSInteger i = 0; i <= self.currentIndex; i++) {
            [self.selecteds replaceObjectAtIndex:i withObject:@(YES)];
        }
    }else {
        [self.selecteds replaceObjectAtIndex:self.currentIndex withObject:@(NO)];
        self.currentIndex--;
        if (self.currentIndex < 0) {
            self.currentIndex = 0;
        }
        
    }
    
    
    [self.tableView reloadData];
    [self.tableView endUpdates];
    
    //下就向上多选
    
    
}


@end
