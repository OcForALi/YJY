
//
//  YJYLongNurseListController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/23.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLongNurseListController.h"
#import "YJYNurseWorkerController.h"

typedef void(^YJYLongNurseListItemDidSelectNurseBlock)(UIButton *nurseButton);

@interface YJYLongNurseListItemCell : UITableViewCell<MDHTMLLabelDelegate>

#define kYJYLongNurseListItemCellH 290
#define kYJYLongNurseListItemCellWithoutNurseLeaderH 205

#define kYJYLongNurseListItemCellLeader @"YJYLongNurseListItemCellLeader"
#define kYJYLongNurseListItemCellNotLeader @"YJYLongNurseListItemCellNotLeader"

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServerLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *nurseLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (weak, nonatomic) IBOutlet UIButton *operaNurseButton;

@property (strong, nonatomic) AssignVO *assess;

//data
@property (copy, nonatomic) YJYLongNurseListItemDidSelectNurseBlock didSelectNurseBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHConstraint;

@end

@implementation YJYLongNurseListItemCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setAssess:(AssignVO *)assess {

    _assess = assess;

    self.numberLabel.text = assess.assessVo.insureNoid;
    
    self.contactLabel.delegate = self;
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:assess.assessVo.userName phone:assess.assessVo.phone];
    
    
    
    self.addressLabel.text = assess.assessVo.detail;
    self.beServerLabel.text = assess.assessVo.kinsName;
    self.remarkLabel.text = (assess.assessVo.kfRemark.length > 0) ? assess.assessVo.kfRemark :@"  无备注";
    
    
    self.nurseLabel.text = assess.isExist ? assess.hgName : @"无";
    self.nurseLabel.textColor = assess.isExist ? APPNurseDarkGrayCOLOR : APPREDCOLOR;
    
    [self.operaNurseButton setTitle:assess.isExist ? @"更换指派" : @"指派护士" forState:0];
    self.operaNurseButton.hidden = (assess.status == 1);
    
    //布局更新
    CGFloat addressWidth = self.frame.size.width - 5 - 116 - 30;
    CGFloat addressExtraHeight = [assess.assessVo.detail boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    
    self.addressHConstraint.constant = addressExtraHeight + 30;
    
    
    NSString *state; 
    UIColor *color = APPORANGECOLOR;
    
    if (assess.status == 1) {
        
        color = APPORANGECOLOR;
        state = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager ? @"已处理" : @"已评估";

    }else if (assess.status == 2) {
        
        state = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager ? @"未处理" : @"未评估";
        color = APPREDCOLOR;
        
    }else if (assess.status == 3) {
        color = APPREDCOLOR;
        state = @"待指派";
    }
    
    
    [self.stateButton setBackgroundColor:color];
    [self.stateButton setTitle:state forState:0];

}
- (IBAction)toModifyNurse:(id)sender {
    
    if (self.didSelectNurseBlock) {
        self.didSelectNurseBlock(sender);
    }
}
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}
@end

@interface YJYLongNurseListController ()
@property (assign, nonatomic) uint32_t pageNum;
@property (strong, nonatomic) NSMutableArray<AssignVO*> *assessArray;
@property (copy, nonatomic) NSString *searchText;
@end

@implementation YJYLongNurseListController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLongNurseListController *)[UIStoryboard storyboardWithName:@"YJYLongNurse" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];


    self.assessArray = [NSMutableArray array];
    
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

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSearchData:) name:kYJYAssessUpdateNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self loadNetworkData];

}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - data


- (void)reloadSearchData:(NSNotification *)nofi {
    
    NSString *searchText = nofi.object;
    self.searchText = searchText;
    self.pageNum = 1;
    [self loadNetworkDataWithSearchText:searchText];

    
}
- (void)loadNetworkDataWithSearchText:(NSString *)searchText{

    //insureName


    GetAssessListReq *req = [GetAssessListReq new];
    req.pageSize = 20;
    req.status = self.listItem.type;
    req.pageNum = self.pageNum;
    
    
    if (searchText) {
        req.insureName = searchText;
    }

    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetAssessList message:req controller:nil command:APP_COMMAND_SaasappgetAssessList success:^(id response) {
        
        
        GetAssessListRsp *rsp = [GetAssessListRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.assessArray.count >= rsp.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.assessArray addObjectsFromArray:rsp.assessArray];
                
            }
            
        }else {
            self.assessArray = rsp.assessArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        
        
        [self.tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self reloadAllData];

        });
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
        
    
}

- (void)loadNetworkData {
    
    
    [self loadNetworkDataWithSearchText:self.searchText];
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.assessArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *identfier = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ? kYJYLongNurseListItemCellLeader : kYJYLongNurseListItemCellNotLeader;
    
    YJYLongNurseListItemCell * cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    
    AssignVO *assess = self.assessArray[indexPath.row];
    cell.assess = assess;
    
    cell.didSelectNurseBlock = ^(UIButton *nurseButton) {
        
        [self toGuideActionWithInsureNo:assess.assessVo.insureNoid];

    };
    

    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AssignVO *assess = self.assessArray[indexPath.row];

    YJYLongNurseDetailController *vc = [YJYLongNurseDetailController instanceWithStoryBoard];
    vc.actionType = self.actionType;
    vc.insureNo = assess.assessVo.insureNoid;
    vc.title = (self.actionType == YJYLongNurseActionTypeBook) ? @"预约详情" : @"评估详情";
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    CGFloat H = kYJYLongNurseListItemCellH;
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        H = kYJYLongNurseListItemCellWithoutNurseLeaderH;
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        H = kYJYLongNurseListItemCellWithoutNurseLeaderH;
    }
    
    AssignVO *assess = self.assessArray[indexPath.row];
    
    CGFloat addressWidth = self.tableView.frame.size.width - 116 - 17 - 10;
    
    CGFloat addressExtraHeight = [assess.assessVo.detail boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    
     CGFloat markExtraHeight = [assess.assessVo.kfRemark boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    
    return H + addressExtraHeight + markExtraHeight;
}
#pragma mark - Action

- (void)toGuideActionWithInsureNo:(NSString *)insureNo {
    
    
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.insureNo = insureNo;
    vc.time = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    vc.nurseWorkType = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YJYNurseWorkTypeNurse : YJYNurseWorkTypeWorker;
    vc.isGuide = YES;
    vc.isNurse = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YES : NO;

    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        self.pageNum = 1;
        [self loadNetworkData];
        
    
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock();
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock();
    }
}

@end
