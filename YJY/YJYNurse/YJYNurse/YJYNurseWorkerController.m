//
//  YJYNurseWorkerController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/14.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNurseWorkerController.h"
#import "YJYNurseWorkDetailController.h"

@interface YJYNurseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *serveNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *languagesLabel;

@property (weak, nonatomic) IBOutlet UIButton *workerTypeButton;
@property (strong, nonatomic) HgVO *hg;

@end

@implementation YJYNurseCell

- (void)setHg:(HgVO *)hg {
    
    _hg = hg;
    
    self.nameLabel.text = hg.fullName;
    [self.iconView xh_setImageWithURL:[NSURL URLWithString:hg.pic]];
    self.jobYearLabel.text = [NSString stringWithFormat:@"工作%@年",@(hg.seniority)];
    self.serveNumberLabel.text = [NSString stringWithFormat:@"单数：%@单",@(hg.serveNumber)];

    
    NSArray *lans = [YJYSettingManager sharedInstance].languageList;
    //@[@"普通话",@"粤语",@"客家",@"客家话"];
    NSMutableArray *lansM = [NSMutableArray array];
    [hg.languageArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
        
        for (Language *language in lans) {
            if (language.id_p == value) {
                [lansM addObject:language.name];

            }
        }
        
    }];
    self.languagesLabel.text = [NSString stringWithFormat:@"通晓语言:%@",lansM.count > 0 ? [lansM componentsJoinedByString:@","] : @"无"];
 
    /// 1-多陪 2-专陪 3-两种都可以

    NSString *workTypeS = @"多陪";
    NSString *bgName = @"nurse_1toMore_bg";
    if (hg.workType == 2) {
        workTypeS = @"专陪";
        bgName = @"nurse_1to1_bg";
        
    }else if (hg.workType == 3) {
        workTypeS = @"普专";
        bgName = @"nurse_normal_bg";
    }
    self.workerTypeButton.hidden = [YJYRoleManager sharedInstance].roleType != YJYRoleTypeSupervisor;
    [self.workerTypeButton setTitle:workTypeS forState:0];
    [self.workerTypeButton setBackgroundImage:[UIImage imageNamed:bgName] forState:0];

}


@end

@interface YJYNurseWorkerController ()<UISearchBarDelegate>
@property (assign, nonatomic) uint32_t pageNum;
@property (strong, nonatomic) NSMutableArray<HgVO*> *hgVoArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation YJYNurseWorkerController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNurseWorkerController *)[UIStoryboard storyboardWithName:@"YJYNurse" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //title
    
    self.title = (self.nurseWorkType == YJYNurseWorkTypeNurse) ? @"护士列表" : @"护理员列表";
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
//    [SYProgressHUD show];
    self.pageNum = 1;
    [self loadNetworkData];
}



- (void)loadNetworkData {
    
    [self loadNetworkDataWithSearchText:nil];
    
}

- (void)loadNetworkDataWithSearchText:(NSString *)searchText {

    if (searchText) {
        self.pageNum = 1;
        self.hgVoArray = [NSMutableArray array];
    }
    
    GetHgReq *req = [GetHgReq new];
    req.pageNum = self.pageNum;
    req.pageSize = 10;
    req.fullName = searchText;
    if (self.insureVo) {
        
    }else {
        
        req.orderId = self.orderId;
        req.priceId = self.priceId;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHGList  message:req controller:self command:APP_COMMAND_SaasappgetHglist success:^(id response) {
        
        GetHgRsp *rsp = [GetHgRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (rsp.hgVoArray.count != 0) {
                [self.hgVoArray addObjectsFromArray:rsp.hgVoArray];
            }
            [self.tableView.mj_footer resetNoMoreData];
            
        }else {
            self.hgVoArray = rsp.hgVoArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        
        
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.hgVoArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = (self.nurseWorkType == YJYNurseWorkTypeNurse) ?  @"YJYNurseCell" : @"YJYNurseCellWork";
    
    YJYNurseCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellID];
    cell.hg = self.hgVoArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HgVO *hg = self.hgVoArray[indexPath.row];
    
    if (self.isImmediacy) {
        self.didSelectBlock(self.hgVoArray[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    
   

    
    if (self.didSelectBlock && self.isToSelect) {
        
        NSString *alertTitle = [NSString stringWithFormat:@"是否指派%@",hg.fullName];
        
        [UIAlertController showAlertInViewController:self withTitle:alertTitle message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [SYProgressHUD show];
                
                
                //变更订单护工（只针对于非承包制普陪订单
                /// 是否能变更护工  true-可以 false-不可以

                if (self.isUpdateHg) {
                    
                    UpdateOrderHGReq *req = [UpdateOrderHGReq new];
                    req.orderId = self.orderId;
                    req.hgId = hg.id_p;

                    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateOrderHG message:req controller:self command:APP_COMMAND_SaasappupdateOrderHg success:^(id response) {
                        
                        [SYProgressHUD hide];
                        
                        self.didSelectBlock(self.hgVoArray[indexPath.row]);
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    return;
                }
                
                //指派护工

                GuideStaffReq *req = [GuideStaffReq new];
                req.staffId = hg.id_p;
                
                if (self.insureVo) {
                    
                    req.guideType = 1;
                    req.insureNo = self.insureVo.insureNo;
                    if (self.insureVo.status == YJYInsureTypeStateFirstReview) {
                        req.type = 0;

                    }else if (self.insureVo.status == YJYInsureTypeStateReReviewing){
                        req.type = 1;

                    }
                    
                }else {
                    
                    req.guideType = self.nurseWorkType == YJYNurseWorkTypeNurse ? 1 : 3;
                    req.insureNo = self.insureNo;
                    req.orderId = self.orderId;
                    req.remark = self.remark;
                    req.time = self.time;
                }
              
                
                [YJYNetworkManager requestWithUrlString:SAASAPPGuideStaffNew message:req controller:self command:APP_COMMAND_SaasappguideStaffNew success:^(id response) {
                    
                    [SYProgressHUD hide];

                    self.didSelectBlock(self.hgVoArray[indexPath.row]);
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
             
            }
            
        }];
    
    }else {
    
        YJYNurseWorkDetailController *vc = [YJYNurseWorkDetailController instanceWithStoryBoard];
        vc.hgId = hg.id_p;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return (self.nurseWorkType == YJYNurseWorkTypeNurse) ? 50 : 65;
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {
    
    self.pageNum = 1;
    [self loadNetworkDataWithSearchText:searchText];
}


@end
