//
//  YJYOrderPayOffDailyController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderPayOffDailyController.h"

#define kSeriveItemCellH 44

#pragma mark - YJYSeriveItemCell
@interface YJYSeriveItemCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *service;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (strong, nonatomic) ExtraItemVO *extraItem;


@end

@implementation YJYSeriveItemCell

- (void)setExtraItem:(ExtraItemVO *)extraItem {
    
    _extraItem = extraItem;
    
    self.service.text = extraItem.service;
    self.numberLabel.text =  [NSString stringWithFormat:@"%@ 次",@( extraItem.serviceTimes)];
    self.feeLabel.text = extraItem.priceDesc;
}

@end

#pragma mark - YJYOrderPayOffDailyCell

typedef void(^OrderPayOffDailyCellDidDetailAction)();

@interface YJYOrderPayOffDailyCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payIDImageView;

@property (copy, nonatomic) OrderPayOffDailyCellDidDetailAction didDetailAction;

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *addServiceLabel;


@property (strong, nonatomic) OrderItemVO *order;
//data

@property (strong, nonatomic) NSMutableArray<ExtraItemVO*> *extraVolistArray;
@property (weak, nonatomic) IBOutlet YJYTableView *tableView;


@end

@implementation YJYOrderPayOffDailyCell

- (void)setOrder:(OrderItemVO *)order {
    
    _order = order;
    self.timeLabel.text = order.serviceTime;
    self.locationLabel.text = order.location;
    self.packageLabel.text = order.service;
    self.feeLabel.text = [NSString stringWithFormat:@"%@ 元/天",@(order.cost/100)];
    self.memberLabel.text = order.staffName;
    
    //extra
    if (!self.extraVolistArray) {
        self.extraVolistArray = [NSMutableArray array];
    }
    self.extraVolistArray = order.extraVolistArray;
    self.payIDImageView.hidden = order.payState != 1;
    self.addServiceLabel.hidden = self.arrowButton.hidden = order.extraVolistArray_Count == 0;
    
    
    [self.tableView reloadData];
}

- (IBAction)detailAction:(UIButton *)sender {
    
    if (self.extraVolistArray.count == 0) {
        return;
    }
    self.arrowButton.selected = !self.arrowButton.selected;
    
    if (self.didDetailAction) {
        self.didDetailAction();
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.extraVolistArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYSeriveItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYSeriveItemCell"];
    cell.extraItem = self.extraVolistArray[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return kSeriveItemCellH;
}



@end

@interface YJYOrderPayOffDailyController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<OrderItemVO*> *voListArray;
@property (strong, nonatomic) NSMutableArray *expands;
@property (weak, nonatomic) IBOutlet YJYTableView *tableView;;
@end

@implementation YJYOrderPayOffDailyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPayOffDailyController *)[UIStoryboard storyboardWithName:@"YJYOrderPayoff" viewControllerIdentifier:NSStringFromClass(self)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voListArray = [NSMutableArray array];
    self.expands = [NSMutableArray array];
    
    self.voListArray = [NSMutableArray array];
    [self loadNetworkData];
    
    self.title = @"每日明细";
}

- (void)loadNetworkData {
    
    [SYProgressHUD show];
    
    SettlementReq *req = [SettlementReq new];
    req.orderId = self.order.orderId;
    req.settDate = self.settDate;
    
    [YJYNetworkManager requestWithUrlString:APPListOrderItem message:req controller:self command:APP_COMMAND_ApplistOrderItem success:^(id response) {
        
        ListOrderItemRsp *rsp = [ListOrderItemRsp parseFromData:response error:nil];
        self.voListArray = rsp.voListArray;
        
        self.expands = [NSMutableArray array];
        for (NSInteger i = 0; i < self.voListArray.count; i++) {
            [self.expands addObject:@(NO)];
        }
        
        //reload
        
        [self.tableView reloadAllData];
        
    } failure:^(NSError *error) {
        [self.tableView reloadErrorData];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.voListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderPayOffDailyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderPayOffDailyCell"];
    cell.order = self.voListArray[indexPath.row];
    cell.didDetailAction = ^{
        
        [self.tableView beginUpdates];
        BOOL expand = [self.expands[indexPath.row] boolValue];
        [self.expands replaceObjectAtIndex:indexPath.row withObject:@(!expand)];
        [self.tableView reloadData];
        [self.tableView endUpdates];
    };
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isExpand = [self.expands[indexPath.row] boolValue];
    OrderItemVO *orderItem = self.voListArray[indexPath.row];
    
    CGFloat heigth = 200 - 50;
    if (orderItem.extraVolistArray.count > 0) {
        heigth += (isExpand ? (orderItem.extraVolistArray.count) * kSeriveItemCellH : 0);
    }
    
    return heigth;
}




@end
