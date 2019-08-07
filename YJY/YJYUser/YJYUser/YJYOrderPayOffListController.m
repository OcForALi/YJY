//
//  YJYOrderPayOffListController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPayOffListController.h"
#import "YJYOrderPayoffController.h"
#import "YJYOrderPayOffDailyController.h"


typedef void(^OrderPayOffCellDidDetailAction)();

@interface YJYOrderPayOffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (strong, nonatomic) SettlementVO *settlement;
@property (assign, nonatomic) BOOL isSelect;
@property (copy, nonatomic) OrderPayOffCellDidDetailAction didDetailAction;


@end

@implementation YJYOrderPayOffCell

- (void)setSettlement:(SettlementVO *)settlement {

    _settlement = settlement;
    
    self.serviceTimeLabel.text = [NSString stringWithFormat:@"服务时间: %@",settlement.serviceTime];
    self.feeLabel.text = [NSString stringWithFormat:@"待缴费用：%@元",@(settlement.needPay)];
    
    if (settlement.payState == 1) {
        
        self.serviceTimeLabel.textColor = APPGrayCOLOR;
        self.feeLabel.textColor = APPGrayCOLOR;
        [self.checkButton setImage:[UIImage imageNamed:@"order_checkbox_unselect_icon"] forState:0];
    }else {
    
        self.serviceTimeLabel.textColor = APPMiddleGrayCOLOR;
        self.feeLabel.textColor = APPMiddleGrayCOLOR;
    }
    
}

- (void)setIsSelect:(BOOL)isSelect {

    _isSelect = isSelect;
    if (isSelect) {
        
        [self.checkButton setImage:[UIImage imageNamed:@"order_checkbox_select_icon"] forState:0];
        
    }else {
        
        [self.checkButton setImage:[UIImage imageNamed:@"order_checkbox_unselect_icon"] forState:0];
        
    }
}

- (IBAction)detailAction:(id)sender {
    
    if (self.didDetailAction) {
        self.didDetailAction();
    }
}


@end

@interface YJYOrderPayOffListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *prePayLabel;
@property (weak, nonatomic) IBOutlet YJYTableView *tableView;
@property (strong, nonatomic) NSMutableArray<SettlementVO*> *voListArray;
@property (strong, nonatomic) NSMutableArray *selecteds;
@property (weak, nonatomic) IBOutlet UIButton *payAction;

@end

@implementation YJYOrderPayOffListController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPayOffListController *)[UIStoryboard storyboardWithName:@"YJYOrderPayoff" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voListArray = [NSMutableArray array];
    self.selecteds = [NSMutableArray array];
    [self loadNetworkData];
}

- (void)loadNetworkData {

    [SYProgressHUD show];
    
    
    GetOrderReq *req = [GetOrderReq new];
    req.orderId = self.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:APPListSettlement message:req controller:self command:APP_COMMAND_ApplistSettlement success:^(id response) {
        
        ListSettlementRsp *rsp = [ListSettlementRsp parseFromData:response error:nil];
        self.voListArray = rsp.voListArray;
        
        self.selecteds = [NSMutableArray array];
        for (NSInteger i = 0; i < self.voListArray.count; i++) {
            [self.selecteds addObject:@(NO)];
        }
        self.totalLabel.text = [NSString stringWithFormat:@"消费总额 %@ 元",rsp.confirmCost];
        self.prePayLabel.text = [NSString stringWithFormat:@"预付款 %@ 元",rsp.prePayAmount];
        
        [self.tableView reloadAllData];

    } failure:^(NSError *error) {
        [self.tableView reloadErrorData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.voListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderPayOffCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderPayOffCell"];
    SettlementVO *settlement = self.voListArray[indexPath.row];
    cell.settlement = settlement;
    cell.isSelect = [self.selecteds[indexPath.row] boolValue];
    cell.didDetailAction = ^{
        
        YJYOrderPayOffDailyController *vc = [YJYOrderPayOffDailyController instanceWithStoryBoard];
        vc.order = self.order;
        vc.settDate = settlement.settleDate;

        [self.navigationController pushViewController:vc animated:YES];
        
    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    SettlementVO *settlement = self.voListArray[indexPath.row];
    if (settlement.payState == 1) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }else {
        
        [self.tableView beginUpdates];
        BOOL selected = [self.selecteds[indexPath.row] boolValue];
        [self.selecteds replaceObjectAtIndex:indexPath.row withObject:@(!selected)];
        [self.tableView reloadData];
        [self.tableView endUpdates];
        
        //下就向上多选
    }

    [self chekcSelectAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 77;
}


- (void)chekcSelectAction {

    self.payAction.enabled = NO;
    
    for (NSInteger i = 0; i < self.selecteds.count; i++) {
        
        BOOL selected = [self.selecteds[i] boolValue];
        if (selected) {
            self.payAction.enabled = YES;
            break;

        }

    }
    
}


- (IBAction)payAction:(id)sender {
    
    NSMutableArray *settDateArray = [NSMutableArray array];
    
 
    for (NSInteger i = 0; i < self.selecteds.count; i++) {
        
        if ([self.selecteds[i] boolValue]) {
            SettlementVO *aSettlement = self.voListArray[i];
            [settDateArray addObject:aSettlement.settleDate];
        }
     
    }
    
    
    
    YJYOrderPayoffController *vc = [YJYOrderPayoffController instanceWithStoryBoard];
    vc.order = self.order;
    vc.settDateArray = settDateArray;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
