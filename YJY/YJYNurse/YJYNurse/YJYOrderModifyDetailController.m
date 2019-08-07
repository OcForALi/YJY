//
//  YJYOrderModifyDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/26.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderModifyDetailController.h"
#pragma mark - YJYOrderModifyDetailCell
@interface YJYOrderModifyDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel * contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) OrderProcess *orderProcess;

@end


@implementation YJYOrderModifyDetailCell





- (void)setOrderProcess:(OrderProcess *)orderProcess {
    
    _orderProcess = orderProcess;
    self.dateLabel.text = orderProcess.processTimeStr;
    self.contactPeopleLabel.text = orderProcess.userName;
    self.detailLabel.text = orderProcess.content;

    /// 子类型（与processType关联）6变更服务：1-变更联系信息，2-变更服务项目，3变更服务人员

    if (orderProcess.extendType == 1) {

        self.contactLabel.text = @"变更联系信息";
    }else if (orderProcess.extendType == 2) {
        self.contactLabel.text = @"变更服务项目";

    }else {
        self.contactLabel.text = @"变更服务";

    
    }
}

@end

#pragma mark - YJYOrderModifyDetailController


@interface YJYOrderModifyDetailController ()

@property (strong, nonatomic) GetOrderProcessRsp *rsp;
@end

@implementation YJYOrderModifyDetailController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderModifyDetailController *)[UIStoryboard storyboardWithName:@"YJYOrderModify" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    [SYProgressHUD show];
    
    GetOrderProcessReq *req = [GetOrderProcessReq new];
    req.orderId = self.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderProcessList message:req controller:nil command:APP_COMMAND_SaasappgetOrderProcessList success:^(id response) {
        
        
        [SYProgressHUD hide];
        self.rsp = [GetOrderProcessRsp parseFromData:response error:nil];
        
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.rsp.opListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderModifyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderModifyDetailCell"];
    
    cell.orderProcess = self.rsp.opListArray[indexPath.row];
    [cell.timeView yjy_setBottomShadow];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderProcess *orderProcess = self.rsp.opListArray[indexPath.row];
    
    CGFloat markWidth = self.tableView.frame.size.width - 110 - 17;
    
 
    
    CGFloat markExtraHeight = [orderProcess.content boundingRectWithSize:CGSizeMake(markWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    
    return 180 + markExtraHeight;
}

@end
