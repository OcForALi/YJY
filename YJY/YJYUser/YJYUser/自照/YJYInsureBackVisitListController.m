//
//  YJYInsureBackVisitListController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/5.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureBackVisitListController.h"
#import "YJYInsureBackVisitController.h"

@interface YJYInsureBackVisitListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) InsureOrderVisitVO *insureOrderVisitVO;

@end

@implementation YJYInsureBackVisitListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

}
- (void)setInsureOrderVisitVO:(InsureOrderVisitVO *)insureOrderVisitVO {
    
    _insureOrderVisitVO = insureOrderVisitVO;
    self.visitTimeLabel.text = [NSString stringWithFormat:@"回访时间：%@",insureOrderVisitVO.visitTimeStr];
    self.stateLabel.text = insureOrderVisitVO.statusStr;
    
}

@end

@interface YJYInsureBackVisitListController ()

@property (strong, nonatomic) GetInsureOrderVisitListRsp *rsp;

@end

@implementation YJYInsureBackVisitListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetInsureOrderVisitListReq *req = [GetInsureOrderVisitListReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureOrderVisitList message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderVisitList success:^(id response) {
        
        self.rsp = [GetInsureOrderVisitListRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    [self reloadAllData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureBackVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureBackVisitListCell" forIndexPath:indexPath];
    
    InsureOrderVisitVO *insureOrderVisitVO = self.rsp.visitVoArray[indexPath.row];
    cell.insureOrderVisitVO = insureOrderVisitVO;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsureOrderVisitVO *insureOrderVisitVO = self.rsp.visitVoArray[indexPath.row];
    YJYInsureBackVisitController *vc =[YJYInsureBackVisitController instanceWithStoryBoard];
    vc.insureOrderVisitVO = insureOrderVisitVO;
    vc.orderDetailRsp = self.orderDetailRsp;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.visitVoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}



@end
