//
//  YJYBookBranchController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/5.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBookBranchController.h"
#import "YJYNearHospitalController.h"


#pragma mark - YJYBookBranchCell

@interface YJYBookBranchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (strong, nonatomic) BranchModel *branch;

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
@property (strong, nonatomic) NSMutableArray<BranchModel*> *currentBranchListArray;
@property (copy, nonatomic) YJYBookBranchDidSelectBlock didSelectBlock;

@end

@implementation YJYBookBranchContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentBranchListArray = [NSMutableArray array];
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self.hospitalButton setTitle:self.currentOrg.orgVo.orgName forState:0];
    [self loadNetworkData];
}





- (void)loadNetworkData {
    
    
    [SYProgressHUD show];
    
    GetOrgAndBranchListReq *req = [GetOrgAndBranchListReq new];
    
    req.orgId = self.currentOrg.orgVo.orgId;
    
    [YJYNetworkManager requestWithUrlString:APPGetOrgAndBranch message:req controller:nil command:APP_COMMAND_AppgetOrgAndBranch success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        self.currentBranchListArray = [[rsp.map objectForKey:self.currentOrg.orgVo.orgId] branchListArray];

        [self reloadAllData];
        
        
        
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
    
    return (YJYBookBranchController *)[UIStoryboard storyboardWithName:@"YJYBookHospital" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYBookBranchContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.currentOrg = self.currentOrg;
        
        __weak typeof(self) weakSelf = self;
        self.contentVC.didSelectBlock = ^(BranchModel *branch) {
            
            if (weakSelf.didSelectBlock) {
                weakSelf.didSelectBlock(branch);
            }
        };
    }
}

- (IBAction)comfireAction:(id)sender {
    
    if (!self.contentVC.tableView.indexPathForSelectedRow) {
        [SYProgressHUD showFailureText:@"请选择科室"];
        return;
    }
    
    BranchModel *branch = self.contentVC.currentBranchListArray[self.contentVC.tableView.indexPathForSelectedRow.row];
    
    
    if (self.didSelectBlock) {
        self.didSelectBlock(branch);
    }
    [self.navigationController popViewControllerAnimated:YES];}

@end
