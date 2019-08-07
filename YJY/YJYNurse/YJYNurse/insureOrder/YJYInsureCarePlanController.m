//
//  YJYInsureCarePlanController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/2.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureCarePlanController.h"
#import "YJYInsureCarePlanDetailController.h"

typedef void(^YJYInsureCarePlanCellDidSelectBlock)();
typedef void(^YJYInsureCarePlanCellDidDeleteBlock)();

@interface YJYInsureCarePlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *beServerLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;

@property (copy, nonatomic) YJYInsureCarePlanCellDidSelectBlock didSelectBlock;
@property (copy, nonatomic) YJYInsureCarePlanCellDidDeleteBlock didDeleteBlock;

@property (strong, nonatomic) OrderTendVO *orderTendVO;
@property (weak, nonatomic) IBOutlet UIButton *delButton;

@end

@implementation YJYInsureCarePlanCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.stateLabel.layer.cornerRadius = 10;
    self.stateLabel.layer.borderColor = APPGrayCOLOR.CGColor;
    self.stateLabel.layer.borderWidth = 1;
}

- (IBAction)toDetail:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}
- (IBAction)toDel:(id)sender {
    
    if (self.didDeleteBlock) {
        self.didDeleteBlock();
    }
}

- (void)setOrderTendVO:(OrderTendVO *)orderTendVO {
    
    _orderTendVO = orderTendVO;
    self.beServerLabel.text = orderTendVO.name;
    self.stateLabel.text = orderTendVO.statusStr;
    self.createLabel.text = [NSString stringWithFormat:@"生效时间:%@",orderTendVO.startTimeStr];
    
    self.delButton.hidden = orderTendVO.status != 0;
    
    /// 状态  0-草稿 1-待审核 2-执行中 3-已完成 4-审核不通过

    UIColor *stateColor;
    uint32_t status = orderTendVO.status;
    
    
    if (status == 4) {
        
        stateColor = APPREDCOLOR;
        
    }else if (status == 2){
        
        stateColor = APPHEXCOLOR;
        
    }else if (status == 3){
        
        stateColor = APPGrayCOLOR;
        
    }else if (status == 0 ||
              status == 1 ){
        
        stateColor = APPORANGECOLOR;
        
    }
    self.stateLabel.textColor = stateColor;
    self.stateLabel.layer.borderColor = stateColor.CGColor;
}

@end

@interface YJYInsureCarePlanContentController :YJYTableViewController

@property (strong, nonatomic) GetOrderTendListRsp *rsp;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (assign, nonatomic) BOOL isHistoryEnter;
@property (assign, nonatomic) BOOL isActionHidden;
@end

@implementation YJYInsureCarePlanContentController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkData];

}

- (void)loadNetworkData {
    
    /// 类型 0-护士的计划列表 1-护士长的计划列表 2-用户的计划列表 3-护士长的待审核列表
    
    GetOrderTendListReq *req = [GetOrderTendListReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        req.type = 0;
    }
//    else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
//        req.type = 1;
//    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
//        req.type = 2;
//    }
    
    //历史
    if (self.isHistoryEnter) {
        req.type = 2;
    }
    
    if (!self.orderDetailRsp) {
        //护士长的待审核列表
        req.type = 3;

    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderTendList message:req controller:self command:APP_COMMAND_SaasappgetOrderTendList success:^(id response) {
        
        self.rsp = [GetOrderTendListRsp parseFromData:response error:nil];
        
        [self reloadAllData];

    } failure:^(NSError *error) {
        
        [self reloadErrorData];

    }];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.voListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureCarePlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureCarePlanCell" forIndexPath:indexPath];
    OrderTendVO *orderTendVO = self.rsp.voListArray[indexPath.row];

    cell.didDeleteBlock = ^{
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否删除" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self delOrderTend:orderTendVO];

            }
            
        }];
    };
    
    cell.orderTendVO = orderTendVO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderTendVO *orderTendVO = self.rsp.voListArray[indexPath.row];
    
    YJYInsureCarePlanDetailController *vc = [YJYInsureCarePlanDetailController instanceWithStoryBoard];
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.orderTendId = orderTendVO.tendId;
    vc.orderTendVO = orderTendVO;
    if (orderTendVO.status == 0) {
        vc.detailType = YJYInsureCarePlanDetailTypeEdit;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 135;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return self.isActionHidden ? 0 : 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = APPSaasF8Color;
    return footer;
}
#pragma mark - Action

- (void)delOrderTend:(OrderTendVO *)orderTendVO {
    
    DelOrderTendReq *req = [DelOrderTendReq new];
    req.orderTendId = orderTendVO.tendId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPDelOrderTend message:req controller:self command:APP_COMMAND_SaasappdelOrderTend success:^(id response) {
        
        [self loadNetworkData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
@end

@interface YJYInsureCarePlanController ()

@property (strong, nonatomic) YJYInsureCarePlanContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@end


@implementation YJYInsureCarePlanController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureCarePlan" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //新增按钮
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        self.buttonView.hidden = self.isHistoryEnter;
    }else {
        
        self.buttonView.hidden = YES;
    }
    self.contentVC.isActionHidden = self.buttonView.hidden;
    [self.contentVC.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureCarePlanContentController"]) {
        
        self.contentVC = (YJYInsureCarePlanContentController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        self.contentVC.isHistoryEnter  = self.isHistoryEnter;
    }
    
}
- (IBAction)done:(id)sender {
    
    YJYInsureCarePlanDetailController *vc = [YJYInsureCarePlanDetailController instanceWithStoryBoard];
    
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.detailType = YJYInsureCarePlanDetailTypeAdd;
    vc.didDoneBlock = ^(uint64_t new_orderTendId) {
        [self.contentVC loadNetworkData];

    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
