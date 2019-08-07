//
//  YJYInsureCarePlanDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/14.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureCarePlanDetailController.h"
#import "YJYInsureCardPlanManualAddController.h"
#import "YJYInsureCarePlanController.h"
typedef void(^YJYInsureCarePlanDetailCellDidEditBlock)();

@interface YJYInsureCarePlanDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (assign, nonatomic) YJYInsureCarePlanDetailType detailType;

@property (strong, nonatomic) InsureOrderTendDetailBO *insureOrderTendDetailBO;
@property (copy, nonatomic) YJYInsureCarePlanDetailCellDidEditBlock didEditBlock;
@end

@implementation YJYInsureCarePlanDetailCell

- (void)setDetailType:(YJYInsureCarePlanDetailType)detailType {
    
    _detailType = detailType;
    self.editButton.hidden = (detailType == YJYInsureCarePlanDetailTypeNormal);
    
}

- (void)setInsureOrderTendDetailBO:(InsureOrderTendDetailBO *)insureOrderTendDetailBO {
    
    _insureOrderTendDetailBO = insureOrderTendDetailBO;
    self.titleLabel.text = insureOrderTendDetailBO.detailTypeName;
    
    NSMutableString *stringM = [NSMutableString string];
    for (NSInteger i =0 ; i< insureOrderTendDetailBO.tendDetailListArray.count; i++) {
        OrderTendDetail *orderTendDetail = insureOrderTendDetailBO.tendDetailListArray[i];
        [stringM appendString:orderTendDetail.content];

    }
    
    self.desLabel.text = stringM;
}

- (IBAction)toEdit:(id)sender {
    
    if (self.didEditBlock) {
        self.didEditBlock();
    }
}

@end

typedef void(^YJYInsureCarePlanDetailContentDidLoad)();

@interface YJYInsureCarePlanDetailContentController :YJYTableViewController

@property (weak, nonatomic) IBOutlet UILabel *carePlanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carePlanTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nurseLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

#define  YJYInsureCarePlanCreateHeader 250

#define  YJYInsureCarePlanDetailHeader 180
#define  YJYInsureCarePlanDetailOneLineOnHeader 50
#define  YJYInsureCarePlanDetailPlanPeopleHeader 50+70 + 10

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerOneView;
@property (weak, nonatomic) IBOutlet UIView *headerTwoView;


@property (weak, nonatomic) IBOutlet UIView *carePlanTimeView;
@property (weak, nonatomic) IBOutlet UIView *carePlanPeopleView;
@property (weak, nonatomic) IBOutlet UILabel *noPassLabel;


@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewText;

@property (assign, nonatomic)  CGFloat planTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerOneConstraint;

//data

@property(nonatomic, readwrite) uint64_t orderTendId;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) OrderTendVO *orderTendVO;
@property (strong, nonatomic) GetOrderTendDetailRsp *rsp;
@property (assign, nonatomic) YJYInsureCarePlanDetailType detailType;


//in data
//outdata
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *tendId;

@property (copy, nonatomic) YJYInsureCarePlanDetailContentDidLoad didLoad;
@property (assign, nonatomic) BOOL isActionHidden;



@end

@implementation YJYInsureCarePlanDetailContentController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self setupHeader];
    [self setup];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.detailType != YJYInsureCarePlanDetailTypeAdd) {
        [self loadNetworkData];
    }
    

}
- (void)setup {
    if (self.detailType == YJYInsureCarePlanDetailTypeAdd) {
        
        [self saveBlankTend];
    }
    
}

- (void)setupHeader {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader &&
        self.orderTendVO.status == 1) {
        
        
        self.headerOneView.hidden = YES;
        self.headerTwoView.hidden = NO;
        
        self.planTopConstraint = YJYInsureCarePlanCreateHeader;
        
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, YJYInsureCarePlanCreateHeader);

        self.headerTwoView.frame =  self.headerView.bounds;
    }else {
        
        self.headerOneView.hidden = NO;
        self.headerTwoView.hidden = YES;
        
        if (self.detailType == YJYInsureCarePlanDetailTypeNormal) {
            
            self.carePlanTimeView.hidden = NO;
            self.carePlanPeopleView.hidden = NO;
            
            //不通过
            if (self.rsp.status == 4) {
                self.planTopConstraint = YJYInsureCarePlanDetailHeader;
                self.noPassLabel.hidden = NO;
            }else {
                
                self.planTopConstraint = YJYInsureCarePlanDetailPlanPeopleHeader;
                self.noPassLabel.hidden = YES;
                
            }
        }else if (self.detailType == YJYInsureCarePlanDetailTypeAdd) {
            
            self.planTopConstraint = 0;
            self.carePlanTimeView.hidden = YES;
            self.carePlanPeopleView.hidden = YES;
            self.noPassLabel.hidden = YES;
            
            
        }else {
            self.carePlanTimeView.hidden = YES;
            self.carePlanPeopleView.hidden = YES;
            self.noPassLabel.hidden = YES;
            self.planTopConstraint = 0;
            
        }
        
        self.headerOneConstraint.constant = self.planTopConstraint;
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, self.planTopConstraint);
        self.headerOneView.frame =  self.headerView.bounds;
    }
    
    [self reloadAllData];
    
    
}

- (void)saveBlankTend {
    
    
    
    SaveOrderTendReq *req = [SaveOrderTendReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrderTend message:req controller:self command:APP_COMMAND_SaasappsaveOrderTend success:^(id response) {
        
        SaveOrderTendRsp *rsp = [SaveOrderTendRsp parseFromData:response error:nil];
        self.orderTendId = rsp.orderTendId;
        [self loadNetworkData];

        
    } failure:^(NSError *error) {
        
    }];
}
- (void)delOrderTend {
    
    DelOrderTendReq *req = [DelOrderTendReq new];
    req.orderTendId = self.orderTendId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPDelOrderTend message:req controller:self command:APP_COMMAND_SaasappdelOrderTend success:^(id response) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)loadNetworkData {
    
    GetOrderTendDetailReq *req = [GetOrderTendDetailReq new];
    if(self.orderId) {
        self.orderId = self.orderId;
        
    }else if (self.orderTendVO) {
        self.orderId = self.orderTendVO.orderId;
    }else if (self.orderDetailRsp) {
        self.orderId = self.orderDetailRsp.order.orderId;

    }
    req.orderId =  self.orderId;
    //tend
    if (self.tendId) {
        self.orderTendId = [self.tendId integerValue];

    }
    req.tendId = self.orderTendId;
    req.isAll = YES;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderTendDetail message:req controller:self command:APP_COMMAND_SaasappgetOrderTendDetail success:^(id response) {
        
        self.rsp = [GetOrderTendDetailRsp parseFromData:response error:nil];
        if (self.detailType == YJYInsureCarePlanDetailTypeNormal) {
            
            NSArray *arr = self.rsp.detailBolistArray;
            self.rsp.detailBolistArray = [NSMutableArray array];
            
            for (InsureOrderTendDetailBO *insureOrderTendDetailBO in arr) {
                if (insureOrderTendDetailBO.tendDetailListArray.count > 0) {
                    [self.rsp.detailBolistArray addObject:insureOrderTendDetailBO];
                }
            }
            
        }
        
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    if (self.didLoad) {
        self.didLoad();
    }
    
    self.carePlanTitleLabel.text = self.rsp.title;
    self.carePlanTimeLabel.text = self.rsp.timeStr;
    self.nurseLabel.text = [NSString stringWithFormat:@"制定护士：%@",self.rsp.hgName];
    self.stateLabel.text = [NSString stringWithFormat:@"状态：%@",self.rsp.statusStr];
    self.noPassLabel.text = [NSString stringWithFormat:@"不通过理由：%@",self.rsp.rejectReason];
    
    
    self.creatorLabel.text = self.rsp.hgName;
    self.createTimeLabel.text = self.rsp.createTimeStr;
    if (self.rsp.detailBolistArray.count == 0 && self.detailType == YJYInsureCarePlanDetailTypeNormal) {
        self.headerView.hidden = YES;
    }
    

    self.reviewText.text = self.rsp.tendDetial;
    [self setupHeader];
    [self reloadAllData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.detailBolistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureCarePlanDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureCarePlanDetailCell" forIndexPath:indexPath];
    
    
    InsureOrderTendDetailBO *insureOrderTendDetailBO = self.rsp.detailBolistArray[indexPath.row];
    cell.insureOrderTendDetailBO = insureOrderTendDetailBO;
    cell.didEditBlock = ^{
        
        //增加
        YJYInsureCardPlanManualAddController *vc = [YJYInsureCardPlanManualAddController instanceWithStoryBoard];
        vc.insureOrderTendDetailBO = insureOrderTendDetailBO;
        vc.tendDetailRsp = self.rsp;
        vc.didDoneBlock = ^{
            [self loadNetworkData];

        };
        [self.navigationController pushViewController:vc animated:YES];

        
    };
    
    
    if (self.rsp.status == 1 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        cell.detailType = YJYInsureCarePlanDetailTypeEdit;
    }else {
        
        cell.detailType = self.detailType;

    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    InsureOrderTendDetailBO *insureOrderTendDetailBO = self.rsp.detailBolistArray[indexPath.row];

    NSMutableString *stringM = [NSMutableString string];
    
    
    for (NSInteger i =0 ; i< insureOrderTendDetailBO.tendDetailListArray.count; i++) {
        OrderTendDetail *orderTendDetail = insureOrderTendDetailBO.tendDetailListArray[i];
        [stringM appendString:orderTendDetail.content];
//        [stringM appendFormat:@"%@", [NSString stringWithFormat:@"%@:%@",@(i+1),orderTendDetail.content]];
        
    }
    
    
    CGSize size = [stringM boundingRectWithSize:CGSizeMake(self.view.frame.size.width-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    double height = ceil(size.height);
    
    CGFloat H = 100 + (height - 17);
    
    return stringM.length > 0 ?  H : 55;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return self.isActionHidden ? 0 : 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = APPSaasF8Color;
    return footer;
}


@end

@interface YJYInsureCarePlanDetailController ()

@property (strong, nonatomic) YJYInsureCarePlanDetailContentController *contentVC;


@property (weak, nonatomic) IBOutlet UILabel *wordsLimitLabel;

//top
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

//bottom
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (strong, nonatomic) UIButton *actionButton;
@property (assign, nonatomic) BOOL isEdit;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end


@implementation YJYInsureCarePlanDetailController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureCarePlan" viewControllerIdentifier:className];
    return vc;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //头部
  
    if (self.detailType == YJYInsureCarePlanDetailTypeAdd) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(saveDraft)];
        
    }
    
   //历史记录
    self.historyButton.hidden = !self.isEnter;
    [self.historyButton addTarget:self action:@selector(toList:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部按钮变化
    
    
    //actionButton
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.buttonView.bounds.size.height);
    self.actionButton.backgroundColor = APPHEXCOLOR;
    [self.actionButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:self.actionButton];
    
    //buttonview
    [self setupHeader];
    [self setupBottom];
    
    
 
}

- (void)setupHeader {
    
    self.wordsLimitLabel.text = [NSString stringWithFormat:@"当前照护计划字数提醒：%@/500",@(self.contentVC.rsp.wordNum)];
    self.wordsLimitLabel.textColor = self.contentVC.rsp.wordNum >=500 ? APPREDCOLOR : APPHEXCOLOR;
    
    
    self.wordsLimitLabel.hidden = YES;
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader &&
        self.orderTendVO.status == 1) {
        
        self.wordsLimitLabel.hidden = NO;
        
    }else {
        
      self.wordsLimitLabel.hidden = (self.detailType == YJYInsureCarePlanDetailTypeNormal);

    }
    
    if (self.wordsLimitLabel.hidden == YES) {
        self.topConstraint.constant = 0;
    }else {

        self.topConstraint.constant = 100;
    }
    
}
- (void)setupBottom {
    
    //历史记录入口
    
    if (self.detailType == YJYInsureCarePlanDetailTypeNormal) {
        
        self.buttonView.hidden = self.isEnter;
        
        /// 审核状态 状态 0-草稿 1-待审核 2-执行中 3-已完成 4-审核不通过
        
        if (self.contentVC.rsp.status == 1 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
            
            self.actionButton.hidden = YES;
            self.oneButton.hidden = NO;
            self.twoButton.hidden = NO;
            
        }else if (self.contentVC.rsp.status == 2 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
            
            self.actionButton.hidden = NO;
            [self.actionButton setTitle:@"更新" forState:0];
            
            self.oneButton.hidden = YES;
            self.twoButton.hidden = YES;
            
            
        }else if (self.contentVC.rsp.status == 4 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
            
            self.actionButton.hidden = NO;
            [self.actionButton setTitle:@"修改" forState:0];
            
            self.oneButton.hidden = YES;
            self.twoButton.hidden = YES;
            
            
        }else {
            
            self.buttonView.hidden = YES;
            
        }
    }
    
    if (self.detailType == YJYInsureCarePlanDetailTypeEdit || self.detailType == YJYInsureCarePlanDetailTypeAdd) {
        
        self.buttonView.hidden = NO;
        [self.actionButton setTitle:@"提交" forState:0];
    }
    self.contentVC.isActionHidden = self.buttonView.hidden;
    [self.contentVC.tableView reloadData];
    
    
   
//    self.topConstraint.constant = (self.buttonView.hidden == NO) ? 0 : 64;
    
}

#pragma mark - Action

- (void)saveDraft {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否保存草稿" message:nil alertControllerStyle:1 cancelButtonTitle:@"不保存" destructiveButtonTitle:@"保存" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];

        }else {
            
            [self.contentVC delOrderTend];
        }
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureCarePlanDetailContentController"]) {
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYInsureCarePlanDetailContentController *)segue.destinationViewController;
        
        self.contentVC.tendId = self.tendId;
        self.contentVC.orderId = self.orderId;
        
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        self.contentVC.orderTendVO = self.orderTendVO;

        self.contentVC.detailType = self.detailType;
        self.contentVC.orderTendId = self.orderTendId;
        
 
 

        
        self.contentVC.didLoad = ^{
            [weakSelf setupHeader];
            [weakSelf setupBottom];
        };
    }
    
}
- (IBAction)toNoPass:(id)sender {
    
    
    [UIAlertController text_showAlertInViewController:self withTitle:@"不通过理由" message:nil cancelButtonTitle:@"取消" doneButtonTitle:@"确认" textFieldText:nil placeholder:@"不通过理由" secureTextEntry:NO tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            CheckInsureOrderTendReq *req = [CheckInsureOrderTendReq new];
            req.type = 2;
            req.orderTendId = self.orderTendVO.tendId;
            req.rejectReason = [controller.textFields.firstObject text];
            
            [YJYNetworkManager requestWithUrlString:SAASAPPCheckInsureOrderTend message:req controller:self command:APP_COMMAND_SaasappcheckInsureOrderTend success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
        
    }];
    
    
}

- (IBAction)toPass:(id)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否通过" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            CheckInsureOrderTendReq *req = [CheckInsureOrderTendReq new];
            req.type = 1;
            req.orderTendId = self.orderTendVO.tendId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPCheckInsureOrderTend message:req controller:self command:APP_COMMAND_SaasappcheckInsureOrderTend success:^(id response) {
                
                [self.contentVC loadNetworkData];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
}

//复制 再去编辑
- (void)toUpdateCopyAction {
    
    CopyOrderTendReq *req = [CopyOrderTendReq new];
    req.orderTendId = self.orderTendVO ? self.orderTendVO.tendId : self.orderTendId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCopyOrderTend message:req controller:self command:APP_COMMAND_SaasappcopyOrderTend success:^(id response) {
        
        CopyOrderTendRsp *rsp = [CopyOrderTendRsp parseFromData:response error:nil];
        
        [self toEditActionWithOrderTendId:rsp.orderTendId];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)toEditActionWithOrderTendId:(uint64_t)orderTendId {
    
    YJYInsureCarePlanDetailController *vc = [YJYInsureCarePlanDetailController instanceWithStoryBoard];
    
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.orderTendId = orderTendId;
    vc.detailType = YJYInsureCarePlanDetailTypeEdit;
    vc.didDoneBlock = ^(uint64_t new_orderTendId) {
        
        self.contentVC.orderTendId = new_orderTendId;
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)done:(UIButton *)sender {
    
    if (self.detailType == YJYInsureCarePlanDetailTypeNormal) {
        
        if ([sender.currentTitle isEqualToString:@"更新"]) {
            [self toUpdateCopyAction];
        }else {
            
            [self toEditActionWithOrderTendId:(uint32_t)self.orderTendVO.tendId];
            
        }
        
        
    }else  {
        
        if (self.contentVC.rsp.wordNum > 500) {
            [SYProgressHUD showFailureText:@"请把字数限制在500以内"];
            return;
        }
       //去提交
        SubmitOrderTendReq *req = [SubmitOrderTendReq new];
        req.orderTendId = self.contentVC.rsp.orderTendId;
        [YJYNetworkManager requestWithUrlString:SAASAPPSubmitOrderTend  message:req controller:self command:APP_COMMAND_SaasappsubmitOrderTend success:^(id response) {
            
            if (self.didDoneBlock) {
                self.didDoneBlock(self.orderTendId);
            }
            [self.navigationController popViewControllerAnimated:YES];

            
        } failure:^(NSError *error) {
         
        }];
       
        
    }
    
   
    
}
- (IBAction)toList:(id)sender {
    
    YJYInsureCarePlanController *vc = [YJYInsureCarePlanController instanceWithStoryBoard];
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.isHistoryEnter = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
