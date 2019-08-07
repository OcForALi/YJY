//
//  YJYOfflineWorkbenchController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/2/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYOfflineWorkbenchController.h"
#import "YJYScanController.h"
#import <Photos/Photos.h>
#import "YJYProtocolManager.h"
#import "YJYOrdersController.h"
#import "YJYNotificationController.h"
#import "YJYCalendarsController.h"
#import "YJYLongNursesController.h"
#import "YJYInsureCarePlanController.h"
#import "YJYNurseWorkerController.h"
#import "YJYInsureManagerController.h"
#import "YJYWaitVisitOrderController.h"
typedef NS_ENUM(NSInteger, YJYOfflineWorkbenchType) {
    
    YJYOfflineWorkbenchTypeServeData,
    YJYOfflineWorkbenchTypeMyTodo,
    YJYOfflineWorkbenchTypeCommonTool,
    
};

typedef NS_ENUM(NSInteger, YJYOfflineWorkbenchCellType) {
        
    YJYOfflineWorkbenchCellTypeServeDataTitle,
    YJYOfflineWorkbenchCellTypeServeData,
    YJYOfflineWorkbenchCellTypeServeDataBlank,
    
    YJYOfflineWorkbenchCellTypeMyTodoTitle,
    YJYOfflineWorkbenchCellTypeMyTodo,
    YJYOfflineWorkbenchCellTypeMyTodoBlank,
    
    
    YJYOfflineWorkbenchCellTypeCommonToolTitle,
    YJYOfflineWorkbenchCellTypeCommonTool,
    YJYOfflineWorkbenchCellTypeCommonToolBlank
};

#pragma mark - YJYOfflineWorkbenchCell


@interface YJYOfflineWorkbenchCell : UICollectionViewCell

@property (strong, nonatomic) CommonToolsVO *commonToolsVO;
@property (strong, nonatomic) WorkbenchVO *serveWorkbenchVO;
@property (strong, nonatomic) WorkbenchVO *myTodoWorkbenchVO;


@property (assign, nonatomic) YJYOfflineWorkbenchType workbenchType;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation YJYOfflineWorkbenchCell

- (void)setServeWorkbenchVO:(WorkbenchVO *)serveWorkbenchVO {
    
    _serveWorkbenchVO = serveWorkbenchVO;
    self.numLabel.text = serveWorkbenchVO.num;
    self.titleLabel.text = serveWorkbenchVO.desc;
    
}

- (void)setMyTodoWorkbenchVO:(WorkbenchVO *)myTodoWorkbenchVO {
    
    _myTodoWorkbenchVO = myTodoWorkbenchVO;
    self.numLabel.text = myTodoWorkbenchVO.num;
    self.titleLabel.text = myTodoWorkbenchVO.desc;
    
}
- (void)setCommonToolsVO:(CommonToolsVO *)commonToolsVO {
    
    _commonToolsVO  = commonToolsVO;
    self.titleLabel.text = commonToolsVO.desc;
    [self.iconImageView xh_setImageWithURL:[NSURL URLWithString:commonToolsVO.iconURL]];

}


@end


#pragma mark - YJYOfflineWorkbenchLayout

@interface YJYOfflineWorkbenchShortLayout : UICollectionViewFlowLayout

@end

@implementation YJYOfflineWorkbenchShortLayout

- (void)prepareLayout {
    
    
    [super prepareLayout];
    
    CGFloat width = self.collectionView.frame.size.width/3-5*2;
    CGFloat height = 65;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
}

@end


@interface YJYOfflineWorkbenchLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) YJYOfflineWorkbenchType workbenchType;


@end

@implementation YJYOfflineWorkbenchLayout


- (void)prepareLayout {
    
    
    [super prepareLayout];
    
    CGFloat width = self.collectionView.frame.size.width/3 - 5;
    CGFloat height = 108;
    
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
}

@end

@interface YJYOfflineWorkbenchController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *serviceDataCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *myToDoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *commonToolCollectionView;


@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property (strong, nonatomic)GetMyWorkbenchRsp *rsp;

@end

@implementation YJYOfflineWorkbenchController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYOfflineWorkBench" viewControllerIdentifier:className];
    return vc;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, 64);
    self.msgButton.layer.cornerRadius = 13;
    self.msgButton.hidden = YES;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNetworkData) name:kYJYWorkBenchDidLoginNotification object:nil];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];
    [self loadNetworkData];
    if (IS_IPHONE_X) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
        
    }

}



- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    
    [self navigationBarNotAlphaWithBlackTint];
    if (IS_IPHONE_X) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadNetworkData {
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetMyWorkbench message:nil controller:self command:APP_COMMAND_SaasappgetMyWorkbench success:^(id response) {
        
        self.rsp = [GetMyWorkbenchRsp parseFromData:response error:nil];
        [self reloadAllData];
        [self reloadRsp];
        [SYProgressHUD hide];

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)reloadRsp {
    self.nameLabel.text = self.rsp.hgName;
    [self.msgButton setTitle:self.rsp.unReadNum forState:0];
    self.msgButton.hidden = (self.rsp.unReadNum.length == 0);
    [self.serviceDataCollectionView reloadData];
    [self.myToDoCollectionView reloadData];
    [self.commonToolCollectionView reloadData];
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.serviceDataCollectionView) {
        
        return self.rsp.serviceDataListArray.count;
        
    }else if (collectionView == self.myToDoCollectionView) {
        
        return self.rsp.backlogListArray.count;
        
    }else if (collectionView == self.commonToolCollectionView) {
        
        return self.rsp.toolsArray.count;
    }
    return 0;
    
        
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    NSString *cellIdentifier = @"YJYOfflineWorkbenchCell";
    YJYOfflineWorkbenchCell *cell;
    
    

    if (collectionView == self.serviceDataCollectionView) {
        
        cellIdentifier = @"YJYOfflineWorkbenchCell";
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        WorkbenchVO *workbenchVO = self.rsp.serviceDataListArray[indexPath.row];
        cell.serveWorkbenchVO = workbenchVO;
        
    }else if (collectionView == self.myToDoCollectionView) {
        
        cellIdentifier = @"YJYOfflineWorkbenchCellSecond";
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        WorkbenchVO *workbenchVO = self.rsp.backlogListArray[indexPath.row];
        cell.myTodoWorkbenchVO = workbenchVO;


        
    }else if (collectionView == self.commonToolCollectionView) {
        
        cellIdentifier = @"YJYOfflineWorkbenchCellThree";
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        CommonToolsVO *commonToolsVO = self.rsp.toolsArray[indexPath.row];
        cell.commonToolsVO = commonToolsVO;

    }
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *nativeURL;
    NSString *des;
    
    if (collectionView == self.serviceDataCollectionView) {
        

        return;
        
    }else if (collectionView == self.myToDoCollectionView) {
        
        
        WorkbenchVO *workbenchVO = self.rsp.backlogListArray[indexPath.row];
        nativeURL = workbenchVO.nativeURL;
        des = workbenchVO.desc;
      
        
    }else if (collectionView == self.commonToolCollectionView) {
        
        CommonToolsVO *commonToolsVO = self.rsp.toolsArray[indexPath.row];
        nativeURL = commonToolsVO.nativeURL;
        des = commonToolsVO.desc;

    }
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        
        [self toCustomManagerWithNativeURL:nativeURL des:des];
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        [self toHGWithNativeURL:nativeURL];
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        [self toNurseWithNativeURL:nativeURL];
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        [self toNurseLeaderWithNativeURL:nativeURL];
    }
    
    
}
#pragma mark  - 跳转
- (void)toCustomManagerWithNativeURL:(NSString *)nativeURL des:(NSString *)des{
    
    
    if ([nativeURL isEqualToString:@"yjy://indexCustomerManager/myAgencyRenewalService"]) {
        //服务续费
        
        
        
    }else if ([nativeURL isEqualToString:@"yjy://indexCustomerManager/commonToolsMySchedule"]) {
        
        //护工的我的待办模块的今日服务
        
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexCustomerManager/commonToolsChInsuranceApply"]) {
        
        //我的日程
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        [self.tabBarController setSelectedIndex:1];
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            NSString *key = des;
            if ([key isEqualToString:@"待派工"]) {
                key = @"待指派";
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kYJYWorkBenchChangeOrderListNotification object:key userInfo:nil];
        });
        
    }

   
}

- (void)toHGWithNativeURL:(NSString *)nativeURL {
    
    if ([nativeURL isEqualToString:@"yjy://indexHuGong/myAgencyOpenService"]) {
        //待开启服务
        
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        vc.index = YJYCalendarTypeOpenOrder;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexHuGong/myAgencyToDayService"]) {
        
        //护工的我的待办模块的今日服务
        
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        vc.index = YJYCalendarTypeComfireOrder;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexHuGong/commonToolsMySchedule"]) {
        
        //我的日程
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)toNurseWithNativeURL:(NSString *)nativeURL {
    
    if ([nativeURL isEqualToString:@"yjy://indexNurse/myAgencyToBeAccepted"]) {
        //待初评
        
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        vc.index = YJYInsureTypeStateFirstReview;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/myAgencyOnSiteEvaluation"]) {
        
        //现场评估指派
        
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        vc.index = YJYInsureTypeStateReReviewing;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/myAgencyOpenService"]) {
        //服务指派
        
        [self.tabBarController setSelectedIndex:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             NSString *desc = @"待服务";
            [[NSNotificationCenter defaultCenter]postNotificationName:kYJYWorkBenchChangeOrderListNotification object:desc userInfo:nil];
            
        });
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/myAgencyReturnToVisit"]) {
        //待回访
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        vc.index = YJYCalendarTypeServiceBack;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/myAgencyFastOverdueCarePlan"]) {
        
        //快过期照护计划
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        vc.index = YJYCalendarTypeCarePlan;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/commonToolsMySchedule"]) {
        //我的日程
        
        YJYCalendarsController *vc = [YJYCalendarsController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/commonToolsAssessment"]) {
        //我的评估
        
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurse/insureOrderVisitList"]) {
        //待回访列表
        YJYWaitVisitOrderController *vc = [YJYWaitVisitOrderController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)toNurseLeaderWithNativeURL:(NSString *)nativeURL {
    
    if ([nativeURL isEqualToString:@"yjy://indexNurseBoss/myAgencyInitialAssignment"]) {
        //护士长的我的待办模块的初评指派
        
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        vc.index = YJYInsureTypeStateFirstReview;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurseBoss/myAgencyFieldAssessmentAssignment"]) {
        
        //现场评估指派
        
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        vc.index = YJYInsureTypeStateReReviewing;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurseBoss/myAgencyServiceAssignment"]) {
        //服务指派
        
        [self.tabBarController setSelectedIndex:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *desc = @"待指派";
            [[NSNotificationCenter defaultCenter]postNotificationName:kYJYWorkBenchChangeOrderListNotification object:desc userInfo:nil];
            
        });
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurseBoss/myAgencyAuditedCarePlan"]) {
        //待审核照护计划
        YJYInsureCarePlanController *vc = [YJYInsureCarePlanController instanceWithStoryBoard];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurseBoss/commonToolsChInsuranceAssessment"]) {
        
        //长护险评估
        YJYInsureManagerController *vc = [YJYInsureManagerController instanceWithStoryBoard];
        vc.index = YJYInsureTypeStateAll;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([nativeURL isEqualToString:@"yjy://indexNurseBoss/commonToolsMyNurses"]) {
        //我的护士
        
        YJYNurseWorkerController *vc = [YJYNurseWorkerController instanceWithStoryBoard];
        vc.nurseWorkType = YJYNurseWorkTypeNurse;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat height = 65;
    NSInteger arrayCount = 0;
    
    if (indexPath.row == YJYOfflineWorkbenchCellTypeServeData ||
        indexPath.row == YJYOfflineWorkbenchCellTypeMyTodo ||
        indexPath.row == YJYOfflineWorkbenchCellTypeCommonTool ) {
        
        
        if (indexPath.row == YJYOfflineWorkbenchCellTypeServeData) {
            
            arrayCount =  self.rsp.serviceDataListArray.count;
            height = 70;
            
        }else if (indexPath.row == YJYOfflineWorkbenchCellTypeMyTodo) {
            arrayCount =  self.rsp.backlogListArray.count;
            height = 100;
            
            
        }else if (indexPath.row == YJYOfflineWorkbenchCellTypeCommonTool) {
            
            arrayCount =  self.rsp.toolsArray.count;
            height = 120;
        }
        
        //cal
        NSInteger rows = arrayCount/3+1;
        rows = (arrayCount%3 == 0) ? rows - 1 : rows;
        
        return rows * height + 40;
        
    }else {
        
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    
}


#pragma mark - Action

- (IBAction)toScanAction:(id)sender {
    
    
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

- (IBAction)toMsg:(id)sender {
    
    YJYNotificationController *vc = [YJYNotificationController instanceWithStoryBoard];
    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end




