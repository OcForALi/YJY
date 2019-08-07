//
//  YJYStatisticsOrderController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/5/25.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYStatisticsOrderController.h"
#import "YJYActionSheet.h"
/// 状态 1-空 2-未下单 3-已下单 4-已取消 5-已结清

typedef NS_ENUM(NSInteger, YJYStatisticsStatus) {
    
    YJYStatisticsStatusEmpty = 1,
    YJYStatisticsStatusNoOrder,
    YJYStatisticsStatusOrdered,
    YJYStatisticsStatusCanceled,
    YJYStatisticsStatusPaid
};

/// 操作类型 1-出院 2-入院 3-未下单 4-转科


typedef NS_ENUM(NSInteger, YJYStatisticsActionType) {
    
    YJYStatisticsActionTypeOut = 1,
    YJYStatisticsActionTypeIn,
    YJYStatisticsActionTypeNoOrder,
    YJYStatisticsActionTypeTransfer

};

typedef void(^YJYStatisticsOrderCellDidAction)();

@interface YJYStatisticsOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeTipLabek;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (strong, nonatomic) UserSituationListVO *userSituationListVO;
@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) YJYStatisticsOrderCellDidAction didAction;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthConstraint;


@end

@implementation YJYStatisticsOrderCell

- (void)setUserSituationListVO:(UserSituationListVO *)userSituationListVO {
         
    
    _userSituationListVO = userSituationListVO;
    self.nameLabel.text = userSituationListVO.patientName;
    self.branchLabel.text = [NSString stringWithFormat:@"%@%@   ",userSituationListVO.bedNo.length > 0 ? @"  ":@"",userSituationListVO.bedNo];
    

    self.timeLabel.text = userSituationListVO.admissionTimeStr;
    
    NSString *imageName = @"";
    if (userSituationListVO.status == YJYStatisticsStatusNoOrder) {
        
        imageName = @"statistic_icon_noorder";
        
    }else if (userSituationListVO.status == YJYStatisticsStatusOrdered) {
        imageName = @"statistic_icon_ordered";

    }else if (userSituationListVO.status == YJYStatisticsStatusCanceled) {
        imageName = @"statistic_icon_cancel";
        
    }else if (userSituationListVO.status == YJYStatisticsStatusPaid) {
        imageName = @"statistic_icon_paid";
        
    }
    self.stateImageView.image = [UIImage imageNamed:imageName];
    
    /// 状态 1-空 2-未下单 3-已下单 4-已取消 5-已结清

    self.actionButton.hidden = NO;
    if (userSituationListVO.status == 2) {
        [self.actionButton setTitle:@"改为已下单" forState:0];
    }else if (userSituationListVO.status == 3) {
        [self.actionButton setTitle:@"已下单" forState:0];

    }else {
        self.actionButton.hidden = YES;
    }
    
    self.desLabel.text = [NSString stringWithFormat:@"%@ 转至 %@",userSituationListVO.branchName,userSituationListVO.newBranchName];
    self.titleWidthConstraint.constant = userSituationListVO.bedNo.length == 0 ? 0 : self.titleWidthConstraint.constant;


}

- (void)setType:(NSInteger)type {
    
    _type = type;
    
    if (type == YJYStatisticsActionTypeOut) {
        
        self.timeTipLabek.text = @"预出院日期";
        
    }else if (type == YJYStatisticsActionTypeIn) {
        
        self.timeTipLabek.text = @"入院时间";
        
    }else if (type == YJYStatisticsActionTypeNoOrder) {
        
        self.timeTipLabek.text = @"入院日期";
        
    }else if (type == YJYStatisticsActionTypeTransfer) {
        
        self.timeTipLabek.text = @"转科时间";
//        如果是转科，1-未转科 2-已转科
        self.stateImageView.hidden = self.userSituationListVO.status == 1;
        self.actionButton.hidden = YES;

         if (self.userSituationListVO.status == 2) {
             self.stateImageView.image = [UIImage imageNamed:@"statistic_icon_transfered"];

         }
    }
    
}

- (IBAction)toChange:(id)sender {
    if (self.didAction) {
        self.didAction();
    }
}
@end


#pragma mark - YJYStatisticsOrderController

@interface YJYStatisticsOrderController ()
@property (assign, nonatomic) uint32_t pageNo;
@property (assign, nonatomic) uint32_t sortType;

@property (nonatomic, strong) NSMutableArray<UserSituationListVO*> *voListArray;

//right view
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *sortNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@end

@implementation YJYStatisticsOrderController
+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYStatistics" viewControllerIdentifier:className];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    /// 操作类型 1-出院 2-入院 3-未下单

    if (self.type == YJYStatisticsActionTypeOut) {
        
        self.title = @"预出院列表";
        
    }else if (self.type == YJYStatisticsActionTypeIn) {
        
        self.title = @"入院列表";

    }else if (self.type == YJYStatisticsActionTypeNoOrder) {
        
        self.title = @"未下单累计";
        
    }else if (self.type == YJYStatisticsActionTypeTransfer) {
        
        self.title = @"转科列表";
        
    }
    
    self.voListArray = [NSMutableArray array];
        
    __weak __typeof(self)weakSelf = self;
    self.pageNo = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNo = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNo ++;
        [weakSelf loadNetworkData];
    }];
    
    [SYProgressHUD show];
    [self loadNetworkData];
}

- (void)loadNetworkData {
    /// 排序规则 0-时间 1-床号

    GetUserSituationListReq* req = [GetUserSituationListReq new];
    req.pageNo = self.pageNo;
    req.pageSize = 20;
    req.branchIdArray = self.branchIdArray;
    req.startDate = self.currentDate;
    req.type = self.type;
    req.sortType = self.sortType;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserSituationList message:req controller:self command:APP_COMMAND_SaasappgetUserSituationList success:^(id response) {
        
        
        GetUserSituationListRsp *rsp = [GetUserSituationListRsp parseFromData:response error:nil];
        
        if (self.pageNo > 1) {
            
            if (rsp.voListArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.voListArray addObjectsFromArray:rsp.voListArray];
                
            }
            
        }else {
            self.voListArray = rsp.voListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.voListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYStatisticsOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYStatisticsOrderCell"];
    UserSituationListVO *userSituationListVO = self.voListArray[indexPath.row];
    cell.userSituationListVO = userSituationListVO;
    cell.type = self.type;
    cell.didAction = ^{
        
        
        [self toChangeWithUserSituationListVO:userSituationListVO];
    };
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 160;
}

- (void)toChangeWithUserSituationListVO:(UserSituationListVO *)userSituationListVO {
    
    if (userSituationListVO.notOrderUpdateStatus && userSituationListVO.status == 2) {
        [UIAlertController showAlertInViewController:self withTitle:@"是否改为已下单" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [SYProgressHUD show];
                UpdateUserSitutionReq *req = [UpdateUserSitutionReq new];
                req.orgNo = userSituationListVO.orgNo;
                
                [YJYNetworkManager requestWithUrlString:SAASAPPUpdateUserSitution message:req controller:self command:APP_COMMAND_SaasappupdateUserSitution success:^(id response) {
                    [SYProgressHUD hide];
                    [self loadNetworkData];

                } failure:^(NSError *error) {
                    
                }];
            }
            
        }];
    }
   
}
#pragma mark - Action

- (IBAction)toSort:(id)sender {
    
    self.arrowImageView.image = [UIImage imageNamed:@"app_green_up_icon"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"转科时间",@"床号"]];
    YJYActionSheet *sheet = [YJYActionSheet instancetypeWithXIBWithDatasource:arr withTitle:nil];
    sheet.didComfireBlock = ^(id result) {
        
        
        self.arrowImageView.image = [UIImage imageNamed:@"app_green_down_icon"];
        self.sortType = [(NSString *)result isEqualToString:@"转科时间"] ? 0 : 1;
        self.sortNameLabel.text = result;
        [self loadNetworkData];
    };
    sheet.didDismissBlock = ^{
        
        self.arrowImageView.image = [UIImage imageNamed:@"app_green_down_icon"];
    };
    [sheet showInView:nil];
    
}
@end
