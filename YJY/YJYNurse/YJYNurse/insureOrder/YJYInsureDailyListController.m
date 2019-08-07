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
@property (weak, nonatomic) IBOutlet UIButton *detailButton;


@property (copy, nonatomic) YJYInsureDailyListCellDidSelectBlock didSelectBlock;
@property (strong, nonatomic) InsureOrderTendItemVO *insureOrderTendItemVO;

@end

@implementation YJYInsureDailyListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (IBAction)toDetail:(id)sender {
    if (self.insureOrderTendItemVO.status != 3) {
        return;
    }
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)setInsureOrderTendItemVO:(InsureOrderTendItemVO *)insureOrderTendItemVO {
    
    _insureOrderTendItemVO = insureOrderTendItemVO;
    self.serverLabel.text = insureOrderTendItemVO.hgName;
    self.stateLabel.text = [NSString stringWithFormat:@"已完成%llu项",insureOrderTendItemVO.serviceName];
    self.createLabel.text = insureOrderTendItemVO.serviceTimeStr;
    
    NSString *buttonStr;
    if (insureOrderTendItemVO.status == 1) {
        buttonStr = @"休假";
    }else if (insureOrderTendItemVO.status == 2) {
        
        buttonStr = @"旷工";
    }else if (insureOrderTendItemVO.status == 3) {
        
        buttonStr = @"查看详情";
    }
    [self.detailButton setTitle:buttonStr forState:0];
    self.detailButton.hidden = (self.insureOrderTendItemVO.status == 0);
}
@end



@interface YJYInsureDailyListController ()

@property (weak, nonatomic) IBOutlet UILabel *homeDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hosiptalDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *holidayDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *outworkDayLabel;

@end

@implementation YJYInsureDailyListController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureDailyList" viewControllerIdentifier:className];
    return vc;
}
- (IBAction)toFilter:(UIButton *)sender {
    
    if (sender.tag == 0) {
        [self loadNetworkDataWithServiceAddr:1 status:0];
    }else if (sender.tag == 1) {
        [self loadNetworkDataWithServiceAddr:2 status:0];
    }else if (sender.tag == 2) {
        [self loadNetworkDataWithServiceAddr:0 status:3];
    }else if (sender.tag == 3) {
        [self loadNetworkDataWithServiceAddr:0 status:1];
    }else if (sender.tag == 4) {
        [self loadNetworkDataWithServiceAddr:0 status:2];
    }else {
        [self loadNetworkDataWithServiceAddr:0 status:0];

    }
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkDataWithServiceAddr:0 status:0];
    
}

- (void)loadNetworkDataWithServiceAddr:(uint32_t)serviceAddr status:(uint32_t)status {
    
    [SYProgressHUD show];
    
    /// 服务地点 0-无 1-在家 2-住院
    /// 每日明细状态  0-全部 1-休假 2-旷工 3-服务

    GetInsureOrderTendItemReq *req = [GetInsureOrderTendItemReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.serviceAddr = serviceAddr;
    req.status = status;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderTendItem message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderTendItem success:^(id response) {
        [SYProgressHUD hide];
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
    cell.didSelectBlock = ^{
        
        YJYInsureDailyDetailController *vc = [YJYInsureDailyDetailController instanceWithStoryBoard];
        vc.orderId = self.orderDetailRsp.order.orderId;
        vc.insureOrderTendItemVO = insureOrderTendItemVO;
        [self.navigationController pushViewController:vc animated:YES];
    };
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
