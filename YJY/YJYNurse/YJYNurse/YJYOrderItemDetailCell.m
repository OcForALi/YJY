//
//  YJYOrderItemDetailCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderItemDetailCell.h"
#import "YJYOrderItemsExpandView.h"

#pragma mark - YJYOrderServerHistoryCell


@interface YJYOrderServerHistoryCell : UITableViewCell

//header
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicerLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

//ExpandView
@property (weak, nonatomic) IBOutlet YJYOrderItemsExpandView *orderItemsExpandView;


//bottom
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHConstraint;




//data
@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) OrderItemVO *orderItem;
@property (copy, nonatomic) YJYOrderItemDetailCellDidDetailBlock didExpandBlock;
@property (copy, nonatomic) YJYOrderItemDetailCellDidChangeBlock didChangeBlock;

@property (copy, nonatomic) YJYOrderItemDetailCellDidDoneAndCloseBlock didDoneAndCloseBlock;
@property (copy, nonatomic) YJYOrderItemDetailCellDidAddAndModifyBlock didAddAndModifyBlock;


@end

@implementation YJYOrderServerHistoryCell

- (void)setOrderItem:(OrderItemVO *)orderItem {
    
    _orderItem = orderItem;
    self.timeLabel.text = orderItem.serviceTime;
    self.costLabel.text = [NSString stringWithFormat:@"%@元",orderItem.costStr];
    self.servicerLabel.text = orderItem.staffName.length > 0 ? orderItem.staffName : @"待指派";
    

    BOOL cancelState = (orderItem.status == -1 || orderItem.affirmStatus == 0);
    BOOL doneState = (orderItem.status == 1);
    BOOL noDoneState = (orderItem.status == 0);
    
    self.bottomViewHConstraint.constant = noDoneState ? 53 : 0;

    self.switchButton.selected = doneState;
    
    self.switchButton.hidden = cancelState;
    self.switchLabel.hidden = self.switchButton.hidden;
    
    self.switchLabel.text = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? (noDoneState ? @"关闭订单" : @"已关闭" )  : (noDoneState ? @"确认订单" : @"已确认" );
    self.modifyButton.hidden = !([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader && noDoneState);

    
    /// 当日服务项状态 0-不可确认 1-已确认 2-待确认 3-已支付
//    self.stateButton.hidden = orderItem.affirmStatus != 0;

    //state
    NSString *state;
    UIColor *color;
    if (orderItem.status == 0) {
        state = @"不可确认";
        color = APPREDCOLOR;
        
    }else if (orderItem.status == 2) {
        state = @"待确认";
        color = APPHEXCOLOR;

    }else if (orderItem.status == 1) {
        state = @"已确认";
        color = APPYELLOWCOLOR;
        
    }else if (orderItem.status == 3) {
        state = @"已支付";
        color = APPYELLOWCOLOR;

    }
    self.stateButton.hidden = noDoneState;
    [self.stateButton setTitle:state forState:0];
    self.stateButton.backgroundColor = color;
    
    //展开项目
    
    __weak typeof(self) weakSelf = self;
    self.orderItemsExpandView.extraVolistArray = orderItem.extraVolistArray;
    self.orderItemsExpandView.expandType = OrderItemsExpandTypeExtraVolist;
    self.orderItemsExpandView.didExpandBlock = ^{
        
        if (weakSelf.didExpandBlock) {
            weakSelf.didExpandBlock(!self.isExpand);
        }
    };

}



- (IBAction)switchServerPeople:(id)sender {
    if (self.didChangeBlock) {
        self.didChangeBlock(self.orderItem);
    }
}
- (IBAction)doneAndCloseAction:(UIButton *)sender {
    
    if (self.didDoneAndCloseBlock) {
        self.didDoneAndCloseBlock(self.orderItem);
    }
    
}
- (IBAction)addAndModifyAction:(id)sender {

    if (self.didAddAndModifyBlock) {
        self.didAddAndModifyBlock(self.orderItem);
    }
    
}

- (void)setIsExpand:(BOOL)isExpand {
    
    _isExpand = isExpand;
    self.orderItemsExpandView.isExpand = isExpand;
    [self.orderItemsExpandView.tableView reloadData];
}




@end

#pragma mark - YJYOrderItemDetailCell

@interface YJYOrderItemDetailCell ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *expandDictM;

@end

@implementation YJYOrderItemDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.expandDictM = [NSMutableArray array];
    self.orderItemArray = [NSMutableArray array];
}

- (void)setOrderItemArray:(NSMutableArray<OrderItemVO *> *)orderItemArray {

    _orderItemArray = orderItemArray;
    
    for (NSInteger i = 0; i < orderItemArray.count; i++) {
        
        NSDictionary *expandDict = @{@"expand" : @(YES)};
        [self.expandDictM addObject:expandDict];
        
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderItemArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderServerHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderServerHistoryCell" forIndexPath:indexPath];
    
    OrderItemVO *orderItem = self.orderItemArray[indexPath.row];
    cell.orderItem = orderItem;
    [cell.modifyButton setTitle:orderItem.staffName.length > 0 ?  @"更改" :@"指派" forState:0];

    cell.isExpand = [self.expandDictM[indexPath.row][@"expand"] boolValue];
    
    cell.didExpandBlock = ^(BOOL isExpand) {
        
        
        [self.tableView beginUpdates];
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.expandDictM[indexPath.row]];
        dictM[@"expand"] = @(isExpand);
        [self.expandDictM replaceObjectAtIndex:indexPath.row withObject:dictM];
        
        if (self.didExpandBlock) {
            self.didExpandBlock(!isExpand);
        }
        [self.tableView reloadData];
        [self.tableView endUpdates];
        
    };
    
    cell.didChangeBlock = ^(OrderItemVO *orderItem) {
    
        if (self.didChangeBlock) {
            self.didChangeBlock(orderItem);
        }
    };
    
    cell.didAddAndModifyBlock = ^(OrderItemVO *orderItem) {
        
        if (self.didAddAndModifyBlock) {
            self.didAddAndModifyBlock(orderItem);
        }
    };
    
    cell.didDoneAndCloseBlock = ^(OrderItemVO *orderItem) {
        
        if (orderItem.status == 0) {
            [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ? [self toCloseWithOrderItem:orderItem] : [self toComfireWithOrderItem:orderItem];

        }
       
    };
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    BOOL isExpand = [self.expandDictM[indexPath.row][@"expand"] boolValue];

    OrderItemVO *orderItem = self.orderItemArray[indexPath.row];
    
    CGFloat cellH  = [self historyCellHeightWithExpand:isExpand orderItem:orderItem indexPath:indexPath];
    return cellH;

}

- (CGFloat)cellHeight {

    
    CGFloat tabelH = 70;
    
    for (NSInteger i = 0; i < self.orderItemArray.count ; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        BOOL isExpand = [self.expandDictM[indexPath.row][@"expand"] boolValue];
        OrderItemVO *orderItem = self.orderItemArray[indexPath.row];
     
        tabelH +=[self historyCellHeightWithExpand:isExpand orderItem:orderItem indexPath:indexPath];

    }
   
    
    return tabelH;
    
}


#define kOrderHistoryCellHeight 300  - (120-46) 
- (CGFloat)historyCellHeightWithExpand:(BOOL)isExpand
                             orderItem:(OrderItemVO *)orderItem
                             indexPath:(NSIndexPath *)indexPath{
    
    
    
    
    CGFloat bottomHeight = orderItem.status != 0 ? 53 : 0;
    //1
    
    CGFloat hAndFHeight = kOrderHistoryCellHeight;
    
    CGFloat totalHeight = 0.0;
    
    for (NSInteger i = 0; i < orderItem.extraVolistArray.count; i ++) {
        CGFloat height = [NSString heightWithText:orderItem.extraVolistArray[i].service font:[UIFont systemFontOfSize:12] width:80];
        CGFloat cellItemHeight = height + (44-12);
        
        totalHeight += cellItemHeight;
    }
 
    
    
    CGFloat cellH = hAndFHeight + (isExpand ? totalHeight : 0) - bottomHeight;
    
    return cellH;
}


#pragma mark - helper

- (void)toCloseWithOrderItem:(OrderItemVO *)orderItem {

    [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"是否确定关闭该医疗子订单？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            CancelOrderReq *req = [CancelOrderReq new];
            req.orderId  = self.orderInfoRsp.orderVo.orderId;//[NSString stringWithFormat:@"%@",@(orderItem.id_p)];
            req.serviceDate = orderItem.serviceTime;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPCancelOrderItem message:req controller:nil command:APP_COMMAND_SaasappcancelOrderItem success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"关闭成功"];
                
                if (self.didDoneAndCloseBlock) {
                    self.didDoneAndCloseBlock(orderItem);
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
    
}

- (void)toComfireWithOrderItem:(OrderItemVO *)orderItem {

    
    [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"是否确定完成该医疗子订单？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            SaveOrderItemReq *req = [SaveOrderItemReq new];
            req.orderId  = self.orderInfoRsp.orderVo.orderId;
            req.affirmTime = orderItem.serviceTime;
            req.mold = 1;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderItem message:req controller:nil command:APP_COMMAND_SaasappconfirmOrderItem success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"成功完成"];
                
                if (self.didDoneAndCloseBlock) {
                    self.didDoneAndCloseBlock(orderItem);
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];

    
   
}

@end
