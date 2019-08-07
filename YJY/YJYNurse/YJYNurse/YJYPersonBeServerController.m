//
//  YJYPersonBeServerController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYPersonBeServerController.h"
#import "YJYLongNurseReportController.h"
#import "YJYLongNurseWebController.h"
@interface YJYPersonBeServerController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *hwLabel;
@property (weak, nonatomic) IBOutlet UILabel *lansLabel;
@property (weak, nonatomic) IBOutlet UITextView *extraTextView;
@property (weak, nonatomic) IBOutlet UITextView *securityTextView;

@property (strong, nonatomic) GetKinsfolkRsp *rsp;
@end

@implementation YJYPersonBeServerController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYPersonBeServerController *)[UIStoryboard storyboardWithName:@"YJYPerson" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
    
    
    /// 评估状态 0-待评估 1-已评估 2-跳过评估
    
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]].tintColor = [UIColor lightGrayColor];

    if (self.insureNo.length == 0 && self.pgStatus == 1) {
    
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"评估报告" style:UIBarButtonItemStylePlain target:self action:@selector(toHomeReviewReport)];
    }
    
    
    
}

- (void)loadNetworkData {
    
    GetKinsfolkReq *req = [GetKinsfolkReq new];
    req.kinsId = self.kinsId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetKins message:req controller:nil command:APP_COMMAND_SaasappgetKins success:^(id response) {
        
        
        self.rsp = [GetKinsfolkRsp parseFromData:response error:nil];
        
        
        [self reloadAllData];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}
- (void)reloadRsp {
    
    Kinsfolk *kins = self.rsp.kins;
    self.nameLabel.text = kins.fullName;
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",@(kins.age)];
    self.sexLabel.text = kins.sex == 1 ? @"男" : @"女";
    self.hwLabel.text = [NSString stringWithFormat:@"%@cm     %@kg",kins.height,kins.weight];
    
    
    
    NSArray *lans = [YJYSettingManager sharedInstance].languageList;
    NSMutableArray *lansM = [NSMutableArray array];
    [kins.languageArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
        
        for (Language *language in lans) {
            if (language.id_p == value) {
                [lansM addObject:language.name];
                
            }
        }
        
    }];
    
    NSString *lansStr = [lansM componentsJoinedByString:@","];
    self.lansLabel.text = lansStr ? lansStr : @"无";
    self.extraTextView.text = kins.remark;
    self.securityTextView.text = self.securityAssess;
}

- (void)toHomeReviewReport {

    YJYWebController *vc = [YJYWebController new];
    vc.title = @"评估报告";
    vc.urlString = [NSString stringWithFormat:@"%@?orderId=%@",kHomeAssessURL,self.orderId];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)toNurseReportAction {
    
    YJYLongNurseReportController *vc = [YJYLongNurseReportController instanceWithStoryBoard];
    vc.insureId = self.insureNo;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 5) {

        
        CGFloat markExtraWidth = self.tableView.frame.size.width - 100 - 5 - 20 - 5;
        
        CGFloat markExtraHeight = [self.rsp.kins.remark  boundingRectWithSize:CGSizeMake(markExtraWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        
        return markExtraHeight + 60;
        
        
    }else if(indexPath.row == 6) {
        
        return self.securityAssess.length >0 ? 200 : 0;
        
    }else {
    
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];

    }
    
    
    
}

@end
