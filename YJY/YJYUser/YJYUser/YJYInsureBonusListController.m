//
//  YJYInsureBonusListController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/12.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureBonusListController.h"

@interface YJYInsureBonusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;

@property (strong, nonatomic) InsureAccountRecordVO *accountRecord;
@end

@implementation YJYInsureBonusCell

- (void)setAccountRecord:(InsureAccountRecordVO *)accountRecord {
    
    _accountRecord = accountRecord;
    self.desLabel.text = accountRecord.changeDesc;
    [self.desLabel sizeToFit];
    
    self.leftMoneyLabel.text = accountRecord.changeAccountStr;
    self.balanceMoneyLabel.text =  [NSString stringWithFormat:@"余额: %@",accountRecord.accountStr];
    self.timeLabel.text = accountRecord.createTime;
    self.applyNumberLabel.text = [NSString stringWithFormat:@"申请编号: %@",accountRecord.orderId];
}
@end


@interface YJYInsureBonusListController ()


@property (strong, nonatomic) NSMutableArray<InsureAccountRecordVO*> *recordListArray;
@property (assign, nonatomic) uint32_t pageNum;
@end

@implementation YJYInsureBonusListController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureBonusListController *)[UIStoryboard storyboardWithName:@"YJYInsureDone" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordListArray = [NSMutableArray array];
    self.pageNum = 1;
    
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    [self loadNetworkData];

    
}

- (void)loadNetworkData {
    
    GetInsureAccountDetailReq *req = [GetInsureAccountDetailReq new];
    req.tabType = self.tabType;
    req.pageNo = self.pageNum;
    req.pageSize = 9;
    
    if (self.account) {
        req.idcard = self.account.idcard;

    }
    if (self.orderId) {
        req.orderId = self.orderId;

    }
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureAccountDetail message:req controller:self command:APP_COMMAND_AppgetInsureAccountDetail success:^(id response) {
        
        GetInsureAccountDetailRsp *rsp = [GetInsureAccountDetailRsp parseFromData:response error:nil];
        if (self.pageNum > 1) {
            
            if (self.recordListArray.count >= rsp.recordListArray_Count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.recordListArray addObjectsFromArray:rsp.recordListArray];
                
            }
            
        }else {
            self.recordListArray = rsp.recordListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
        
    }];
}




#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recordListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsureBonusCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureBonusCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    InsureAccountRecordVO *record = self.recordListArray[indexPath.row];
    cell.accountRecord = record;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 83;
}
@end
