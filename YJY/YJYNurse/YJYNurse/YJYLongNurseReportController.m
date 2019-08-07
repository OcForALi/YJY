//
//  YJYLongNurseReportController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/27.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLongNurseReportController.h"
#import "YJYLongNurseWebController.h"
@interface YJYLongNurseReportController ()

@property (strong, nonatomic) GetInsureNoRsp *rsp;

@property (weak, nonatomic) IBOutlet UILabel *userReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *adlReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *mmseReviewLabel;

@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *adlButton;
@property (weak, nonatomic) IBOutlet UIButton *mmseButton;

@property (assign, nonatomic) BOOL isAdl;
@property (assign, nonatomic) BOOL isMmse;

@end

@implementation YJYLongNurseReportController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLongNurseReportController *)[UIStoryboard storyboardWithName:@"YJYLongNurseDetail" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkData];

}

#pragma mark - load
- (void)loadNetworkData {
    
    [SYProgressHUD show];
    GetInsureReq *req = [GetInsureReq new];
    req.insureNo = self.insureModel.insureNo;
    if (!req.insureNo || req.insureNo.length == 0) {
        req.insureNo = self.insureId;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureAssess message:req controller:self command:APP_COMMAND_SaasappgetInsureAssess success:^(id response) {
        
        
        [SYProgressHUD hide];
        self.rsp = [GetInsureNoRsp parseFromData:response error:nil];
    
        
        [self reloadAllData];
        [self reloadRsp];

        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
}

- (void)reloadRsp {
    
    self.insureModel = self.rsp.insureModel;

    
    self.userReviewLabel.text = self.insureModel.score > -1 ? [NSString stringWithFormat:@"%@分",@(self.insureModel.score)] : @"未评测";
    
    self.adlReviewLabel.text = self.insureModel.scoreAdl > -1 ?  [NSString stringWithFormat:@"%@分",@(self.insureModel.scoreAdl)] : @"未评测";
    
    self.mmseReviewLabel.text = self.insureModel.scoreMmse > -1 ?  [NSString stringWithFormat:@"%@分",@(self.insureModel.scoreMmse)] : @"未评测";
    
    self.isAdl = self.insureModel.scoreAdl > -1;
    self.isMmse = self.insureModel.scoreMmse > -1;
    
    //button
    
    NSString *edit = (self.rsp.insureStatus == 2 &&
                      [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) ? @"编辑" : @"查看";
    
    [self.adlButton setTitle:self.isAdl ? @"查看" : edit forState:0];
    [self.mmseButton setTitle:self.isMmse ? @"查看" : edit forState:0];
    
    self.userButton.hidden = self.insureModel.score == -1;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    NSString *urlString;
    NSString *title = @"评估";

    BOOL isHadScore;
    
    if (indexPath.row == 0) {
        
        urlString = kUserassessURL;
        title = @"用户评估";
        isHadScore = YES;
        
    }else if (indexPath.row == 1) {
        urlString = kSAASADLURL;
        title = @"ADL评估";
        isHadScore = self.isAdl;
        
    }else if (indexPath.row == 2) {
        urlString = kMMSEURL;
        title = @"MMSE评估";
        isHadScore = self.isMmse;
    }else {
    
        isHadScore = YES;
    }
    
    NSString *edit = (self.rsp.insureStatus == 2 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && !isHadScore) ? @"true" : @"false";
    urlString = [NSString stringWithFormat:@"%@?insureNO=%@&edit=%@",urlString,self.insureModel.insureNo,edit];
    
    YJYLongNurseWebController *vc = [YJYLongNurseWebController new];
    vc.title = title;
    vc.urlString = urlString;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
