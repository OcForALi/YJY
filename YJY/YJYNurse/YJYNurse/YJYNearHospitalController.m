//
//  YJYNearHospitalController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/31.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYNearHospitalController.h"


@interface YJYHospitalCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearIcon;

@property (strong, nonatomic) OrgDistanceModel *org;

@end

@implementation YJYHospitalCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.nearIcon.layer.borderWidth = 1;
    self.nearIcon.layer.borderColor = APPORANGECOLOR.CGColor;
    self.nearIcon.textColor = APPORANGECOLOR;
}


- (void)setOrg:(OrgDistanceModel *)org {
    
    _org = org;
    
    self.nearIcon.hidden = !org.orgVo.isLocation;
    self.nameLabel.textColor = org.orgVo.isLocation ? APPHEXCOLOR : APPDarkGrayCOLOR;
    
    OrgVO *orgModel = org.orgVo;
    self.nameLabel.text = orgModel.orgName;
    self.detailLabel.text = [NSString stringWithFormat:@"%d位护理员 / 被服务人员%d位",(int)orgModel.worker,(int)orgModel.servicedNumber];
    
    //tags
    //OrgTag
//    orgModel.tagListArray = org.orgVo.tagListArray;// [NSMutableArray arrayWithArray:@[@"贴心专陪",@"温馨普陪"]];
    self.tagView.backgroundColor = [UIColor clearColor];
    
    if (org.orgVo.tagListArray_Count == 0) {
     
        OrgTagVO *tag = [OrgTagVO new];
        tag.tagName = @"无标签";
        tag.colorStr = @"ffb93f";
        tag.orgId = org.orgVo.orgId;
        tag.orgName = org.orgVo.orgName;
        [org.orgVo.tagListArray addObject:tag];
    }
    
    for (NSInteger i = 0; i < org.orgVo.tagListArray.count; i ++) {
        
        OrgTagVO *tag = org.orgVo.tagListArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i * 53) , 0, 43, 18);
        
        [button setTitle:tag.tagName forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        button.userInteractionEnabled = NO;
        
        button.layer.cornerRadius = button.frame.size.height/2;
//        button.layer.borderWidth = 1;
        
        button.layer.backgroundColor = [UIColor colorWithHexString:tag.colorStr].CGColor;
        [button setTitleColor:[UIColor whiteColor] forState:0];

        
        [self.tagView addSubview:button];

        
    }
    
    //等级
  
    [self.levelButton setTitle:[NSString stringWithFormat:@"%@",orgModel.orgLevelStr] forState:0];
    
    //距离最小范围0.1km，最大范围30km。 小于0.1km全部显示<0.1km， 大于30km全部显示>30.0km,中间范围距离统一以km为单位，保留一位小数
    
    NSString *distance =  [NSString stringWithFormat:@"%gkm",org.distance/1000];
    
    if (org.distance < 100) {
        distance =  @"<0.1km";
    }else if (org.distance > 30 * 1000) {
        distance =  @">30.0km";
    }
    
    self.distanceLabel.text = distance;
    self.distanceLabel.backgroundColor = [UIColor clearColor];
}

@end

@interface YJYNearHospitalController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *search;


@property (strong, nonatomic) AMapLocationManager *locationManager;

@property (assign, nonatomic) uint32_t pageNo;
@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) uint32_t adcode;

@end

@implementation YJYNearHospitalController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNearHospitalController *)[UIStoryboard storyboardWithName:@"YJYBook" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        
        self.noDataTitle  = @"附近没有医院";
        
        
        //    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 0);
        
        //setup
        
        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            self.pageNo = 1;
            [weakSelf loadNetworkData];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            if (self.pageNo == 1) {
                self.pageNo++;
            }
            [weakSelf loadNetworkData];
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchText:) name:UITextFieldTextDidChangeNotification object:nil];
        
        self.orgListArray = [NSMutableArray array];
        
        
        [SYProgressHUD showToLoadingView:self.view];
        
        self.locationManager =  [[AMapLocationManager alloc]init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!error)
                {
                    self.location = location;
                    self.adcode = (uint32_t)[regeocode.adcode integerValue];
                    
                    [SYProgressHUD hideToLoadingView:self.view];
                    
                }else {
                    
                    [SYProgressHUD hideToLoadingView:self.view];
                }
                [self loadNetworkData];
            });
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!self.location) {
                [self showLocationError];

            }

            
        });
        
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        [self showLocationError];
    }

}

- (void)showLocationError {
    [SYProgressHUD hideToLoadingView:self.view];

    //定位不能用
    [UIAlertController showAlertInViewController:self withTitle:@"请在设置-隐私-护理易-开启定位" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)dealloc {

    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)loadNetworkData {

    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:self command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        
        self.orgListArray = [NSMutableArray array];
        self.orgListArray = rsp.orgListArray;
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
  
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orgListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYHospitalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYHospitalCell" forIndexPath:indexPath];
    cell.org = self.orgListArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrgDistanceModel *org = self.orgListArray[indexPath.row];

    if (self.nearHospitalDidSelectBlock) {
        
        self.nearHospitalDidSelectBlock(org);
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 100;
}

#pragma mark - Action

- (IBAction)beginSearch:(id)sender {
    
    
    
    [self.tableView beginUpdates];
    
    self.headerView.hidden = !self.headerView.hidden;
    
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.headerView.hidden ? 0 : 44);

    [self.tableView endUpdates];

}


#pragma mark - Search

- (void)searchText:(NSNotification *)nofi {

    if (self.searchTextField.text.length > 0) {
        self.noDataTitle  = @"找不到医院，请输入医院名全称";
    }else {
        self.noDataTitle  = @"附近没有医院";
    }

    self.pageNo = 1;
    [self loadNetworkData];
}




@end
