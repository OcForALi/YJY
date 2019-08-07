//
//  YJYBookBranchController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYBookBranchController.h"
#import "YJYBranchNewServiceController.h"
#import "YJYNearHospitalController.h"

#pragma mark - YJYBookBranchCell

@interface YJYBookBranchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (strong, nonatomic) BranchModel *branch;
//@property (assign, nonatomic) BOOL allowMultiSelected;

@end

@implementation YJYBookBranchCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.checkImageView.hidden = !selected;
}

- (void)setBranch:(BranchModel *)branch {
    
    _branch = branch;
    self.titleLabel.text = branch.branchName;
}


@end


#pragma mark - YJYBookBranchContentController

@interface YJYBookBranchContentController : YJYTableViewController


@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;
@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (strong, nonatomic) NSMutableArray *currentBranchListArray;
@property (copy, nonatomic) YJYBookBranchDidSelectBlock didSelectBlock;

@property (copy, nonatomic) NSString *orderId;
@property (nonatomic, readwrite) uint64_t orgId;
@property (assign, nonatomic) BOOL isTranfer;


@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) BOOL allowMultiSelected;
@property (strong, nonatomic) GPBUInt64Array *branchIdArray;
@property (strong, nonatomic) NSArray *selectedBranchArray;

@end

@implementation YJYBookBranchContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentBranchListArray = [NSMutableArray array];
    self.tableView.allowsMultipleSelection = self.allowMultiSelected;
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    [self.hospitalButton setTitle:self.currentOrg.orgVo.orgName forState:0];
    [self loadNetworkData];
   
}



- (void)loadNetworkData {
    
    
    [SYProgressHUD show];
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    if (self.isTranfer) {
        req.isAll = YES;
        req.orgId = self.orgId;
    }
    
    if (self.type > 0) {
        req.type = (uint32_t)self.type;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        if (self.currentOrg.orgVo.orgName.length == 0) {
            self.currentOrg = rsp.orgListArray.firstObject;

        }
        
        if (self.currentOrg.orgVo.orgId) {
            [self.hospitalButton setTitle:self.currentOrg.orgVo.orgName forState:0];
            [self.hospitalButton sizeToFit];
            [self.hospitalButton.titleLabel sizeToFit];
            [self loadBranchData];
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
    
    
    
}
- (void)loadBranchData {
    
    
    [SYProgressHUD show];
    
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    if (self.isTranfer) {
        req.isAll = YES;
        req.orgId =  self.currentOrg.orgVo.orgId;
    }else {
        req.orgId = self.currentOrg.orgVo.orgId;
        req.isAll = NO;
    }
    
    if (self.type > 0) {
        req.type = (uint32_t)self.type;
    }


    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        self.currentBranchListArray = [[rsp.map objectForKey:self.currentOrg.orgVo.orgId] branchListArray];
        
        [self reloadAllData];
        
       
        
        if (self.selectedBranchArray) {
            for (NSInteger i = 0; i < self.currentBranchListArray.count; i++) {
                BranchModel *branch = self.currentBranchListArray[i];
                if ([self.selectedBranchArray containsObject:@(branch.id_p)]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
            }
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
    
}


#pragma mark - Data

- (void)setupOrg {
    
    [self.hospitalButton setTitle:self.currentOrg.orgVo.orgName forState:0];
}

#pragma mark - Action

- (IBAction)changeHospitalAction:(id)sender {
    
    if (self.type > 0) {
        return;
    }
    
    YJYNearHospitalController *vc = [YJYNearHospitalController instanceWithStoryBoard];
    vc.nearHospitalDidSelectBlock = ^(OrgDistanceModel *org) {
        self.currentOrg = org;
        [self.hospitalButton setTitle:self.currentOrg.orgVo.orgName forState:0];
        [self loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)comfireAction:(id)sender {
    
    
}

#pragma mark - UITableView
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentBranchListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYBookBranchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYBookBranchCell"];
    
    BranchModel *branch = self.currentBranchListArray[indexPath.row];
    cell.branch = branch;
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end


#pragma mark - YJYBookBranchController

@interface YJYBookBranchController ()

@property (strong, nonatomic) YJYBookBranchContentController *contentVC;

@end

@implementation YJYBookBranchController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBookBranchController *)[UIStoryboard storyboardWithName:@"YJYBook" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYBookBranchContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.currentOrg = self.currentOrg;
        
        self.contentVC.orgId = self.orgId;
        self.contentVC.orderId = self.orderId;
        self.contentVC.isTranfer = self.isTranfer;
        
        self.contentVC.type = self.type;
        self.contentVC.allowMultiSelected = self.allowMultiSelected;
        self.contentVC.selectedBranchArray = self.selectedBranchArray;
        self.contentVC.branchIdArray = self.branchIdArray;

      
        
    }
}

- (IBAction)comfireAction:(id)sender {
    
    if (!self.contentVC.tableView.indexPathForSelectedRow) {
        [SYProgressHUD showFailureText:@"请选择科室"];
        return;
    }
    
    
    //多选
    if (self.allowMultiSelected) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.contentVC.tableView.indexPathsForSelectedRows) {
            BranchModel *aBranch = self.contentVC.currentBranchListArray[indexPath.row];
            [arrM addObject:aBranch];
           
        }
        
        if (self.didMultiSelectBlock) {
            self.didMultiSelectBlock(self.contentVC.currentOrg, arrM);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //单选
    BranchModel *branch = self.contentVC.currentBranchListArray[self.contentVC.tableView.indexPathForSelectedRow.row];
    
    if (self.isTranfer) {
        
        
        YJYBranchNewServiceController *vc = [YJYBranchNewServiceController instanceWithStoryBoard];
        vc.branchId = branch.id_p;
        vc.orderId = self.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        if (self.didSelectBlock) {
            self.didSelectBlock(self.contentVC.currentOrg, branch);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    
}

@end
