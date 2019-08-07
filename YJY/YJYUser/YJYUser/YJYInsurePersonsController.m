//
//  YJYInsurePersonsController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsurePersonsController.h"
#import "YJYInsureBonusController.h"

@interface YJYInsurePersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *beServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;

@property (strong, nonatomic) InsureAccountVO *account;

@end

@implementation YJYInsurePersonCell

- (void)setAccount:(InsureAccountVO *)account {

    _account = account;
    self.beServiceLabel.text = [NSString stringWithFormat:@"被服务人: %@",account.kinsName] ;
    self.leftMoneyLabel.text = account.accountStr;
    [self.leftMoneyLabel sizeToFit];
    

    self.orderNumLabel.text = [NSString stringWithFormat:@"服务中的长护险订单: %@ 单",@(account.orderNum)];

}

@end

@interface YJYInsurePersonsController ()


@property (strong, nonatomic) NSMutableArray<InsureAccountVO*> *recordListArray;

@end

@implementation YJYInsurePersonsController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsurePersonsController *)[UIStoryboard storyboardWithName:@"YJYInsureDone" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.noDataTitle = @"暂无长护险资格人";
    self.recordListArray = [NSMutableArray array];
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    

    [SYProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNetworkData];

}
- (void)loadNetworkData {
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureAccount message:nil controller:self command:APP_COMMAND_AppgetInsureAccount success:^(id response) {
        
        GetInsureAccountRsp *rsp = [GetInsureAccountRsp parseFromData:response error:nil];
        self.recordListArray = rsp.recordListArray;
        [self reloadAllData];

    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recordListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsurePersonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsurePersonCell"];
    
    InsureAccountVO *account = self.recordListArray[indexPath.row];
    
    cell.account = account;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYInsureBonusController *vc = [YJYInsureBonusController instanceWithStoryBoard];
    InsureAccountVO *account = self.recordListArray[indexPath.row];
    vc.account = account;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 133;
}


@end
