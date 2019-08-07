
//
//  YJYOrderDailyDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/1.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderDailyDetailController.h"
#import "YJYOrderAddServicesController.h"
#import "YJYOrderItemsExpandView.h"
#import "YJYOrderEndServiceController.h"

#pragma mark - Cell

typedef void(^OrderDailyDidExpandBlock)(BOOL isExpand);
typedef void(^OrderDailyDidConfirmBlock)();
typedef void(^OrderDailyDidAddServiceBlock)();

@interface YJYOrderDailyDetailCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

//service
@property (weak, nonatomic) IBOutlet UILabel *nurseLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistantNurseLabel;

//expand
@property (weak, nonatomic) IBOutlet UILabel *itemsTopTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *addItemsTopTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *addItemsTotalLabel;

@property (weak, nonatomic) IBOutlet UIButton *addModifyButton;
@property (weak, nonatomic) IBOutlet UIButton *itemExpandIcon;
@property (weak, nonatomic) IBOutlet UIView *itemHeaderView;
@property (weak, nonatomic) IBOutlet UIView *itemBottomView;

@property (weak, nonatomic) IBOutlet UIButton *addItemsExpandIcon;
@property (weak, nonatomic) IBOutlet UIView *addItemHeaderView;
@property (weak, nonatomic) IBOutlet UIView *addItemBottomView;

@property (weak, nonatomic) IBOutlet YJYOrderItemsExpandView *itemsExpandView;
@property (weak, nonatomic) IBOutlet YJYOrderItemsExpandView *addItemsExpandView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsExpandViewHConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addItemsExpandViewHConstraint;


//bottom

@property (weak, nonatomic) IBOutlet UIView *bottomView;


//data

#define kItemsExpand @"kItemsExpand"
#define kAddItemsExpand @"kAddItemsExpand"

@property (assign, nonatomic) BOOL isItemsExpand;
@property (assign, nonatomic) BOOL isAddItemsExpand;

@property (copy, nonatomic) OrderDailyDidExpandBlock didItemsExpandBlock;
@property (copy, nonatomic) OrderDailyDidExpandBlock didAddItemsExpandBlock;
@property (copy, nonatomic) OrderDailyDidConfirmBlock didConfirmBlock;
@property (copy, nonatomic) OrderDailyDidAddServiceBlock didAddServiceBlock;


@property (strong, nonatomic) OrderItemVO *orderItem;

@end

@implementation YJYOrderDailyDetailCell


- (void)setOrderItem:(OrderItemVO *)orderItem {

    _orderItem = orderItem;
    
    if (orderItem.affirmStatus == 1) {
        self.stateLabel.text = @"已确认";
    }else if (orderItem.affirmStatus == 2) {
        self.stateLabel.text = @"待确认";
    }else if (orderItem.affirmStatus == 3) {
        self.stateLabel.text = @"已支付";
    }else if (orderItem.affirmStatus == 0) {
        self.stateLabel.text = @"";
    }
    
    self.timeLabel.text = orderItem.serviceTime;
    self.serviceFeeLabel.text = [NSString stringWithFormat:@"%@元",orderItem.costStr] ;
    self.nurseLabel.text = orderItem.staffName;
    self.assistantNurseLabel.text = (orderItem.hgNameArray.count > 0) ? [orderItem.hgNameArray componentsJoinedByString:@","]  : @"无";
    
    self.itemsTotalLabel.text = [NSString stringWithFormat:@"服务项合计%@元",orderItem.basisCostStr.length > 0 ? orderItem.basisCostStr : @"0.00"];
    self.itemsTopTotalLabel.text = [NSString stringWithFormat:@"%@元",orderItem.basisCostStr.length > 0 ? orderItem.basisCostStr : @"0.00"];
    
    self.addItemsTotalLabel.text = [NSString stringWithFormat:@"附加服务合计%@元",orderItem.extraitemCost > 0 ? orderItem.extraitemCostStr : @"0.00"];
    self.addItemsTopTotalLabel.text =  [NSString stringWithFormat:@"%@元",orderItem.extraitemCost > 0 ? orderItem.extraitemCostStr : @"0.00"];
    
    /// 确认状态 1：查询所有确定 2：查询所有未确定的  3：所有的支付
//    affirmStatus
    
    BOOL isHideModifyButton =
    self.orderItem.affirmStatus == 3 ||
    ((self.orderItem.affirmStatus == 1 || self.orderItem.affirmStatus == 3) && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) ||
    !self.addItemsExpandView.isExpand;
    
    self.addModifyButton.hidden = isHideModifyButton;
    self.bottomView.hidden = self.orderItem.affirmStatus == 3 || self.orderItem.affirmStatus == 1;
    
    //basisVolistArray
    __weak typeof(self) weakSelf = self;
    self.itemsExpandView.basisVolistArray = orderItem.basisVolistArray;
    self.itemsExpandView.expandType = OrderItemsExpandTypeDailyItemList;
    self.itemsExpandView.didExpandBlock = ^{
        if (self.didItemsExpandBlock) {
            self.didItemsExpandBlock(weakSelf.itemsExpandView.isExpand);
        }
    };
    self.itemExpandIcon.hidden = (orderItem.basisVolistArray_Count == 0);
    self.itemHeaderView.frame = CGRectMake(0, 0, self.addItemsExpandView.frame.size.width, 46);
    self.itemBottomView.frame = CGRectMake(0, 0, self.addItemsExpandView.frame.size.width, 46);
    
    
    //extraVolistArray
    
    self.addItemsExpandView.extraVolistArray = orderItem.extraVolistArray;
    self.addItemsExpandView.expandType = OrderItemsExpandTypeDailyList;
    self.addItemsExpandView.didExpandBlock = ^{
        if (self.didAddItemsExpandBlock) {
            self.didAddItemsExpandBlock(weakSelf.addItemsExpandView.isExpand);
        }
    };
    self.addItemsExpandIcon.hidden = (orderItem.extraVolistArray_Count == 0);
    self.addItemHeaderView.frame = CGRectMake(0, 0, self.addItemsExpandView.frame.size.width, 46);
    self.addItemBottomView.frame = CGRectMake(0, 0, self.addItemsExpandView.frame.size.width, 46);

    
}





- (void)awakeFromNib {

    [super awakeFromNib];
    
    
}
#pragma mark - setting

- (void)setIsItemsExpand:(BOOL)isItemsExpand {
    
    _isItemsExpand = isItemsExpand;
    self.itemsExpandView.isExpand = isItemsExpand;
    self.itemsExpandViewHConstraint.constant = [self.itemsExpandView cellHeight];
    
    self.itemsTopTotalLabel.hidden = isItemsExpand;
    self.itemsTotalLabel.hidden = !isItemsExpand;
    
    [self.itemsExpandView.tableView reloadData];
}

- (void)setIsAddItemsExpand:(BOOL)isAddItemsExpand {
    
    _isAddItemsExpand = isAddItemsExpand;
    self.addItemsExpandView.isExpand = isAddItemsExpand;
    self.addItemsExpandViewHConstraint.constant = [self.addItemsExpandView cellHeight];
    
    self.addItemsTopTotalLabel.hidden = isAddItemsExpand;
    self.addItemsTotalLabel.hidden = !isAddItemsExpand;
    
    [self.addItemsExpandView.tableView reloadData];
}
- (void)setIndex:(NSInteger)index {
    
    _index = index;
    
    UIColor *color = kOrderDailyColors[index];
    self.timeView.backgroundColor = color;
    [self.confirmButton setTitleColor:color forState:0];
    [self.addModifyButton setTitleColor:color forState:0];

    
    NSString *colorName = kOrderDailyColorNameList[index];
    
    NSString *itemExpandImgName = [NSString stringWithFormat:@"order_%@_%@_icon",colorName, self.isItemsExpand ? @"up" : @"down"];
    [self.itemExpandIcon setImage:[UIImage imageNamed:itemExpandImgName] forState:0];
    
    
    NSString *addItemExpandImgName = [NSString stringWithFormat:@"order_%@_%@_icon",colorName, self.isAddItemsExpand ? @"up" : @"down"];
    [self.addItemsExpandIcon setImage:[
                                       UIImage imageNamed:addItemExpandImgName] forState:0];
    
}



#pragma mark - Action 


- (IBAction)addModifyServiceAction:(id)sender {
    
    if (self.didAddServiceBlock) {
        self.didAddServiceBlock();
    }
}

- (IBAction)confirmServiceAction:(UIButton *)sender {
    
    if (self.didConfirmBlock && self.orderItem.affirmStatus == 2) {
        self.didConfirmBlock();

    }
}

@end


@interface YJYOrderDailyDetailController()

@property (strong, nonatomic) NSMutableArray *expandDictM;
@property (assign, nonatomic) uint32_t pageNum;
@property(nonatomic ,strong) ListOrderItemRsp *rsp;
@property (strong, nonatomic) NSMutableArray<OrderItemVO*> *voListArray;

@end

@implementation YJYOrderDailyDetailController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderDailyDetailController *)[UIStoryboard storyboardWithName:@"YJYOrderDaily" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.voListArray = [NSMutableArray array];
    self.expandDictM = [NSMutableArray array];
    
   
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkDataAgain];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    [SYProgressHUD show];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkDataAgain];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void)loadNetworkData {
    
    SettlementReq *req = [SettlementReq new];
    req.pageNum = self.pageNum;
    req.pageSize = 31;
    req.settDate = self.settDate;
    req.orderId = self.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPListOrderItem message:req controller:nil command:APP_COMMAND_SaasapplistOrderItem success:^(id response) {
        
        
        self.rsp = [ListOrderItemRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.rsp.voListArray_Count > 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.voListArray addObjectsFromArray:self.rsp.voListArray];
                
            }
            
        }else {
            self.voListArray = self.rsp.voListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        for (NSInteger i = 0; i < self.rsp.voListArray.count; i++) {

            NSDictionary *expandDict = @{kItemsExpand : @(YES),kAddItemsExpand : @(YES)};
            [self.expandDictM addObject:expandDict];

        }
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)loadNetworkDataAgain {

    self.pageNum = 1;
    [self loadNetworkData];
}

#pragma mark - UITabelView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.voListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    __weak YJYOrderDailyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderDailyDetailCell"];
    
    
    OrderItemVO *orderItem = self.voListArray[indexPath.row];
    cell.orderItem = orderItem;
    
    BOOL itemsExpand = [self.expandDictM[indexPath.row][kItemsExpand] boolValue];
    cell.isItemsExpand = itemsExpand;
    
    BOOL addItemsExpand = [self.expandDictM[indexPath.row][kAddItemsExpand] boolValue];
    cell.isAddItemsExpand = addItemsExpand;
    
    cell.index = indexPath.row <= 5 ? indexPath.row : indexPath.row%5;

    
    cell.didItemsExpandBlock = ^(BOOL isExpand) {
        
        [self.tableView beginUpdates];
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.expandDictM[indexPath.row]];
        dictM[kItemsExpand] = @(isExpand);
        [self.expandDictM replaceObjectAtIndex:indexPath.row withObject:dictM];
        
        [self.tableView reloadData];
        [self.tableView endUpdates];
    };
    
    cell.didAddItemsExpandBlock = ^(BOOL isExpand) {
        
        [self.tableView beginUpdates];
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.expandDictM[indexPath.row]];
        dictM[kAddItemsExpand] = @(isExpand);
        [self.expandDictM replaceObjectAtIndex:indexPath.row withObject:dictM];
        
        [self.tableView reloadData];
        [self.tableView endUpdates];
    };
    
    cell.didAddServiceBlock = ^{
        
        
        YJYOrderAddServicesController *vc = [YJYOrderAddServicesController instanceWithStoryBoard];
        vc.title = @"添加/修改附加项";
        vc.orderId = self.orderId;
        vc.affirmTime = orderItem.serviceTime;
        vc.isInsure = NO;
        vc.didEditServicesBlock = ^{
        
            [SYProgressHUD show];

        };
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    cell.didConfirmBlock = ^{
    
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
            
            [self toConfirmOrderWithOrderId:self.orderId orderItem:orderItem];
            
        }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager|| [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
            
            [self toEndOrderWithOrderId:self.orderId orderItem:orderItem];
        }
        
    
    };
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat dailyInfoH = 270;
    CGFloat commonItemHeader = 46;
    CGFloat commonItemBottom = 46;
    CGFloat bottomHeight = 50;
    
    BOOL itemsExpand = [self.expandDictM[indexPath.row][kItemsExpand] boolValue];
    BOOL addItemsExpand = [self.expandDictM[indexPath.row][kAddItemsExpand] boolValue];

    
    OrderItemVO *orderItem = self.voListArray[indexPath.row];
    
    CGFloat itemHeader = commonItemHeader;
    CGFloat addItemHeader = commonItemHeader;
    
    CGFloat otherH = dailyInfoH - ((orderItem.affirmStatus == 3 || orderItem.affirmStatus == 1) ? bottomHeight : 0);
    
    //item
    CGFloat itemH = 0.0;
    for (NSInteger i = 0; i < orderItem.basisVolistArray.count; i++) {
        
        ExtraItemVO *extraItem = orderItem.basisVolistArray[i];
        CGFloat height = [NSString heightWithText:extraItem.service font:[UIFont systemFontOfSize:12] width:80];
        itemH += (height + (44-12));
    }
    
    //add height
    CGFloat addItemsH = 0.0;
    
    for (NSInteger i = 0; i < orderItem.extraVolistArray.count; i++) {
        
        ExtraItemVO *extraItem = orderItem.extraVolistArray[i];
        CGFloat height = [NSString heightWithText:extraItem.service font:[UIFont systemFontOfSize:12] width:80];
        addItemsH += (height + (44-12));
    }
    
    
     
    return otherH +
    (itemsExpand ? (itemH + itemHeader + commonItemBottom) : itemHeader) +
    (addItemsExpand ? (addItemsH + addItemHeader + commonItemBottom) : addItemHeader);

}

#pragma mark - 

- (void)toConfirmOrderWithOrderId:(NSString *)orderId
                        orderItem:(OrderItemVO *)orderItem{
    
    [UIAlertController showAlertInViewController:[UIWindow currentViewController] withTitle:@"请确定已完成今天所有服务项？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            
            SaveOrderItemReq *req = [SaveOrderItemReq new];
            req.orderId  = orderId;
            req.affirmTime = orderItem.serviceTime;
            req.mold = 1;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPConfirmOrderItem message:req controller:nil command:APP_COMMAND_SaasappconfirmOrderItem success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"成功完成"];
                [self loadNetworkDataAgain];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
}


- (void)toEndOrderWithOrderId:(NSString *)orderId
                    orderItem:(OrderItemVO *)orderItem {
    
    YJYOrderEndServiceController *vc = [YJYOrderEndServiceController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.affirmTime = orderItem.serviceTime;
    vc.hgName = orderItem.staffName;
    vc.didDoneBlock = ^{
        
        [SYProgressHUD show];
        [self loadNetworkData];

    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
