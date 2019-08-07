//
//  YJYMineDataController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYMineDataController.h"
#import "YJYEditController.h"
#import "UIImageView+XHLaunchAdCache.h"
#import "YJYMineCertificateController.h"
#import "YJYQRView.h"
#import "YJYTabController.h"

@interface YJYMineDataController ()

@property (strong, nonatomic) GetHgInfoRsp *rsp;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
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


@property (weak, nonatomic) IBOutlet UIButton *certificateButton;


@end

@implementation YJYMineDataController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYMineDataController *)[UIStoryboard storyboardWithName:@"YJYMine" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.nameLabel.text = self.myphoneLabel.text = self.mynumberLabel.text = self.locationLabel.text = self.sexLabel.text = self.peopleLabel.text = self.addressLabel.text = self.careerBeginLabel.text= self.jobBeginLabel.text= self.eContactLabel.text = self.ePhoneLabel.text = @"无";


    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
//    [self navigationBarAlphaWithWhiteTint];

    if (![YJYLoginManager isLogin]) {
        
        __weak YJYLoginController *vc = [YJYLoginController instanceWithStoryBoard];
        vc.didSuccessLoginComplete = ^(id response) {
            [self changeRootViewController:[YJYTabController instanceWithStoryBoard]];
        };
        YJYNavigationController *navi = [[YJYNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
        return;
    }
    
    [self loadNetworkData];

}

- (void)changeRootViewController:(UIViewController*)viewController {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (!window.rootViewController) {
        window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [window snapshotViewAfterScreenUpdates:YES];
    
    [viewController.view addSubview:snapShot];
    
    window.rootViewController = viewController;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}
- (void)loadNetworkData {
    
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgInfo message:nil controller:nil command:APP_COMMAND_SaasappgetHgInfo success:^(id response) {
        
        
        self.rsp = [GetHgInfoRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)reloadRsp {

    self.nameLabel.text = self.rsp.fullName;
    self.myphoneLabel.text = self.rsp.phone;
    self.mynumberLabel.text = self.rsp.hgno;
    self.locationLabel.text = self.rsp.nativeplace;
    self.sexLabel.text = (self.rsp.sex == 1) ? @"男" : @"女";
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
    
    //cerf
    
    self.certificateButton.hidden = self.rsp.nursingCertificateURL.length == 0;
}

#pragma mark - Action

- (IBAction)checkScanAction:(id)sender {
    
    YJYQRView *qrView = [YJYQRView instancetypeWithXIB];
    qrView.imgUrl = self.rsp.mpQrcode;
    qrView.frame = [UIApplication sharedApplication].keyWindow.frame;
    [qrView showInView:nil];
}

- (IBAction)emergencyContactEditAction:(id)sender {

    YJYEditController *vc = [YJYEditController instanceWithStoryBoard];
    vc.originString = self.eContactLabel.text;
    vc.didEditBlock = ^(NSString *text) {
        
        self.eContactLabel.text = text;
        
        [self update];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)emergencyPhoneEditAction:(id)sender {

    YJYEditController *vc = [YJYEditController instanceWithStoryBoard];
    vc.originString = self.ePhoneLabel.text;

    vc.didEditBlock = ^(NSString *text) {
        
        self.ePhoneLabel.text = text;
        
        [self update];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)viewCertificateAction:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = self.rsp.nursingCertificateURL;
    [self.navigationController pushViewController:vc animated:YES];
//    YJYMineCertificateController *vc = [YJYMineCertificateController instanceWithStoryBoard];
//    vc.nursingCertificateURL = self.rsp.nursingCertificateURL;
//    [self.navigationController pushViewController:vc animated:YES];
}


- (void)update {

    [SYProgressHUD show];
    
    UpdateHgInfoReq *req = [UpdateHgInfoReq new];
    
    req.emergencyContact = [self.eContactLabel.text isEqualToString:@"无"] ? nil : self.eContactLabel.text;
    req.emergencyContactPhone = [self.ePhoneLabel.text isEqualToString:@"无"] ? nil : self.ePhoneLabel.text;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateHgInfo message:req controller:self command:APP_COMMAND_SaasappupdateHgInfo success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"修改成功"];

        
    } failure:^(NSError *error) {
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 10 && self.rsp.nursingCertificateURL.length == 0) {
        
        return 0;
    }else if (indexPath.row == 5) {
        
        //address
        CGFloat addressWidth = self.tableView.frame.size.width - (35+17);
        
        CGFloat markExtraHeight = [self.rsp.address boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height - 17;
        
        return 65 + markExtraHeight;
        
    }else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];

    }
    
}
@end
