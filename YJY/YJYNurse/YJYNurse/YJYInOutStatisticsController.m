//
//  YJYInOutStatisticsController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/5/25.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInOutStatisticsController.h"
#import "YJYStatisticsOrderController.h"
#import "YJYBookBranchController.h"


@interface YJYInOutStatisticsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (strong, nonatomic) UserSituationVO *userSituationVO;
@end

@implementation YJYInOutStatisticsCell

- (void)setUserSituationVO:(UserSituationVO *)userSituationVO {
    /// 操作类型 1-出院 2-入院 3-未下单

    _userSituationVO = userSituationVO;
    self.titleLabel.text = [NSString stringWithFormat:@"%@人",@(userSituationVO.number)];
    self.desLabel.text = userSituationVO.title;
}
@end

@interface YJYInOutStatisticsController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;

//data
@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (strong, nonatomic) NSMutableArray <BranchModel *> *branchList;
@property (strong, nonatomic) GPBUInt64Array *branchIdArray;
@property (strong, nonatomic) NSString *currentDate;

@property (strong, nonatomic) NSMutableArray<UserSituationVO*> *voArray;
@end

@implementation YJYInOutStatisticsController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYStatistics" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voArray = [NSMutableArray array];
    self.branchList = [NSMutableArray array];

    self.currentDate = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    self.dateLabel.text = self.currentDate;
    
    [self getOrgAndBranchList];
    
    
}
- (void)getOrgAndBranchList {
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    req.type = 1;
    

    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        self.currentOrg = rsp.orgListArray.firstObject;
        [self loadBranchData];
        
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)loadBranchData {
    
    
    [SYProgressHUD show];
    
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    req.orgId = self.currentOrg.orgVo.orgId;
    req.type = 1;
    req.isAll = YES;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        BranchModel *currentBranchModel = [[[rsp.map objectForKey:self.currentOrg.orgVo.orgId] branchListArray] firstObject];
        if (currentBranchModel) {
            self.branchList = [NSMutableArray arrayWithArray:@[currentBranchModel]];
            self.branchIdArray = [GPBUInt64Array array];
            for (BranchModel *branch in self.branchList) {
                
                [self.branchIdArray addValue:branch.id_p];
            }
            
            self.branchLabel.text = currentBranchModel.branchName;
            
            
            [self getUserSituation];
        }else {
            
            [SYProgressHUD hide];

        }
        

        
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)getUserSituation {
    
    GetUserSituationReq *req = [GetUserSituationReq new];
    req.startDate = self.currentDate;
    
    self.branchIdArray = [GPBUInt64Array array];
    for (BranchModel *branch in self.branchList) {
        
        [self.branchIdArray addValue:branch.id_p];
    }
    req.branchIdArray = self.branchIdArray;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserSituation message:req controller:self command:APP_COMMAND_SaasappgetUserSituation success:^(id response) {
        GetUserSituationRsp *rsp = [GetUserSituationRsp parseFromData:response error:nil];
        self.voArray = rsp.voArray;
        [self reloadAllData];
        [self.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section    {
    
    return self.voArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YJYInOutStatisticsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YJYInOutStatisticsCell" forIndexPath:indexPath];
    cell.userSituationVO = self.voArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserSituationVO *userSituationVO = self.voArray[indexPath.row];
    
    /// 操作类型 1-出院 2-入院 3-未下单 4-转科
    
    YJYStatisticsOrderController *vc = [YJYStatisticsOrderController instanceWithStoryBoard];
    vc.type = userSituationVO.type;
    vc.branchIdArray = self.branchIdArray;
    vc.currentDate = self.currentDate;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 1) {
        
        NSInteger lines = self.voArray.count / 2 + self.voArray.count % 2;
        NSInteger sLines = (lines < 1) ? (lines + 1) : lines ;
        return sLines * 160 + 30;
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    
}
#pragma mark - Action

- (IBAction)toBranch:(id)sender {
    
    
    YJYBookBranchController *vc = [YJYBookBranchController instanceWithStoryBoard];
    vc.currentOrg = self.currentOrg;
    vc.allowMultiSelected = YES;
    vc.type = 1;
    vc.branchIdArray = self.branchIdArray;
    
    NSMutableArray *ids = [NSMutableArray array];
    [self.branchIdArray enumerateValuesWithBlock:^(uint64_t value, NSUInteger idx, BOOL *stop) {
        [ids addObject:@(value)];
    }];
    vc.selectedBranchArray = ids;

    vc.didMultiSelectBlock = ^(OrgDistanceModel *org, NSArray<BranchModel *> *branchs) {
        
        self.branchList = [NSMutableArray arrayWithArray:branchs];
        NSMutableString *stringM = [NSMutableString string];
        for (BranchModel *branch in self.branchList) {
            
            [stringM appendFormat:@"%@ ",branch.branchName];
        }
        self.branchLabel.text = stringM;
        [self getUserSituation];

    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toChooseDate:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
    picker.didSelectDate = ^(NSDate *date) {
        self.currentDate = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
        self.dateLabel.text = self.currentDate;
        [self getUserSituation];
    };
    [picker setDate:[NSDate dateString:self.dateLabel.text Format:YYYY_MM_DD]];
    [picker show];
}
- (IBAction)toRefresh:(id)sender {
    
    [self getUserSituation];
}

@end
