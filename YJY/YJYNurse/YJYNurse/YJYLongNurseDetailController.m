//
//  YJYLongNurseDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/22.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYLongNurseDetailController.h"
#import "YJYLongNurseMedicalRecordController.h"
#import "YJYHWeightController.h"
#import "YJYEditController.h"
#import "YJYNurseWorkerController.h"
#import "YJYLongNurseReportController.h"
#import "YJYOrderCreateController.h"

typedef void(^DidLoadRspBlock)();
typedef void(^DidSaveBlock)();

@interface YJYLongNurseContentDetailController : YJYTableViewController<IQActionSheetPickerViewDelegate>


@property (copy, nonatomic) NSString *insureNo;
@property (copy, nonatomic) DidLoadRspBlock didLoadRspBlock;
@property (strong, nonatomic) GetInsureNoRsp *rsp;
@property (assign, nonatomic) BOOL isModify;
@property (assign, nonatomic) NSInteger payType;
@property (assign, nonatomic) YJYLongNurseActionType actionType;
@property (strong, nonatomic) SaveInsureAssessReq *req;
//view

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicalTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sickNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *hweightLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sickDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *recheckResultLabel;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UITextView *noPassTextView;
@property (weak, nonatomic) IBOutlet UILabel *nurseLabel;

@property (weak, nonatomic) IBOutlet UIView *sickView;

//state button
@property (weak, nonatomic) IBOutlet UIButton *healthNumberEditButton;
@property (weak, nonatomic) IBOutlet UIButton *sickNumberEditButton;
@property (weak, nonatomic) IBOutlet UIButton *hweightEditButton;
@property (weak, nonatomic) IBOutlet UIButton *timeEditButton;
@property (weak, nonatomic) IBOutlet UIButton *sickButton;

@end

@implementation YJYLongNurseContentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // empty
    
    self.nameLabel.text = self.sexLabel.text = self.ageLabel.text = self.idLabel.text = self.rateLabel.text = self.medicalTypeLabel.text = self.medicalNumberLabel.text =self.sickNumberLabel.text =self.orderTimeLabel.text = @"";
    

    self.req = [SaveInsureAssessReq new];
    self.req.insureNo = self.insureNo;
    
    
    
    
    // network
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    // SAASAPPSaveInsureAssess

    [SYProgressHUD show];
    
    [self loadNetworkData];
    
    
    //data
    
    self.payType = 1;

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.sickView yjy_setBottomShadow];
    [self.headerView yjy_setBottomShadow];

}


- (void)saveInsureAssessDone:(DidSaveBlock)didSaveBlock {
    
    [SYProgressHUD show];
    
    
   
  
    self.req.hsRemark = self.describeTextView.text;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPSaveInsureAssess message:self.req controller:self command:APP_COMMAND_SaasappsaveInsureAssess success:^(id response) {
        
        [SYProgressHUD hide];
        if (didSaveBlock) {
            didSaveBlock();
        }
        
        
    } failure:^(NSError *error) {
        
        if (didSaveBlock) {
            didSaveBlock();
        }
        
    }];
}

#pragma mark - load
- (void)loadNetworkData {
    
    GetInsureReq *req = [GetInsureReq new];
    req.insureNo = self.insureNo;
    
     [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureAssess message:req controller:self command:APP_COMMAND_SaasappgetInsureAssess success:^(id response) {
         
         self.rsp = [GetInsureNoRsp parseFromData:response error:nil];
         if (self.didLoadRspBlock) {
             self.didLoadRspBlock();
         }
         
         [self reloadRsp];
         
         [self reloadAllData];
     
     } failure:^(NSError *error) {
         
         [self reloadErrorData];
     }];
}

- (void)reloadRsp {

    InsureNOModel *insureModel = self.rsp.insureModel;

    self.nameLabel.text = insureModel.kinsName;
    self.sexLabel.text = (insureModel.sex == 1) ? @"男" : @"女";
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",@(insureModel.age)];
    self.idLabel.text = insureModel.idcard;
    
    self.rateLabel.text = insureModel.score > -1 ? [NSString stringWithFormat:@"%@分",@(insureModel.score)] : @"未评测";
    self.nurseLabel.text = (insureModel.nurseName.length > 0) ? insureModel.nurseName : @"无";
    
    
    self.medicalNumberLabel.text = (insureModel.healthCareNo.length > 0) ? insureModel.healthCareNo : @"无";
    self.sickNumberLabel.text = (insureModel.medicareNo.length > 0) ? insureModel.medicareNo : @"无";
    
    self.hweightLabel.text = (insureModel.height.length > 0) ? [NSString stringWithFormat:@"%@cm      %@kg",insureModel.height,insureModel.weight] : @"请点击编辑";
    
    self.orderTimeLabel.text = (self.rsp.orderTimeStr.length > 0) ? self.rsp.orderTimeStr : @"无";
    
    
    BOOL isEdit = self.rsp.insureStatus != 3 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse;
    
    [self.sickButton setTitle:self.rsp.insureStatus != 3 ? @"编辑" : @"查看" forState:0];
    self.sickDesLabel.text = (insureModel.medicalListArray.count > 0) ? [insureModel.medicalListArray componentsJoinedByString:@","] : (isEdit ? @"请修改/添加病史" : @"无");
    
    self.sickButton.hidden = [self.sickDesLabel.text isEqualToString:@"无"];

    //备注
    
    
    BOOL isNotRemark = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && self.rsp.insureStatus == 2;
    self.describeTextView.text = isNotRemark ? @"" : (insureModel.hsRemark.length > 0 ? insureModel.hsRemark : @"暂无");
    
    
    self.describeTextView.userInteractionEnabled = (self.rsp.insureModel.status == 1 &&
                                                    [YJYRoleManager sharedInstance].roleType != YJYRoleTypeNurseLeader);

    self.noPassTextView.text = self.rsp.rejectDesc;
    self.noPassTextView.userInteractionEnabled = NO;
    
   
    NSString *state;
    UIColor *color = APPORANGECOLOR;
    
    
    // 健康经理
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        
        if (self.rsp.insureModel.orderStatus == 0 || self.rsp.insureModel.orderStatus == 2) {
            
            color = APPREDCOLOR;
            state =  @"待处理";
            
        }else {
            
            color = APPORANGECOLOR;
            state =  @"已处理";
        }
        
    }else {
    // 非健康经理

        if (self.rsp.insureStatus == YJYLongNurseOrderStateReview) {
            
            color = APPORANGECOLOR;
            state =  @"已评估";
            
        }else if (self.rsp.insureStatus == YJYLongNurseOrderStateWaitReview) {
            
            state = @"未评估";
            color = APPREDCOLOR;
            
        }else if (self.rsp.insureStatus == YJYLongNurseOrderStateWaitGuide) {
            
            color = APPREDCOLOR;
            state = @"待指派";
        }
    
    }
    
    
    

    [self.stateButton setBackgroundColor:color];
    [self.stateButton setTitle:state forState:0];
    
    
    if (self.rsp.insureStatus == YJYLongNurseOrderStateReview) {
        
        NSString *secondReviewState = @"无操作";
        UIColor *secondReviewColor;
        
        if (self.rsp.againStatus == 1) {
            secondReviewState = @"通过";
            secondReviewColor = APPHEXCOLOR;
        }else if (self.rsp.againStatus == 2) {
            secondReviewState = @"不通过";
            secondReviewColor = APPREDCOLOR;
        }
        self.recheckResultLabel.text = [NSString stringWithFormat:@"%@ %@",secondReviewState,self.rsp.assessTimeStr];
        self.recheckResultLabel.textColor = secondReviewColor;

    }

    //medicareType
    
    for (MedicareType *medicareType in [YJYSettingManager sharedInstance].medicareListArray) {
        if (medicareType.id_p == self.rsp.insureModel.medicareType) {
            
            self.medicalTypeLabel.text = medicareType.medicare;
            break;
            
        }
    }
    
    [self reloadEditButtons];
}

- (void)reloadEditButtons {
    
    BOOL isNotEdit = (self.rsp.insureStatus == YJYLongNurseOrderStateReview) || ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader);
    self.healthNumberEditButton.hidden = isNotEdit;
    self.sickNumberEditButton.hidden = isNotEdit;
    self.hweightEditButton.hidden = isNotEdit;
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        
        self.timeEditButton.hidden = self.rsp.insureModel.orderStatus != 2;
        
    }else {
    
        self.timeEditButton.hidden = isNotEdit;

    
        
    }
    

    
}
#pragma mark - Action

- (IBAction)editHealthCardAction:(id)sender {
    
    YJYEditController *vc = [YJYEditController instanceWithStoryBoard];
    vc.originString = self.medicalNumberLabel.text;

    vc.didEditBlock = ^(NSString *text) {
        
        self.medicalNumberLabel.text = text;
        self.req.healthCareNo = self.medicalNumberLabel.text;
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)editToHealAction:(id)sender {
    
    YJYEditController *vc = [YJYEditController instanceWithStoryBoard];
    vc.originString = self.sickNumberLabel.text;

    vc.didEditBlock = ^(NSString *text) {
        
        self.sickNumberLabel.text = text;
        self.req.medicareNo = self.sickNumberLabel.text;

    };
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)editMedicalCardAction:(id)sender {
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && self.rsp.insureStatus == 2) {
       
        YJYLongNurseMedicalRecordController *vc = [YJYLongNurseMedicalRecordController instanceWithStoryBoard];
        vc.insureModel = self.rsp.insureModel;
        vc.isEdit = (self.rsp.insureModel.status == 1);
        vc.didDoneBlock = ^(NSArray *medicalArray) {
            
            self.rsp.insureModel.medicalListArray = [NSMutableArray arrayWithArray: medicalArray];
            self.sickDesLabel.text = [self.rsp.insureModel.medicalListArray componentsJoinedByString:@","] ? [self.rsp.insureModel.medicalListArray componentsJoinedByString:@","] : @"添加或删除病史";
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {
    
        NSString * urlString = [NSString stringWithFormat:@"%@?insureNO=%@",kSickURL,self.rsp.insureModel.insureNo];
        
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = urlString;
        vc.title = @"护理易";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

- (IBAction)editTimeAction:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:self];
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];

    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;
    [picker show];
}
- (IBAction)editHWeightAction:(id)sender {
    
    YJYHWeightController *vc = [YJYHWeightController instanceWithStoryBoard];
    vc.height = [self.rsp.insureModel.height integerValue];
    vc.weight = [self.rsp.insureModel.weight integerValue];
    vc.dismissBlcok = ^(NSInteger weight, NSInteger height) {
        
        self.hweightLabel.text = [NSString stringWithFormat:@"%@cm      %@kg",@(height),@(weight)];
        self.rsp.insureModel.height = [NSString stringWithFormat:@"%@",@(height)];
        self.rsp.insureModel.weight = [NSString stringWithFormat:@"%@",@(weight)];
        
        //req
        self.req.height = self.rsp.insureModel.height;
        self.req.weight = self.rsp.insureModel.weight;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toReportListAction:(id)sender {
    
    YJYLongNurseReportController *vc = [YJYLongNurseReportController instanceWithStoryBoard];
    vc.insureModel = self.rsp.insureModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isTime = indexPath.row == 0;

    if (isTime)
        
    {
        [cell.superview bringSubviewToFront:cell];
        cell.contentView.superview.clipsToBounds = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat itemCellH = 65;
    
    
//下单预约
    
    if (self.actionType == YJYLongNurseActionTypeBook) {
        
        if (indexPath.row == 0 || //姓名
            indexPath.row == 1 || //身份证
            indexPath.row == 6 ||
            indexPath.row == 7 ||
            indexPath.row == 9 ||
            indexPath.row == 10 ) {

            return [super tableView:tableView heightForRowAtIndexPath:indexPath];

        
        }else {
        
            return 0;

        }
        
       

    }else {
    
//护士护士长显示
        
        if(indexPath.row == 8){
            //08 护士指派
            
            return [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader ? itemCellH : 0;

            
        }else if(indexPath.row == 10){
            
            //10 查看评估
            
            return ((self.rsp.insureStatus == 1 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) ||
                    (self.rsp.insureStatus !=3 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader)) ?  0  : itemCellH;
            
        } else if (indexPath.row == 11) {
            //11 复审结果
            
            if (self.rsp.insureStatus == 3) {
                
                return itemCellH;
            }
            return 0;
            
        }else if (indexPath.row == 12 || indexPath.row == 13) {
            
            //12不通过原因 13 补充说明
            
            NSString *text = indexPath.row == 13 ? self.describeTextView.text : self.noPassTextView.text;
            
            BOOL isNotText = text.length == 0;
            BOOL isReviewed = self.rsp.insureStatus != 3;
            BOOL isHeadthManager = [YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager;
            
            
            if (isNotText ||
                isReviewed ||
                isHeadthManager) {
                
                if (indexPath.row == 13 && [YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
                    return 200;
                }
                
                return 0;
            }
            
            //正常
           
            
            CGFloat markExtraWidth = self.tableView.frame.size.width - 116 - 5 - 20 - 5;
            
            CGFloat markExtraHeight = [text  boundingRectWithSize:CGSizeMake(markExtraWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
            
            return markExtraHeight + 60;
            
        }
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];



    
}

#pragma mark - IQSheetDelegate

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date {
    
    
    NSString *dataString = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
    self.orderTimeLabel.text = dataString;
    self.isModify = YES;
    self.req.appointTime =  self.orderTimeLabel.text;
    [self saveInsureAssessDone:nil];

    
}
@end

@interface YJYLongNurseDetailController ()
@property (strong, nonatomic)  YJYLongNurseContentDetailController *contentDetailController;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewHConstraint;
@property (strong, nonatomic) NSMutableArray *buttonViews;

@end

@implementation YJYLongNurseDetailController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYLongNurseDetailController *)[UIStoryboard storyboardWithName:@"YJYLongNurseDetail" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYLongNurseContentDetailController"]) {
        
        
        __weak typeof(self) weakSelf = self;
        
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
            self.actionType = YJYLongNurseActionTypeBook;
        }else {
            self.actionType = YJYLongNurseActionTypeReview;
        }
        
        self.contentDetailController = (YJYLongNurseContentDetailController *)segue.destinationViewController;
        self.contentDetailController.actionType = self.actionType;
        self.contentDetailController.insureNo = self.insureNo;
        self.contentDetailController.didLoadRspBlock = ^{
            
            [weakSelf reloadToolView];
            
        };
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.buttonViews = [NSMutableArray array];
    self.toolView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];

}

- (void)setInsreNO:(NSString *)insreNO {
    
    _insreNO = insreNO;
    self.insureNo = insreNO;
}

#pragma mark - toolview
- (void)reloadToolView {
    
    //先清空
    for (UIView *subView in self.buttonViews) {
        [subView removeFromSuperview];
    }
    self.buttonViews = [NSMutableArray array];

    
    
    NSArray *menuItems = [[YJYRoleManager sharedInstance] book_LongNurseMenuItemsWithInsureNoRsp:self.contentDetailController.rsp];
    [self reloadButtonsWithArray:menuItems];
    
    self.toolViewHConstraint.constant = (menuItems.count > 0) ? 60 : 0;
    self.toolView.hidden = (menuItems.count == 0);
    
    
}

- (void)reloadButtonsWithArray:(NSArray *)serviceItems {
    
    CGFloat width = self.toolView.frame.size.width/serviceItems.count + 1;

    for (NSInteger i = 0; i < serviceItems.count; i ++) {
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(i * width, 0, width, self.toolView.frame.size.height)];
        
        LongNurseMenuItem *item = serviceItems[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonView.bounds;
        [button setTitle:item.title forState:0];
        [button addTarget:self action:NSSelectorFromString(item.func) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        
        [buttonView addSubview:button];
        
        
        //line
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width - 1, 15, 1, button.frame.size.height - 30)];
        line.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.3];
        
        [buttonView addSubview:line];
        
        [self.toolView addSubview:buttonView];
        [self.buttonViews addObject:buttonView];

    }
}
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (self.contentDetailController.rsp.insureModel.status == 1 || self.contentDetailController.isModify) {
        [self.contentDetailController saveInsureAssessDone:nil];

    }
}

#pragma mark - Action 

- (IBAction)toPass {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否通过长护险" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];
            
            [self.contentDetailController saveInsureAssessDone:^{
                InsureAssessFirstReq *req = [InsureAssessFirstReq new];
                req.insureNo = self.insureNo;
                req.status = 1;
                req.payType =  (uint32_t)self.contentDetailController.payType;
                
                [YJYNetworkManager requestWithUrlString:SAASAPPInsureAssessFirst message:req controller:nil command:APP_COMMAND_SaasappinsureAssessFirst success:^(id response) {
                    [SYProgressHUD showSuccessText:@"成功通过"];
                    [self.contentDetailController loadNetworkData];
                } failure:^(NSError *error) {
                    
                }];
            }];

            
            
        }
        
    }];
}
- (IBAction)toRejuct {
    
    [UIAlertController text_showAlertInViewController:self withTitle:@"不通过原因" message:nil cancelButtonTitle:@"取消" doneButtonTitle:@"确定" textFieldText:nil placeholder:@"不通过原因" secureTextEntry:NO tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];
            
            [self.contentDetailController saveInsureAssessDone:^{
                
                
                InsureAssessFirstReq *req = [InsureAssessFirstReq new];
                req.insureNo = self.insureNo;
                req.status = 2;
                req.payType =  (uint32_t)self.contentDetailController.payType;
                req.rejectDesc = controller.textFields[0].text;
                
                [YJYNetworkManager requestWithUrlString:SAASAPPInsureAssessFirst message:req controller:nil command:APP_COMMAND_SaasappinsureAssessFirst success:^(id response) {
                    
                    [SYProgressHUD showSuccessText:@"不通过"];
                    [self.contentDetailController loadNetworkData];
                    
                } failure:^(NSError *error) {
                    
                }];
            }];
            
            
        }
        
        
    }];
}
//指派护士
- (void)toGuideAction {

    
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.insureNo = self.contentDetailController.rsp.insureModel.insureNo;
    vc.time = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    vc.nurseWorkType = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YJYNurseWorkTypeNurse : YJYNurseWorkTypeWorker;
    vc.isGuide = YES;
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {

        [self.contentDetailController loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    

    
}

//下单
- (void)toPlaceOrder {
    
    YJYOrderCreateController *vc = [YJYOrderCreateController instanceWithStoryBoard];
    
    vc.createType = YJYOrderCreateTypeLongNurse;
    vc.insureModel = self.contentDetailController.rsp.insureModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//暂时不下单
- (void)toNotPlaceOrder {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否确认暂不下单" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];
            
            UpdateInsureOrderReq *req = [UpdateInsureOrderReq new];
            req.insureNo = self.insureNo;
            
            req.orderStatus = 1;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPUpdateInsureOrder message:req controller:self command:APP_COMMAND_SaasappupdateInsureOrder success:^(id response) {
                
                
                [self.contentDetailController loadNetworkData];
                
                
            } failure:^(NSError *error) {
                
            }];
            
            
            
        }
        
    }];
    
   


}


@end
