//
//  YJYNurseWorkDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNurseWorkDetailController.h"
#import "YJYMineCertificateController.h"

@interface YJYNurseWorkDetailController ()

@property (strong, nonatomic) GetHgInfoRsp *rsp;
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lansLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *eContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *ePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *myphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mynumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *workerTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *branchsLabel;
@end

@implementation YJYNurseWorkDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNurseWorkDetailController *)[UIStoryboard storyboardWithName:@"YJYNurse" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ? @"护士详情" : @"护理员详情";
    
    //network
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [self navigationBarAlphaWithWhiteTint];
    [self.navigationController.navigationBar lt_setBackgroundColor:APPHEXCOLOR];

}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];
    
    
    
}
- (void)loadNetworkData {
    
    [SYProgressHUD show];
    
    GetHgInfoReq *req = [GetHgInfoReq new];
    req.hgId = self.hgId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgInfo message:req controller:nil command:APP_COMMAND_SaasappgetHgInfo success:^(id response) {
        
        
        self.rsp = [GetHgInfoRsp parseFromData:response error:nil];
        
        [SYProgressHUD hide];
        [self reloadAllData];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)reloadRsp {
    
    self.nameLabel.text = self.rsp.fullName;
    self.myphoneLabel.text = self.rsp.phone;
    self.mynumberLabel.text = self.rsp.hgno;
    self.sexLabel.text = (self.rsp.sex == 1) ? @"男" : @"女";
    self.nativeLabel.text = self.rsp.nativeplace;
    self.peopleLabel.text = self.rsp.nation;
    self.addressLabel.text = self.rsp.address;
    self.careerBeginLabel.text = self.rsp.careerStartTime;
    self.jobBeginLabel.text = self.rsp.joinTimeStr;
    self.eContactLabel.text = self.rsp.emergencyContact;
    self.ePhoneLabel.text = self.rsp.emergencyContactPhone;
    
    [self.avatorView xh_setImageWithURL:[NSURL URLWithString:self.rsp.picURL] placeholderImage:[UIImage imageNamed:@"app_tem_img_icon"]];
    
    
    NSArray *lans = [YJYSettingManager sharedInstance].languageList;
    NSMutableArray *lansM = [NSMutableArray array];
    [self.rsp.languageArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL *stop) {
        
        for (Language *language in lans) {
            if (language.id_p == value) {
                [lansM addObject:language.name];
                
            }
        }
        
    }];
    
    self.lansLabel.text = [lansM componentsJoinedByString:@","];
    
    NSString *workTypeS = @"多陪";
    NSString *bgName = @"nurse_1toMore_bg";
    if (self.rsp.workType == 2) {
        workTypeS = @"专陪";
        bgName = @"nurse_1to1_bg";
        
    }else if (self.rsp.workType == 3) {
        workTypeS = @"普专";
        bgName = @"nurse_normal_bg";

    }
    self.workerTypeButton.hidden = [YJYRoleManager sharedInstance].roleType != YJYRoleTypeSupervisor;
    [self.workerTypeButton setTitle:workTypeS forState:0];
    [self.workerTypeButton setBackgroundImage:[UIImage imageNamed:bgName] forState:0];
    
    self.branchsLabel.text = self.rsp.branchName;
    
    
}
- (IBAction)toCerf:(id)sender {
    
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = self.rsp.nursingCertificateURL;
    [self.navigationController pushViewController:vc animated:YES];
    
//    YJYMineCertificateController *vc = [YJYMineCertificateController new];
//    vc.nursingCertificateURL = self.rsp.nursingCertificateURL;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3 || indexPath.row == 7) {
        
        
        NSString *detail = indexPath.row == 32 ? self.rsp.branchName : self.rsp.address;
        
        CGFloat addressWidth = self.tableView.frame.size.width - (35+17);
        
        CGFloat markExtraHeight = [detail boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height - 17;
        
        return 65 + markExtraHeight;
        
    }else {
    
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

@end
