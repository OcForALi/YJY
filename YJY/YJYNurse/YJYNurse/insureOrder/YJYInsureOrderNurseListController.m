//
//  YJYInsureOrderNurseListController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//




#import "YJYInsureOrderNurseListController.h"
#import "YJYInsureNurseDetailController.h"
#import "RateStarView.h"


typedef void(^YJYInsureOrderNurseListCellDidSelectBlock)();

@interface YJYInsureOrderNurseListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lansLabel;
@property (strong, nonatomic) InsureHGListVO *insureHGListVO;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIView *starContainView;
@property (strong, nonatomic) RateStarView *starView;

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (copy, nonatomic) YJYInsureOrderNurseListCellDidSelectBlock didDetailBlock;
@property (copy, nonatomic) YJYInsureOrderNurseListCellDidSelectBlock didGuideBlock;
@property (copy, nonatomic) YJYInsureOrderNurseListCellDidSelectBlock didTransferBlock;

@end

@implementation YJYInsureOrderNurseListCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.detailButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.detailButton.layer.borderWidth = 1;
    
    [self setupStarView];

}
- (void)setupStarView {
    
    self.starContainView.backgroundColor = [UIColor clearColor];
    self.starView = [[RateStarView alloc] initWithNormalImage:[UIImage imageNamed:@"insure_star_unpressed_icon"] selectedImage:[UIImage imageNamed:@"insure_star_pressed_icon"] padding:4];
    self.starView.frame = self.starContainView.bounds;
    self.starView.userInteractionEnabled = NO;
//    self.starView.center = self.starContainView.center;
    [self.starContainView addSubview:self.starView];
}


- (void)setInsureHGListVO:(InsureHGListVO *)insureHGListVO {
    
    _insureHGListVO = insureHGListVO;
    self.nameSexLabel.text = [NSString stringWithFormat:@"%@ %@",insureHGListVO.fullName,insureHGListVO.sex == 1  ? @"男" : @"女"];
    self.serverNumLabel.text = [NSString stringWithFormat:@"服务中单数：%@单",@(insureHGListVO.orderNum)];
    self.numberLabel.text = [NSString stringWithFormat:@"工号：%@",insureHGListVO.hgno];
    
    self.yearLabel.text =  [NSString stringWithFormat:@"工作:%@年",@(insureHGListVO.exp)];

    [self.avatarImageView xh_setImageWithURL:[NSURL URLWithString:insureHGListVO.picURL]];
    
    self.lansLabel.text  = [NSString stringWithFormat:@"通晓语言:%@",insureHGListVO.language.length > 0 ? insureHGListVO.language : @"无"];
    [self.starView setScore:insureHGListVO.praise];
    
    
}
- (IBAction)toDetail:(id)sender {
    
    if (self.didDetailBlock) {
        self.didDetailBlock();
    }
}
- (IBAction)toGuide:(id)sender {
    
    if (self.didGuideBlock) {
        self.didGuideBlock();
    }
}
- (IBAction)toTransfer:(id)sender {
    
    if (self.didTransferBlock) {
        self.didTransferBlock();
    }
}

@end

@interface YJYInsureOrderNurseListController ()<UISearchBarDelegate>

@property (assign, nonatomic) NSInteger pageNum;
@property (strong, nonatomic) NSMutableArray *staffListArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation YJYInsureOrderNurseListController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.isNaviError = YES;
    self.title = self.isNurse ? @"护士列表" : @"护理员列表";
    [SYProgressHUD show];
    
    
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    [SYProgressHUD show];

    self.searchBar.frame = CGRectMake(0, 0, self.searchBar.frame.size.width, 60);
    [self loadNetworkData];
}

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderNurse" viewControllerIdentifier:className];
    return vc;
}
- (void)loadNetworkDataWithSearchText:(NSString *)searchText {

    GetHomeStaffListReq  *req = [GetHomeStaffListReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.pageNo = (uint32_t)self.pageNum;
    req.pageSize = 20;
    req.roleId = self.isNurse ? 10002 : 10001;
    req.key = searchText;
    /// 10001-护工 10002-护士
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHomeStaffList message:req controller:self command:APP_COMMAND_SaasappgetHomeStaffList success:^(id response) {
        
        
        GetHomeStaffListRsp *rsp = [GetHomeStaffListRsp parseFromData:response error:nil];
        
        
        if (self.pageNum > 1) {
            
            if (self.staffListArray.count >= rsp.staffListArray_Count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.staffListArray addObjectsFromArray:rsp.staffListArray];
                
            }
            
        }else {
            self.staffListArray = rsp.staffListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        self.isLayout = NO;
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
}
- (void)loadNetworkData {
        
    [self loadNetworkDataWithSearchText:self.searchBar.text];
   
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.staffListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"YJYInsureOrderNurseListCell";
    
    if (!self.orderDetailRsp) {
        cellID = @"YJYInsureOrderNurseListCellThree";
    }
    
    YJYInsureOrderNurseListCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    InsureHGListVO *insureHGListVO = self.staffListArray[indexPath.row];
    cell.insureHGListVO = insureHGListVO;
    cell.didDetailBlock = ^{
        
        [self toDetailWhitInsureHGListVO:insureHGListVO];
    };
    
    cell.didGuideBlock = ^{
        
        [self toGuideWhitInsureHGListVO:insureHGListVO];
        
    };
    cell.didTransferBlock = ^{
        
    };
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.orderDetailRsp) {
        
        return 65;
    }
    return 150;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)toGuideInsureHGListVO:(InsureHGListVO *)insureHGListVO {
    
    NSString *alertTitle = [NSString stringWithFormat:@"是否指派%@",insureHGListVO.fullName];
    
    [UIAlertController showAlertInViewController:self withTitle:alertTitle message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [SYProgressHUD show];
            
            
            GuideStaffReq *req = [GuideStaffReq new];
            req.staffId = insureHGListVO.id_p;
            
            if (self.insureVo) {
                
                req.guideType = 1;
                req.insureNo = self.insureVo.insureNo;
                if (self.insureVo.status == YJYInsureTypeStateFirstReview) {
                    req.type = 0;
                    
                }else if (self.insureVo.status == YJYInsureTypeStateReReviewing){
                    req.type = 1;
                    
                }
                
            }else {
                
                req.guideType = self.nurseWorkType == YJYNurseWorkTypeNurse ? 1 : 3;
                req.insureNo = self.insureNo;
                req.orderId = self.orderId;
                req.remark = self.remark;
                req.time = self.time;
            }
            
            
            [YJYNetworkManager requestWithUrlString:SAASAPPGuideStaffNew message:req controller:self command:APP_COMMAND_SaasappguideStaffNew success:^(id response) {
                
                [SYProgressHUD hide];
                
                self.didSelectBlock(insureHGListVO);
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
    }];
}

#pragma mark - Action

- (void)toGuideWhitInsureHGListVO:(InsureHGListVO *)insureHGListVO {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否指派" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            id reqM;
            NSString *urlstring;
            APP_COMMAND app_command;
            
            if (self.isNurse && self.orderDetailRsp) {
                AssignInsureHGReq *req = [AssignInsureHGReq new];
                req.orderId = self.orderDetailRsp.order.orderId;
                req.hgId = insureHGListVO.id_p;
                
                reqM = req;
                
                urlstring = SAASAPPAssignInsureHG;
                app_command = APP_COMMAND_SaasappassignInsureHg;
                
            }else if(self.isGuide){
                
                GuideStaffReq *req = [GuideStaffReq new];
                req.staffId = insureHGListVO.id_p;
                
                if (self.insureVo) {
                    
                    req.guideType = 1;
                    req.insureNo = self.insureVo.insureNo;
                    if (self.insureVo.status == YJYInsureTypeStateFirstReview) {
                        req.type = 0;
                        
                    }else if (self.insureVo.status == YJYInsureTypeStateReReviewing){
                        req.type = 1;
                        
                    }
                    
                }else {
                    
                    req.guideType = self.isNurse ? 1 : 3;
                    req.insureNo = self.insureNo;
                    req.orderId = self.orderId;
                    req.remark = self.remark;
                    req.time = self.time;
                }
                
                reqM = req;
                urlstring = SAASAPPGuideStaffNew;
                app_command = APP_COMMAND_SaasappguideStaffNew;

            }else {
                
                GuideStaffReq *req = [GuideStaffReq new];
                req.orderId = self.orderDetailRsp.order.orderId;
                req.staffId = insureHGListVO.id_p;
                req.guideType = 3;
                
                reqM = req;
                
                urlstring = SAASAPPGuideStaffInsureOrder;
                app_command = APP_COMMAND_SaasappguideStaffInsureOrder;
                
            }
            
            
            [YJYNetworkManager requestWithUrlString:urlstring  message:reqM controller:self command:app_command success:^(id response) {
                
                if (self.didSelectBlock) {
                    self.didSelectBlock(insureHGListVO);
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
    
}

- (void)toDetailWhitInsureHGListVO:(InsureHGListVO *)insureHGListVO {
    
    
    YJYInsureNurseDetailController *vc = [YJYInsureNurseDetailController instanceWithStoryBoard];
    vc.orderId = self.orderDetailRsp.order.orderId;
    vc.hgId = insureHGListVO.id_p;
    vc.hgType = 2;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {
    
    self.pageNum = 1;
    [self loadNetworkDataWithSearchText:searchText];
}
@end
