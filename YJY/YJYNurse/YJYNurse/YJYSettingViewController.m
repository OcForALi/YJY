//
//  YJYSettingViewController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/7.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYSettingViewController.h"


@interface YJYSettingViewContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UISwitch *ondutySwitch;
@property (assign, nonatomic) BOOL needOnduty;

@property (strong, nonatomic) GetHgInfoRsp *hgInfoRsp;

@end

@implementation YJYSettingViewContentController

- (void)viewDidLoad {
    
    self.tableView.tableFooterView = [UIView new];
    [self loadHgData];

}


- (void)loadHgData {
    

    GetHgInfoReq *req = [GetHgInfoReq new];
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgInfo message:req controller:nil command:APP_COMMAND_SaasappgetHgInfo success:^(id response) {
        
        
        self.hgInfoRsp = [GetHgInfoRsp parseFromData:response error:nil];
        [self loadSettingData];
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}
- (void)loadSettingData {
    
    GetSettingReq *req = [GetSettingReq new];
    [YJYNetworkManager requestWithUrlString:SAASAPPGetSettings message:req controller:nil command:APP_COMMAND_SaasappgetSettings success:^(id response) {
        
            GetSettingRsp *rsp = [GetSettingRsp parseFromData:response error:nil];
            self.needOnduty = rsp.needOnduty && self.hgInfoRsp.onduty;
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

- (void)setNeedOnduty:(BOOL)needOnduty {
    
    _needOnduty = needOnduty;
    self.ondutySwitch.on = needOnduty;
    
}

- (IBAction)toChangeZhuyuanClick:(id)sender {

    
    
    
    NSString *title = !self.ondutySwitch.on ? @"是否开启值班权限？" : @"是否关闭值班权限？";
    [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [SYProgressHUD show];
            UpdateOndutyReq *req = [UpdateOndutyReq new];
            req.onduty = !self.ondutySwitch.on;
            [YJYNetworkManager requestWithUrlString:SAASAPPUpdateOnduty message:req controller:self command:APP_COMMAND_SaasappupdateOnduty success:^(id response) {
                
                [SYProgressHUD hide];
                [self loadHgData];
                
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
//
}



#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && [YJYRoleManager sharedInstance].roleType != YJYRoleTypeSupervisor) {
        return 0;
    }else if (indexPath.row == 3 && [YJYRoleManager sharedInstance].roleType != YJYRoleTypeNurse) {
        return 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


@end

@interface YJYSettingViewController ()

@end

@implementation YJYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
   
    
    
}
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYSettingViewController *)[UIStoryboard storyboardWithName:@"YJYSetting" viewControllerIdentifier:NSStringFromClass(self)];
}
- (IBAction)toLoginOut:(id)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否退出" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex == 1) {
            [SYProgressHUD show];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SYProgressHUD hide];
                [YJYLoginManager loginOut];
                [self.navigationController popViewControllerAnimated:YES];
               
            });
            
            
        }
        
    }];
    
}




@end
