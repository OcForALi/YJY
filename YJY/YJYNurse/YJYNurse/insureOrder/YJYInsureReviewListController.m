//
//  YJYOrderInsureWaitReviewController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/7.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureReviewListController.h"



@interface YJYInsureReviewListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) InsureOrderCheckVO *insureOrderCheckVO;
@end

@implementation YJYInsureReviewListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}
- (void)setInsureOrderCheckVO:(InsureOrderCheckVO *)insureOrderCheckVO {
    
    _insureOrderCheckVO = insureOrderCheckVO;
    self.resultLabel.text = insureOrderCheckVO.title;
    self.stateLabel.text = [NSString stringWithFormat:@"考察结果：%@",insureOrderCheckVO.scoreStr];
    self.timeLabel.text = [NSString stringWithFormat:@"考察日期：%@",insureOrderCheckVO.checkTimeStr];
    
    /// 考核类型  0-长护险生活照护类操作考核 1-居家照护质量标准检查 2-最终考核

}


@end

@interface YJYInsureReviewListController ()

@property (strong, nonatomic) GetInsureOrderCheckListRsp *rsp;

@end

@implementation YJYInsureReviewListController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureReview" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetKinsInsureReq *req = [GetKinsInsureReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.hgnoName = self.orderDetailRsp.order.hgName;
    
    if (self.orderId) {
        req.orderId = self.orderId;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderCheckList message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderCheckList success:^(id response) {
        
        self.rsp = [GetInsureOrderCheckListRsp parseFromData:response error:nil];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureReviewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureReviewListCell" forIndexPath:indexPath];
    
    InsureOrderCheckVO *insureOrderCheckVO = self.rsp.voArray[indexPath.row];
    cell.insureOrderCheckVO = insureOrderCheckVO;
    
    return cell;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.voArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}


@end
