//
//  YJYInsureCarePlanController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/2.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureCarePlanController.h"

typedef void(^YJYInsureCarePlanCellDidSelectBlock)();

@interface YJYInsureCarePlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *beServerLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;

@property (copy, nonatomic) YJYInsureCarePlanCellDidSelectBlock didSelectBlock;
@property (strong, nonatomic) OrderTendVO *orderTendVO;

@end

@implementation YJYInsureCarePlanCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.stateLabel.layer.cornerRadius = 20/2;
    self.stateLabel.layer.borderColor = APPGrayCOLOR.CGColor;
    self.stateLabel.layer.borderWidth = 1;
}

- (IBAction)toDetail:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)setOrderTendVO:(OrderTendVO *)orderTendVO {
    
    _orderTendVO = orderTendVO;
    self.beServerLabel.text = orderTendVO.name;
    self.stateLabel.text = orderTendVO.statusStr;
    self.createLabel.text = orderTendVO.startTimeStr;
}

@end

@interface YJYInsureCarePlanController ()

@property (strong, nonatomic) GetOrderTendListRsp *rsp;

@end

@implementation YJYInsureCarePlanController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderHelp" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetOrderTendListReq *req = [GetOrderTendListReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.type = 2;// self.orderDetailRsp.order.serviceType;;
    
    [YJYNetworkManager requestWithUrlString:APPGetOrderTendList message:req controller:self command:APP_COMMAND_AppgetOrderTendList success:^(id response) {
        
        self.rsp = [GetOrderTendListRsp parseFromData:response error:nil];
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
    
    return self.rsp.voListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureCarePlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureCarePlanCell" forIndexPath:indexPath];
    
    
    OrderTendVO *orderTendVO = self.rsp.voListArray[indexPath.row];
    cell.orderTendVO = orderTendVO;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}


@end
