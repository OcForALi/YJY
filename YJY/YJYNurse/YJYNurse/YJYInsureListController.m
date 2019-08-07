 //
//  YJYInsureListController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/11/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureListController.h"
#import "YJYInsureDetailController.h"

typedef void(^YJYInsureListItemCellDidSelectNurseBlock)(UIButton *nurseButton);

@interface YJYInsureListItemCell : UITableViewCell<MDHTMLLabelDelegate>


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nurseStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nurseTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyStateButton;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;


//data
@property (strong, nonatomic) InsureFirmVO *insureVO;
@property (strong, nonatomic) InsureListVO *insureListVO;
@property (copy, nonatomic) YJYInsureListItemCellDidSelectNurseBlock didSelectNurseBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHConstraint;

@end

@implementation YJYInsureListItemCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contactLabel.delegate = self;
}
- (void)setInsureListVO:(InsureListVO *)insureListVO {
    
    _insureListVO = insureListVO;
    InsureListVO *insureVO = insureListVO;
    
    self.nameLabel.text = insureVO.kinsName;
    self.idLabel.text = insureVO.idcard;
    self.numberLabel.text = insureVO.insureNo;
    self.addressLabel.text = insureVO.addrDetail;
    
    
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:insureVO.contactName phone:insureVO.contactPhone];
    //address
    
    CGSize size = [insureVO.addrDetail boundingRectWithSize:CGSizeMake(self.frame.size.width - 85, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    double height = ceil(size.height) - 17;
    self.addressHConstraint.constant = 35 + height;
    
    self.nurseStateLabel.text = insureVO.statusStr;
    
    
    
    
    [self.applyStateButton setTitle:[NSString stringWithFormat:@"申请进度：%@",insureVO.statusStr] forState:0];
    
    /// 状态  0-客服审核 1-护士初审 2-等待提交复审 3-等待复审 4-复审通过 5-复审中  50-客服驳回 51-初审驳回 52-复审驳回 53-已关闭
    
    self.stateButton.hidden = YES;
    
    
    if ((insureVO.status == 1 || insureVO.status == 5) &&
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        self.stateButton.hidden = NO;
        [self.stateButton setTitle:insureVO.orderStatus== 0 ? @"未指派" : @"已指派" forState:0];
        self.stateButton.backgroundColor = insureVO.orderStatus == 0 ? APPREDCOLOR : APPHEXCOLOR;
        
    }else {
        
        self.stateButton.hidden = YES;
        [self.stateButton setTitle:@"" forState:0];
    }
    
    
    
    [self layoutIfNeeded];
    
}
- (void)setInsureVO:(InsureFirmVO *)insureVO {
    
    _insureVO = insureVO;
    
    self.nameLabel.text = insureVO.insureNo.kinsName;
    self.idLabel.text = insureVO.insureNo.idcard;
    self.numberLabel.text = insureVO.insureNo.insureNo;
    self.addressLabel.text = insureVO.addrInfo;
    
    
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:insureVO.insureNo.name phone:insureVO.insureNo.phone];
    //address
    
    CGSize size = [insureVO.addrInfo boundingRectWithSize:CGSizeMake(self.frame.size.width - 85, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    double height = ceil(size.height) - 17;
    self.addressHConstraint.constant = 35 + height;
    
    self.nurseTimeLabel.text = insureVO.statusTime;
    self.nurseStateLabel.text = insureVO.statusTimeStr;

    

    
    [self.applyStateButton setTitle:[NSString stringWithFormat:@"申请进度：%@",insureVO.statusStr] forState:0];
    
    /// 状态  0-客服审核 1-护士初审 2-等待提交复审 3-等待复审 4-复审通过 5-复审中  50-客服驳回 51-初审驳回 52-复审驳回 53-已关闭
    
    self.stateButton.hidden = YES;


    if ((insureVO.status == 1 || insureVO.status == 5) &&
        [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
    
        self.stateButton.hidden = NO;
        [self.stateButton setTitle:insureVO.assignStatus == 0 ? @"未指派" : @"已指派" forState:0];
        self.stateButton.backgroundColor = insureVO.assignStatus == 0 ? APPREDCOLOR : APPHEXCOLOR;
        
    }else {
        
        self.stateButton.hidden = YES;
        [self.stateButton setTitle:@"" forState:0];
    }
    
    
    
    [self layoutIfNeeded];

}

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}
@end


@interface YJYInsureListController ()

@property (assign, nonatomic) uint32_t pageNum;
@property (copy, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSMutableArray *insureFirmVoArray;
@end

@implementation YJYInsureListController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureListController *)[UIStoryboard storyboardWithName:@"YJYInsureManager" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.insureFirmVoArray = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    self.pageNum = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    [SYProgressHUD show];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSearchData:) name:kYJYAssessUpdateNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self loadNetworkData];
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)reloadSearchData:(NSNotification *)nofi {
    
    NSString *searchText = nofi.object;
    self.searchText = searchText;
    self.pageNum = 1;
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        
        [self loadNetworkDataZZWithSearchText:searchText];

    }else {
        [self loadNetworkDataWithSearchText:searchText];
    }
    
    
    
}
- (void)loadNetworkDataZZWithSearchText:(NSString *)searchText{

    GetInsureRecheckListReq *req = [GetInsureRecheckListReq new];
    req.orderStatus = self.listItem.type;
    req.pageNo = self.pageNum;
    req.pageSize = 20;

    if (searchText) {
        req.keyword = searchText;
    }
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureRecheckList message:req controller:self command:APP_COMMAND_SaasappgetInsureRecheckList success:^(id response) {
        
        
        GetInsureRecheckListRsp *rsp = [GetInsureRecheckListRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.insureFirmVoArray.count >= rsp.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.insureFirmVoArray addObjectsFromArray:rsp.voListArray];
                
            }
            
        }else {
            self.insureFirmVoArray = rsp.voListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
//
}
- (void)loadNetworkDataWithSearchText:(NSString *)searchText{
    
    GetInsureListReq*req = [GetInsureListReq new];
    req.pageNum = self.pageNum;
    req.pageSize = 20;
    req.status = self.listItem.type;
    if (searchText) {
        req.insureId = searchText;
    }
    
    NSString *urlstring = SAASAPPGetInsureList;
    APP_COMMAND command  = APP_COMMAND_SaasappgetInsureList;
    
    [YJYNetworkManager requestWithUrlString:urlstring message:req controller:nil command:command success:^(id response) {
        
        
        GetInsureListFirmRsp *rsp = [GetInsureListFirmRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.insureFirmVoArray.count >= rsp.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.insureFirmVoArray addObjectsFromArray:rsp.insureFirmVoArray];
                
            }
            
        }else {
            self.insureFirmVoArray = rsp.insureFirmVoArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

- (void)loadNetworkData {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        
        [self loadNetworkDataZZWithSearchText:nil];
        
    }else {
        [self loadNetworkDataWithSearchText:nil];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.insureFirmVoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *Identifier = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager ? @"YJYInsureListItemCell":@"YJYInsureListItemCellNurse";
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        Identifier = @"YJYInsureListItemCell";
    }
    
    YJYInsureListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
    
            cell.insureListVO = self.insureFirmVoArray[indexPath.row];
    }else {
        
            cell.insureVO = self.insureFirmVoArray[indexPath.row];
    }
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        
        InsureListVO *insureVO = self.insureFirmVoArray[indexPath.row];
        
        
        CGSize size = [insureVO.addrDetail boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 85, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        double height = ceil(size.height) - 17;
        
        CGFloat cellHeight = 290;
        return cellHeight +  height;
        
    }else{
        
        InsureFirmVO *insureVO = self.insureFirmVoArray[indexPath.row];
        
        
        CGSize size = [insureVO.addrInfo boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 85, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        double height = ceil(size.height) - 17;
        
        CGFloat cellHeight = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager ? 290 :250;
        return cellHeight +  height;
        
    }
    
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureDetailController *vc = [YJYInsureDetailController instanceWithStoryBoard];
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeCustomManager) {
        
        InsureListVO *insureVO = self.insureFirmVoArray[indexPath.row];
        vc.insureNo = insureVO.insureNo;
        vc.didDismissBlock = ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        InsureFirmVO *insureVO = self.insureFirmVoArray[indexPath.row];
        vc.insureNo = insureVO.insureNo.insureNo;
        vc.didDismissBlock = ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


@end
