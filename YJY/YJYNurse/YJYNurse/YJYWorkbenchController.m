//
//  YJYWorkbenchController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYWorkbenchController.h"
#import "YJYCalendarsController.h"
#import "YJYLongNursesController.h"
#import "YJYNurseWorkerController.h"
#import "YJYOrderCreateVerifyController.h"
#import "YJYScanController.h"
#import "YJYProtocolManager.h"
#import <Photos/PHPhotoLibrary.h>
#import "YJYInsureManagerController.h"
#import "YJYSignatureController.h"
#import "YJYInOutStatisticsController.h"
#import "YJYAbnormalController.h"
#import "YJYSignAgreementController.h"

@interface YJYWorkbenchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *hLineView;

@end

@implementation YJYWorkbenchCell


@end

@interface YJYWorkbenchController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerRightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *headerVew;

//

@property (weak, nonatomic) IBOutlet UILabel *myCalendarTipLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *workCollectionView;
@property (strong, nonatomic) NSMutableArray<WorkbenchItem *> *workItems;


//data

@property (strong, nonatomic) GetHgInfoRsp *rsp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greetingTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelXConstraint;

@end

@implementation YJYWorkbenchController

- (void)viewDidLoad {
    
    self.isNaviError = YES;
    self.workItems = [NSMutableArray array];
    
    [super viewDidLoad];

    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = APPHEXCOLOR.CGColor;
    self.imageView.layer.borderWidth = 5;
    
   
    self.nameLabel.text = @"";
    self.greetingLabel.text = [[NSDate date] getTheTimeBucket];
    
    [self animationHeader];
    [SYProgressHUD show];



}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self navigationBarAlphaWithWhiteTint];
    [self reloadAllData];
    [self loadNetworkData];
}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];
}



- (void)loadNetworkData {
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgInfo message:nil controller:nil command:APP_COMMAND_SaasappgetHgInfo success:^(id response) {
        
        
        self.rsp = [GetHgInfoRsp parseFromData:response error:nil];
        //是否显示陪人床订单统计
        [self reloadRsp];
        [SYProgressHUD hide];

        
    } failure:^(NSError *error) {
        
        if (error.code == 1) {
            
            [SYProgressHUD show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SYProgressHUD hide];
                
                [YJYLoginManager loginOut];
                __weak YJYLoginController *vc = [YJYLoginController presentLoginVCWithInVC:self];
                vc.didSuccessLoginComplete = ^(id response) {
                    [self changeRootViewController:[YJYTabController instanceWithStoryBoard]];
                };
                
            });
        }
        
    }];
    
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
- (void)reloadRsp {
    
    self.workItems = [NSMutableArray arrayWithArray:[[YJYRoleManager sharedInstance]workbenchItemsWithRsp:self.rsp]];
    
    if (self.rsp.isPrcorder == 2) {
        
        WorkbenchItem *item = [WorkbenchItem new];
        item.title = @"陪人床订单";
        item.des = @"查看详情";
        item.type = YJYWorkbenchTypeisPRCOrder;
        
        [self.workItems addObject:item];
    }
    
    [self.tableView reloadData];

    [self.workCollectionView reloadData];

    
    self.nameLabel.text = self.rsp.fullName;
    [self.imageView xh_setImageWithURL:[NSURL URLWithString:self.rsp.picURL] placeholderImage:[UIImage imageNamed:@"app_tem_img_icon"]];
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse ||
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        self.headerLeftLabel.text = [NSString stringWithFormat:@"我的评估：%@单",@(self.rsp.assessNumber)];
        self.headerRightLabel.text = [NSString stringWithFormat:@"我的订单：%@单",@(self.rsp.orderNumber)];
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker ||
              [YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor ||
              [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
    
        self.headerLeftLabel.text = [NSString stringWithFormat:@"我的订单：%@单",@(self.rsp.orderNumber)];
        self.headerRightLabel.text = [NSString stringWithFormat:@"我的护理员：%@人",@(self.rsp.hgNumbser)];
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
            self.headerRightLabel.hidden = YES;
            self.leftLabelXConstraint.constant = 0;
        }
        
    }

   
}


- (void)animationHeader {
    
    [UIView animateWithDuration:2 animations:^{
        
        self.greetingLabel.alpha = 0;
//        self.greetingTopConstraint.constant = 0;
//        [self.headerVew layoutIfNeeded];
        
        
    }];
    
//    if (@available(iOS 11.0, *) ){
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    }

}
#pragma mark - UIScrollView


#define kHomeHeaderHeight 268

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < 0){
        CGRect rect = self.headerImageView.frame;
        rect.origin.y = offsetY;
        rect.size.height =  kHomeHeaderHeight - offsetY;
        self.headerImageView.frame = rect;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0) {
        
        NSInteger lines = self.workItems.count / 2 + self.workItems.count % 2;
        NSInteger sLines = (lines < 1) ? (lines + 1) : lines ;
        return sLines * 160 + 30;
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    
}



#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section    {
    
    return self.workItems.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYWorkbenchCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJYWorkbenchCell" forIndexPath:indexPath];
    
    
    NSInteger index = indexPath.row <= 5 ? indexPath.row : indexPath.row%5;
    
    UIColor *color = kOrderDailyColors[index];
    cell.hLineView.backgroundColor = color;
    cell.titleLabel.text = self.workItems[indexPath.row].title;
    

    cell.titleLabel.font = [UIFont systemFontOfSize: (cell.titleLabel.text.length <= 4) ? 24 : 20];
    cell.desLabel.text = self.workItems[indexPath.row].des;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYWorkbenchType type = self.workItems[indexPath.row].type;
    
    if (type == YJYWorkbenchTypeMyReview) {
        
        [self toMyLongNursesReview:nil];
    
    }else if (type == YJYWorkbenchTypeBookOrder) {
        
        [self toMyLongNursesBook:nil];
        
    }else if (type == YJYWorkbenchTypeMyCalendar) {
        
        [self toCalendarAction:nil];

    }else if (type == YJYWorkbenchTypeMyNurse) {
        
        [self toNurseListAction:nil];
        
    }else if (type == YJYWorkbenchTypeMyWork) {
        
        [self toWorkListAction:nil];
        
    }else if (type == YJYWorkbenchTypeCreateOrder) {
        
        [self toCreateOrderAction:nil];
    
    }else if (type == YJYWorkbenchTypeMyData) {
        
        [self toMyDataAction:nil];
    }else if (type == YJYWorkbenchTypeKPI) {
        
        [self toMyKPIAction:nil];
    }else if (type == YJYWorkbenchTypeInsureAdd) {
        
        [self toInsureAdd:nil];
    }else if (type == YJYWorkbenchTypeInsureManager) {
        
        [self toInsureManager:nil];
    }else if (type == YJYWorkbenchTypePayoffStatistics) {
        
        [self toPayoffStatistics:nil];
    }else if (type == YJYWorkbenchTypeServiceStatistics) {
        
        [self toServiceStatistics:nil];
    }else if (type == YJYWorkbenchTypeReviewStatistics) {
        
        [self toReviewStatistics:nil];
    }else if (type == YJYWorkbenchTypeOutInStatistics) {
        
        [self toOutInStatistics:nil];
    }else if (type == YJYWorkbenchTypeAbnormalOrder) {
        
        [self toAbnormalOrder:nil];
    }else if (type == YJYWorkbenchTypeSignAgreement) {
        [self toSignAgreement:nil];
    }else if (type == YJYWorkbenchTypeisPRCOrder) {
        [self toPRCOrder:nil];
    }
    
}

#pragma mark - Action

- (IBAction)toScanAction:(id)sender {
    
//    YJYSignatureController *vc = [YJYSignatureController new];
//    [self presentViewController:vc animated:YES completion:nil];
//
//    return;
    
//
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {

        [UIAlertController showAlertInViewController:self withTitle:@"是否请开启相机访问权限" message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {


            }
        }];


        return;
    }


    YJYScanController *vc = [YJYScanController presentWithInVC:self];
    vc.didResultBlock = ^(NSString *result) {

        if ([result containsString:@"yjy://"]) {
            [YJYProtocolManager pushViewControllerFrom:self url:result type:YJYProtocolFromTypePush];
        }else {

            [SYProgressHUD show];
            ScanReq *req = [ScanReq new];
            req.key = result;

            [YJYNetworkManager requestWithUrlString:SAASAPPScan message:req controller:self command:APP_COMMAND_Saasappscan success:^(id response) {

                [SYProgressHUD hide];
                ScanRsp *rsp = [ScanRsp parseFromData:response error:nil];
                [YJYProtocolManager pushViewControllerFrom:self url:rsp.yjyURL type:YJYProtocolFromTypePush];


            } failure:^(NSError *error) {

            }];
        }


    };
}


- (IBAction)toMyLongNursesReview:(id)sender {
    
    YJYLongNursesController *vc = [YJYLongNursesController instanceWithStoryBoard];
    vc.actionType = YJYLongNurseActionTypeReview;
    vc.title = @"评估列表";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)toMyLongNursesBook:(id)sender {
    
    YJYLongNursesController *vc = [YJYLongNursesController instanceWithStoryBoard];
    vc.actionType = YJYLongNurseActionTypeBook;
    vc.title = @"长护险下单预约";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)toCalendarAction:(id)sender {
    
    YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toNurseListAction:(id)sender {
    
    YJYNurseWorkerController *vc = [YJYNurseWorkerController instanceWithStoryBoard];
    vc.nurseWorkType = YJYNurseWorkTypeNurse;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toWorkListAction:(id)sender {
    
    YJYNurseWorkerController *vc = [YJYNurseWorkerController instanceWithStoryBoard];
    vc.nurseWorkType = YJYNurseWorkTypeWorker;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)toCreateOrderAction:(id)sender {
    
    YJYOrderCreateVerifyController *vc = [YJYOrderCreateVerifyController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toMyDataAction:(id)sender {
    
    [self.navigationController.tabBarController setSelectedIndex:2];
}

- (IBAction)toMyKPIAction:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = kManagerAchieve;
    vc.title = @"我的业绩";

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toInsureAdd:(id)sender {
    
    YJYOrderCreateVerifyController *vc = [YJYOrderCreateVerifyController instanceWithStoryBoard];
    vc.isAddApply = YES;
    vc.title = @"新增长护险申请";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toInsureManager:(id)sender {

    
    YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
    vc.title = @"长护险申请管理";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toPayoffStatistics:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker ? kHgordercount : kDdordercount;
    vc.title = @"结算统计";
//    vc.hiddenRefresh = YES;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toServiceStatistics:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = kDdservicecount;
    vc.title = @"当前服务统计";
    vc.hiddenRefresh = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toReviewStatistics:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    vc.urlString = kDdassesscount;
    vc.title = @"评价统计";
    vc.hiddenRefresh = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toOutInStatistics:(id)sender {
    
    YJYInOutStatisticsController *vc = [YJYInOutStatisticsController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toAbnormalOrder:(id)sender {
    
    YJYAbnormalController *vc = [YJYAbnormalController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toSignAgreement:(id)sender {
    
    YJYSignAgreementController *vc = [YJYSignAgreementController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toPRCOrder:(id)sender {
    
    YJYWebController *vc = [YJYWebController new];
    
//    NSDictionary *params = @{@"startTime":self.rsp.careerStartTime,@"endTime":self.rsp.careerStartTime}
    
    vc.urlString = kprcorder;
    vc.title = @"陪人床详情";
//    {"startTime":"2018-08-01","endTime":"2018-08-31","branchIds":["10476"],"name":"cz","pageNo":1,"pageSize":10}
    [self.navigationController pushViewController:vc animated:YES];
}

@end



