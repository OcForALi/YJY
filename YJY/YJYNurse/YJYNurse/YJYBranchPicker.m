//
//  YJYBranchPicker.m
//  YJYNurse
//
//  Created by wusonghe on 2018/6/21.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYBranchPicker.h"
#import "YJYBranchPickerCell.h"
#import "YJYOrgPickerCell.h"



#define ZXHScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZXHScreenWidth [UIScreen mainScreen].bounds.size.width

@interface YJYBranchPicker () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;


//@property (strong, nonatomic) GPBUInt64ObjectDictionary<BranchModelList*> *orgBranchmap;
@property (nonatomic, strong) NSMutableArray *currentOrgListArray;
@property (nonatomic, strong) NSMutableArray *currentBranchListArray;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayoutConstraint;

@property (nonatomic, readwrite) uint64_t orgId;
@property (copy, nonatomic) NSString *orderId;

@end

@implementation YJYBranchPicker

+ (instancetype)instancetypeWithXIB {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"YJYOrgPickerCell" bundle:nil] forCellReuseIdentifier:@"YJYOrgPickerCell"];
    
    [self.rightTableView registerNib:[UINib nibWithNibName:@"YJYBranchPickerCell" bundle:nil] forCellReuseIdentifier:@"YJYBranchPickerCell"];
    
    
    self.currentOrgListArray = [NSMutableArray array];
    self.currentBranchListArray = [NSMutableArray array];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [self.bgView addGestureRecognizer:tap];
    
    
    self.leftTableView.mj_insetT = 6;
    self.leftTableView.mj_insetB = 6;
    
    [self loadNetworkData];
    
//    if (self.currentOrg && self.currentBranch) {
//        [self selectTheLast];
//    }else {
//        
//        
//    }
    
    
    
}

- (void)loadNetworkData {
    
    
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    req.isAll = NO;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        [SYProgressHUD hide];

        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        if (rsp.orgListArray.count <= 1) {
            self.rightLayoutConstraint.constant = 0;
        }else {
            self.rightLayoutConstraint.constant = 190;
            OrgDistanceModel *allOrgDistanceModel = [OrgDistanceModel new];
            OrgVO *orgVO = [OrgVO new];
            orgVO.orgName = @"全部医院";
            allOrgDistanceModel.orgVo = orgVO;
            [rsp.orgListArray insertObject:allOrgDistanceModel atIndex:0];
        }
        
       
        
        
        self.currentOrgListArray = rsp.orgListArray;
        if (!self.currentOrg) {
            self.currentOrg = rsp.orgListArray.firstObject;

        }
        
        
        [self.leftTableView reloadData];
        
     

        [self loadBranchData];

    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"加载失败"];

    }];
    
    
    
}
- (void)loadBranchData {
    
    
    [SYProgressHUD showToLoadingView:self];
    
    
    GetOrgAndBranchReq *req = [GetOrgAndBranchReq new];
    req.isAll = NO;
    
    if (self.currentOrg.orgVo.orgId) {
        req.orgId =  self.currentOrg.orgVo.orgId;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranchNew message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranchNew success:^(id response) {
        
        [SYProgressHUD hideToLoadingView:self];
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        
        self.currentBranchListArray = [[rsp.map objectForKey:self.currentOrg.orgVo.orgId] branchListArray];
        
        if (self.currentBranchListArray.count == 0) {
            self.currentBranchListArray  = [NSMutableArray array];
            
        }
        
        BranchModel *allBranchModel = [BranchModel new];
        allBranchModel.branchName = @"全部科室";
        [self.currentBranchListArray insertObject:allBranchModel atIndex:0];
        
        if (self.currentBranchListArray.count == 1) {
            self.currentBranch = allBranchModel;
        }
        
        [self.rightTableView reloadData];
        [self selectTheLast];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)selectTheLast {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < self.currentOrgListArray.count; i++) {
            OrgDistanceModel *org = self.currentOrgListArray[i];
            if (org.orgVo.orgId == self.currentOrg.orgVo.orgId) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.leftTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];

            }
        }
        
        for (NSInteger i = 0; i < self.currentBranchListArray.count; i++) {
            BranchModel *branchModel = self.currentBranchListArray[i];
            if (branchModel.id_p == self.currentBranch.id_p) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.rightTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                [self.rightTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];

            }
        }
    });
    
    
}



#pragma mark - UITableViewDelegate && UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        return self.currentOrgListArray.count;
    }else {
        return self.currentBranchListArray.count;

    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        YJYOrgPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrgPickerCell"];
        OrgDistanceModel *orgDistanceModel = self.currentOrgListArray[indexPath.row];
        cell.orgDistanceModel = orgDistanceModel;
        return cell;
        
    }else {
        
        YJYBranchPickerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYBranchPickerCell"];
        
        BranchModel *branch = self.currentBranchListArray[indexPath.row];
        cell.branch = branch;
          
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        OrgDistanceModel *orgDistanceModel = self.currentOrgListArray[indexPath.row];
        self.currentOrg = orgDistanceModel;
        [self loadBranchData];
        
        
    }else {
        
        BranchModel *branch = self.currentBranchListArray[indexPath.row];
        self.currentBranch = branch;

        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 55;
}

#pragma mark - show & hide
#define kActionViewHeight 400
- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.5);
    self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
   
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
        if (self.didCancelBlock) {
            self.didCancelBlock();
        }
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
- (IBAction)closeAction:(id)sender {
    
    [self hidden];
}
- (IBAction)confirmAction:(id)sender {
  
    
    if (self.didDoneBlock) {
        BOOL isSingle = self.currentOrgListArray.count <= 1;
        self.didDoneBlock(self.currentOrg, self.currentBranch ,isSingle);
        [self hidden];

      
    }
}

@end
