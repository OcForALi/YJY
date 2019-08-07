//
//  YJYInsureDailyListController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/2.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureDailyListController.h"
#import "YJYInsureDailyDetailController.h"

typedef void(^YJYInsureDailyListCellDidSelectBlock)();

@interface YJYInsureDailyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@property (copy, nonatomic) YJYInsureDailyListCellDidSelectBlock didSelectBlock;
@property (strong, nonatomic) InsureOrderTendItemVO *insureOrderTendItemVO;

@end

@implementation YJYInsureDailyListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (IBAction)toDetail:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)setInsureOrderTendItemVO:(InsureOrderTendItemVO *)insureOrderTendItemVO {
    
    _insureOrderTendItemVO = insureOrderTendItemVO;
    self.serverLabel.text = insureOrderTendItemVO.hgName;
    self.stateLabel.text = insureOrderTendItemVO.statusStr;
    self.createLabel.text = insureOrderTendItemVO.serviceTimeStr;
}
@end



@interface YJYInsureDailyListController ()



@end

@implementation YJYInsureDailyListController


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
    
    /// 服务地点 0-无 1-在家 2-住院

    GetInsureOrderTendItemReq *req = [GetInsureOrderTendItemReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.serviceAddr = self.orderDetailRsp.order.orderType == 1 ? 2 : 1;
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureOrderTendItem message:req controller:self command:APP_COMMAND_AppgetInsureOrderTendItem success:^(id response) {
        
        self.rsp = [GetInsureOrderTendItemRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
       
        [self reloadErrorData];
    }];
}

- (void)reloadRsp {
    
    self.familyNumberLabel.text = [NSString stringWithFormat:@"%@天",@(self.rsp.familyNumber)];
    self.hospitalNumberLabel.text = [NSString stringWithFormat:@"%@天",@(self.rsp.hospitalNumber)];
    self.serveNumberLabel.text = [NSString stringWithFormat:@"%@天",@(self.rsp.serveNumber)];
    self.restNumberLabel.text = [NSString stringWithFormat:@"%@天",@(self.rsp.restNumber)];
    self.absenteeismNumberLabel.text = [NSString stringWithFormat:@"%@天",@(self.rsp.absenteeismNumber)];
    [self reloadAllData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureDailyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureDailyListCell" forIndexPath:indexPath];
    
    
    InsureOrderTendItemVO *insureOrderTendItemVO = self.rsp.voArray[indexPath.row];
    cell.insureOrderTendItemVO = insureOrderTendItemVO;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsureOrderTendItemVO *insureOrderTendItemVO = self.rsp.voArray[indexPath.row];
    YJYInsureDailyDetailController *vc =[YJYInsureDailyDetailController instanceWithStoryBoard];
    vc.insureOrderTendItemVO = insureOrderTendItemVO;
    vc.orderId = self.orderDetailRsp.order.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.rsp.voArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}


@end
