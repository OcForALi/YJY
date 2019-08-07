//
//  YJYOrderBedController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/5.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderBedController.h"


@interface YJYOrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation YJYOrderItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    self.titleLab.textColor = selected ? APPHEXCOLOR : APPDarkGrayCOLOR;
}
//[UIColor colorWithHexString:@"#F1F1F1"]
@end


typedef NS_ENUM(NSInteger, YJYOrderOption) {
    
    YJYOrderOptionBranch = 11,
    YJYOrderOptionRoom = 22,
    YJYOrderOptionBed = 33,

};

@interface YJYOrderBedController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;
@property (strong, nonatomic) IBOutlet  UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *branchButton;

@property (weak, nonatomic) IBOutlet UITableView *branchTableView;
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property (weak, nonatomic) IBOutlet UITableView *badTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *branchWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roomWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bedWidthConstraint;


@property (strong, nonatomic) UIButton *selectedButton;

//data
@property (strong, nonatomic) GPBUInt64ObjectDictionary<BranchModelList*> *orgBranchmap;
@property (strong, nonatomic) NSMutableArray<BranchModel*> *currentBranchListArray;

@property (strong, nonatomic) NSMutableArray<RoomModel*> *roomListArray;
@property (strong, nonatomic) GPBUInt64ObjectDictionary<BedModelList*> *roomBedMap;


//dynamic data
@property (strong, nonatomic) NSMutableArray<BedModel*> *currentBedListArray;



@property (strong, nonatomic) BranchModel *currentBranch;

@property (strong, nonatomic) RoomModel *currentRoom;
@property (strong, nonatomic) BedModel *currentBed;
@property (strong, nonatomic) Price *currentPrice;
@property (strong, nonatomic) KinsfolkVO *currentKinsfolk;
@property (strong, nonatomic) NSDate *currentDate;


@property (strong, nonatomic) NSArray<Price*> *pList121Array;
@property (strong, nonatomic) NSArray<Price*> *pList12NArray;


@end

@implementation YJYOrderBedController

#define ONE_THREE_WIDTH (self.view.frame.size.width * 0.33)
#define ONE_TWO_WIDTH (self.view.frame.size.width * 0.33)

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderBedController *)[UIStoryboard storyboardWithName:@"YJYBook" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.branchWidthConstraint.constant = ONE_TWO_WIDTH;
    self.roomWidthConstraint.constant = 0;
    self.bedWidthConstraint.constant = 0;
    
    [self loadOrg];

}

- (void)loadOrg {
  
    
    [SYProgressHUD show];
    
    GetOrgAndBranchListReq *req = [GetOrgAndBranchListReq new];
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranch message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranch success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        self.currentOrg = rsp.orgListArray.firstObject;
        
        if (self.currentOrg.orgVo.orgId) {
            [self.hospitalButton setTitle:self.currentOrg.orgVo.orgName forState:0];
            [self.hospitalButton sizeToFit];
            [self.hospitalButton.titleLabel sizeToFit];
            [self loadBranch];
        }
        
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
    
    
    
}

- (void)loadBranch {
    
    
    [SYProgressHUD show];
    
    GetOrgAndBranchListReq *req = [GetOrgAndBranchListReq new];
    req.orgId = self.currentOrg.orgVo.orgId;

    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrgAndBranch message:req controller:nil command:APP_COMMAND_SaasappgetOrgAndBranch success:^(id response) {
        
        GetOrgAndBranchListRsp *rsp = [GetOrgAndBranchListRsp parseFromData:response error:nil];
        self.currentOrg = rsp.orgListArray.firstObject;
        self.orgBranchmap = rsp.map;
        [self reloadBranchs];
        
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
    
}

- (void)loadGetRoomAndBedWithBranchId:(uint64_t)branchId {
    
    [SYProgressHUD show];
    
    GetRoomListReq *req = [GetRoomListReq new];
    req.branchId = branchId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetRoomAndBed message:req controller:nil command:APP_COMMAND_SaasappgetRoomAndBed success:^(id response) {
        
        GetRoomListRsp *rsp = [GetRoomListRsp parseFromData:response error:nil];
        self.roomListArray = rsp.roomListArray;
        self.roomBedMap = rsp.map;
        
        [self.roomTableView reloadData];
        
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}





#pragma mark - UI Reload


- (void)reloadAllTableView {
    
    
    self.currentBranchListArray = [NSMutableArray array];
    self.roomListArray = [NSMutableArray array];
    self.currentBedListArray = [NSMutableArray array];
    
    [self.branchTableView reloadData];
    [self.roomTableView reloadData];
    [self.badTableView reloadData];
   
    [self adjuctTableViewsWithTableView:self.branchTableView];
    
    self.currentRoom = nil;
    self.currentBed = nil;
}

- (void)reloadBranchs {
    
    self.currentBranchListArray = [[self.orgBranchmap objectForKey:self.currentOrg.orgVo.orgId] branchListArray];
    
    
    [self.branchTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.currentBranchListArray.count > 0) {
            
            [self optionAction:[self.view viewWithTag:100]];
        }
    });
    
}


- (void)reloadRoomAndBed {
    
    if (!self.currentRoom) {
        self.currentRoom = self.roomListArray.firstObject;
    }
    
    self.currentBedListArray = [[self.roomBedMap objectForKey:self.currentRoom.roomId] bedListArray];
    [self.badTableView reloadData];


}


- (IBAction)optionAction:(UIButton *)sender {
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;

    
}


#pragma mark - UITableViewCell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView == self.branchTableView) {
        return self.currentBranchListArray.count;
    }else if (tableView == self.roomTableView) {
        return self.roomListArray.count;
    }else if (tableView == self.badTableView) {
        return self.currentBedListArray.count;
    }
    
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYOrderItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYOrderItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == self.branchTableView) {
        
        BranchModel *branch = self.currentBranchListArray[indexPath.row];
        if (branch.branchName.length > 0) {
            cell.titleLab.text = branch.branchName;
        }else {
            cell.titleLab.text = @"无科室";
        }
        
    }else if (tableView == self.roomTableView) {
        
        RoomModel *room = self.roomListArray[indexPath.row];
        cell.titleLab.text = room.roomNo;
        
        
    }else if (tableView == self.badTableView) {
        
        BedModel *bed = self.currentBedListArray[indexPath.row];
        cell.titleLab.text = bed.bedNo;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView != self.badTableView){
        
        UIButton *button = [self.view viewWithTag:tableView.tag / 10 + 100];
        [self optionAction:button];
        
    }
    
    if (tableView == self.branchTableView) {
        
        BranchModel *branch = self.currentBranchListArray[indexPath.row];
        self.currentBranch = branch;
        [self loadGetRoomAndBedWithBranchId:self.currentBranch.id_p];

        
        
    }else if (tableView == self.roomTableView) {
        
        RoomModel *room = self.roomListArray[indexPath.row];
        self.currentRoom = room;
        [self reloadRoomAndBed];
        
    }else if (tableView == self.badTableView) {
        
        BedModel *bed = self.currentBedListArray[indexPath.row];
        self.currentBed = bed;
    }
    [self adjuctTableViewsWithTableView:tableView];
    
}


- (void)adjuctTableViewsWithTableView:(UITableView *)tableView {

    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    
        if (tableView == self.branchTableView) {
            
            self.branchWidthConstraint.constant = ONE_TWO_WIDTH;
            self.roomWidthConstraint.constant = ONE_TWO_WIDTH;
            self.bedWidthConstraint.constant = 0;
            
        
            
            [self.roomTableView reloadData];
            [self.badTableView reloadData];
            
            self.currentBed = nil;
            self.currentRoom = nil;
            
        }else if (tableView == self.roomTableView){
            
            self.branchWidthConstraint.constant = ONE_THREE_WIDTH;
            self.roomWidthConstraint.constant = ONE_THREE_WIDTH;
            self.bedWidthConstraint.constant = ONE_THREE_WIDTH;
            
     
            
            [self.badTableView reloadData];
            self.currentBed = nil;

            
        }else if (tableView == self.badTableView){
            
            self.branchWidthConstraint.constant = ONE_THREE_WIDTH;
            self.roomWidthConstraint.constant = ONE_THREE_WIDTH;
            self.bedWidthConstraint.constant = ONE_THREE_WIDTH;
            
        }
        

        
        
    }];
    
    
    
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmAction:(id)sender {
    
    
    
    if (self.currentOrg && self.currentBranch && self.currentRoom && self.currentBed) {
        if (self.orderBedResultBlock) {
            self.orderBedResultBlock(self.currentOrg, self.currentBranch, self.currentRoom, self.currentBed);
        }
        
        if (self.isBooking) {
            NSArray *vcs = self.navigationController.viewControllers;
            [self.navigationController popToViewController:vcs[1] animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        

    }else {
        
        [SYProgressHUD showToCenterText:@"床号信息为空"];
    }

    
    
    

}

@end
