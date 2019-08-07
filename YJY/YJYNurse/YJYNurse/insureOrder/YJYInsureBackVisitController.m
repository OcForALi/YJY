//
//  YJYInsureBackVisitController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureBackVisitController.h"
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>
#import "YJYSignatureController.h"

typedef NS_ENUM(NSInteger, YJYInsureBackVisitType) {
    
    YJYInsureBackVisitTypeNextBackTime = 2,
    YJYInsureBackVisitTypeBackContentTime = 3,
    YJYInsureBackVisitTypeTrainContent = 12,
    YJYInsureBackVisitTypeTrainTitle,
    YJYInsureBackVisitTypeTrainWay,
    YJYInsureBackVisitTypeTrainWayButton,
    YJYInsureBackVisitTypeMasterTitle,
    YJYInsureBackVisitTypeMasterWay,
    YJYInsureBackVisitTypeMasterWayButton,


};

typedef void(^YJYInsureBackVisitContentDidLoad)();

@interface YJYInsureBackVisitContentController : YJYTableViewController


@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextBackTimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *backVisitTextView;
@property (weak, nonatomic) IBOutlet UITextView *careProblemTextView;
@property (weak, nonatomic) IBOutlet UITextView *careMethodTextView;

@property (weak, nonatomic) IBOutlet UILabel *trainContentLabel;

@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBackButton;

@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualifationLabel;
@property (weak, nonatomic) IBOutlet UIButton *trainContentButton;

@property (weak, nonatomic) IBOutlet UIButton *guideButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *noMasterButton;

@property (weak, nonatomic) IBOutlet UILabel *trainWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *relationSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *carerSignLabel;

@property (weak, nonatomic) IBOutlet UIView *oneTextView;
@property (weak, nonatomic) IBOutlet UIView *twoTextView;
@property (weak, nonatomic) IBOutlet UIView *threeTextView;



@property (strong, nonatomic) GetInsureOrderVisitDetailRsp *rsp;
@property (strong, nonatomic) InsureOrderVisitVO *insureOrderVisitVO;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (strong, nonatomic) UpdateInsureOrderVisitReq *visitReq;

@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *visitId;

@property (copy, nonatomic) YJYInsureBackVisitContentDidLoad didLoad;


@end

@implementation YJYInsureBackVisitContentController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureBackVisit" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.visitReq = [UpdateInsureOrderVisitReq new];
    [self loadNetworkData];
    
    
    self.oneTextView.layer.cornerRadius = 8;
    self.oneTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.oneTextView.layer.borderWidth = 0.5;
    
    self.twoTextView.layer.cornerRadius = 8;
    self.twoTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.twoTextView.layer.borderWidth = 0.5;
    
    self.threeTextView.layer.cornerRadius = 8;
    self.threeTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.threeTextView.layer.borderWidth = 0.5;
}

- (void)loadNetworkData {
    
    DeleteInsureOrderVisitReq *req = [DeleteInsureOrderVisitReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.visitId = self.insureOrderVisitVO.visitId;
    
    if (self.orderId &&self.visitId) {
        req.orderId = self.orderId;
        req.visitId = [self.visitId integerValue];
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderVisitDetail message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderVisitDetail success:^(id response) {
        
        self.rsp = [GetInsureOrderVisitDetailRsp parseFromData:response error:nil];
        if (self.didLoad) {
            self.didLoad();
        }
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    InsureOrderVisit *visit = self.rsp.visit;
    self.startTimeLabel.text = self.rsp.visitStartTimeStr;
    self.endTimeLabel.text = self.rsp.visitEndTimeStr;
    self.nextBackTimeLabel.text = self.rsp.nextTimeStr;

    self.backVisitTextView.text = visit.visitDetial;
    self.careProblemTextView.text = visit.visitProblem;
    self.careMethodTextView.text = visit.visitMeasures;

    
    self.trainContentLabel.text = [visit.visitSkillTrainingArray componentsJoinedByString:@"\n"];
    
    
    
    NSArray *types = [visit.visitTrainingType componentsSeparatedByString:@","];
    for (NSInteger i=0; i < types.count; i++) {
        
        NSString *trainingType = types[i];
        if ([trainingType isEqualToString:@"指导"]) {
            self.guideButton.selected = YES;
        }
        if ([trainingType isEqualToString:@"视频"]) {
            self.videoButton.selected = YES;
        }
    }
    self.trainWayLabel.text = visit.visitTrainingType;
    self.masterStateLabel.text = visit.visitSkillStatus == 0? @"掌握" : @"不掌握";
    self.noMasterButton.selected = (visit.visitSkillStatus == 1);
    self.masterButton.selected = !self.noMasterButton.selected;
    
    self.relationSignLabel.text = self.rsp.relationImgURL.length > 0 ? @"查看" : @"去签名";
    self.carerSignLabel.text = self.rsp.hgImgURL.length > 0 ? @"查看" : @"去签名";

    
    [self setupEnable];
    [self setupRsp];
    [self reloadAllData];
    
}
- (void)setupEnable {
    
    BOOL isEdit = self.rsp.visit.visitStatus != 2;
    
    self.startTimeButton.hidden = !isEdit;
    self.endTimeButton.hidden = !isEdit;
    self.nextBackButton.hidden = !isEdit;
    
    
    self.trainContentButton.hidden = !isEdit;
    
//    self.backVisitTextView.userInteractionEnabled = isEdit;
    self.careMethodTextView.userInteractionEnabled = isEdit;
    self.careProblemTextView.userInteractionEnabled = isEdit;
    
    self.lifeLabel.text = self.rsp.visit.visitVitaId > 0 ? @"查看":@"编辑";
    self.qualifationLabel.text = self.rsp.visit.visitQualityId > 0 ? @"查看":@"编辑";
    
  

}
- (void)setupRsp {
    
    InsureOrderVisit *visit = self.rsp.visit;
    
    self.visitReq.visitId = visit.id_p;
    self.visitReq.orderId = visit.orderId;
    self.visitReq.visitStatus = visit.visitStatus;
    
    self.visitReq.visitVita = visit.visitVitaId;
    self.visitReq.visitQualityControl = visit.visitQualityId;
    
    
    self.visitReq.visitMeasures = visit.visitMeasures;
    self.visitReq.visitProblem =  visit.visitProblem;
    
    
    self.visitReq.visitSkillTraining = visit.visitTrainingType;
    self.visitReq.visitSkillStatus = visit.visitSkillStatus;
    self.visitReq.visitSkillTraining = [visit.visitSkillTrainingArray componentsJoinedByString:@","];

}



- (void)setupReq {
    

    self.visitReq.visitStartTime = self.rsp.visitStartTimeStr;
    self.visitReq.visitEndTime = self.rsp.visitEndTimeStr;
    self.visitReq.nextTime = self.rsp.nextTimeStr;

    self.visitReq.visitMeasures = self.careMethodTextView.text;

    self.visitReq.visitMeasures = self.careMethodTextView.text;
    self.visitReq.visitProblem = self.careProblemTextView.text;
    

    self.visitReq.relationImgId = self.rsp.relationImgId;
    self.visitReq.hgImgId = self.rsp.hgImgId;
    
    
    
    //技能培训
    
    NSMutableArray *typesM = [NSMutableArray array];
    if (self.guideButton.selected) {
        [typesM addObject:@"指导"];
    }
    if (self.videoButton.selected) {
        [typesM addObject:@"视频"];
    }
    NSString *typestr = [typesM componentsJoinedByString:@","];
    
    self.visitReq.visitTrainingType = typestr;
    
    
    //掌握程度
    self.visitReq.visitSkillStatus = self.masterButton.selected ? 0 : 1;
    

}

- (IBAction)toLifeAction:(id)sender {
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    
    NSString *editStr = @"";
    NSString *visitVitaStr = @"";

    if (self.rsp.visit.visitStatus != 2) {
        editStr = @"&flag=edit";
    }
    visitVitaStr = [NSString stringWithFormat:@"&visitVitaId=%@",@(self.rsp.visit.visitVitaId)];

    
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&visitId=%@%@%@",kSAASInsurelifesign,self.orderDetailRsp.order.orderId,@(self.rsp.visit.id_p),visitVitaStr,editStr];
    vc.urlString = url;
    vc.title = @"回访生命体征";
    vc.didDone = ^(id result) {
        [self.navigationController popViewControllerAnimated:YES];

        
        NSString *visitVitaIdStr = result[@"visitVitaId"];
        NSInteger visitVitaId = [visitVitaIdStr integerValue];
        if (visitVitaIdStr > 0) {
            self.visitReq.visitVita = visitVitaId;
            self.rsp.visit.visitVitaId = self.visitReq.visitVita;
        }
        self.lifeLabel.text = visitVitaIdStr.length > 0 ? @"查看":@"编辑";
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (IBAction)toCheckControlAction:(id)sender {
    
    NSString *editStr = @"";
    if (self.rsp.visit.visitStatus != 2) {
        editStr = @"&flag=edit";
    }
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&visitId=%@&mQualityId=%@%@",kSAASInsureqccontent,self.orderDetailRsp.order.orderId,@(self.rsp.visit.id_p),@(self.rsp.visit.visitQualityId),editStr];
    vc.urlString = url;
    vc.title = @"回访质控内容";
    vc.didDone = ^(id result) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        NSString *qualityStr = result[@"qualityId"];
        NSInteger qualityID = [qualityStr integerValue];
        if (qualityID > 0) {
            self.visitReq.visitQualityControl = qualityID;
            self.rsp.visit.visitQualityId = self.visitReq.visitQualityControl;
        }
       

        self.qualifationLabel.text = qualityStr.length > 0 ? @"查看":@"编辑";
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)toTrainContentAction:(id)sender {
    
    
    NSString *editStr = @"";
    if (self.rsp.visit.visitStatus != 2) {
        editStr = @"&flag=edit";
    }
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&visitId=%@%@",kInsureskilltrain,self.orderDetailRsp.order.orderId,@(self.insureOrderVisitVO.visitId),editStr];
    vc.urlString = url;
    vc.title = @"回访技能培训";
    vc.didDone = ^(id result) {
        
        DeleteInsureOrderVisitReq *req = [DeleteInsureOrderVisitReq new];
        req.orderId = self.orderDetailRsp.order.orderId;
        req.visitId = self.insureOrderVisitVO.visitId;
        
        if (self.orderId &&self.visitId) {
            req.orderId = self.orderId;
            req.visitId = [self.visitId integerValue];
        }
        
        [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderVisitDetail message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderVisitDetail success:^(id response) {
            
            GetInsureOrderVisitDetailRsp *rsp = [GetInsureOrderVisitDetailRsp parseFromData:response error:nil];
            self.trainContentLabel.text = [rsp.visit.visitSkillTrainingArray componentsJoinedByString:@"\n"];
            [self.trainContentButton setTitle:@"查看" forState:0];
            self.visitReq.visitSkillTraining = [rsp.visit.visitSkillTrainingArray componentsJoinedByString:@","];
            [self.tableView reloadData];

            
        } failure:^(NSError *error) {
            
            
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toFamilySignAction:(id)sender {
    
    
    if (self.rsp.relationImgURL.length > 0) {
        
        [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.relationImgURL] currentImageIndex:0];

        
    }else {
        
        YJYSignatureController *vc = [YJYSignatureController new];
        vc.orderId = self.orderDetailRsp.order.orderId;
        vc.isInsure = YES;
        vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
        
            self.rsp.relationImgId = imageID;
            self.rsp.relationImgURL = imageURL;

            [SYProgressHUD showSuccessText:@"签名成功"];
            self.relationSignLabel.text = self.rsp.relationImgURL.length > 0 ? @"查看" : @"去签名";

            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    
   
    

    
}

- (IBAction)toHLSignAction:(id)sender {
    
    
    if (self.rsp.hgImgURL.length > 0) {
        
        [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.hgImgURL] currentImageIndex:0];
        
        
    }else {
        
        YJYSignatureController *vc = [YJYSignatureController new];
        vc.orderId = self.orderDetailRsp.order.orderId;
        vc.isInsure = YES;
        vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
            
            self.rsp.hgImgId = imageID;
            self.rsp.hgImgURL = imageURL;
            [SYProgressHUD showSuccessText:@"签名成功"];
            
            
            self.carerSignLabel.text = self.rsp.hgImgURL.length > 0 ? @"查看" : @"去签名";
            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    

    
}

- (IBAction)toPickStartTimeAction:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    picker.didSelectDate = ^(NSDate *date) {
        
        self.rsp.visitStartTimeStr = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
        self.startTimeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
    };
    [picker setDate:[NSDate dateString:self.visitReq.visitStartTime Format:YYYY_MM_DD_HH_MM]];
    [picker show];
    
}

- (IBAction)toPickEndTimeAction:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    picker.didSelectDate = ^(NSDate *date) {
        
        self.rsp.visitEndTimeStr = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
        self.endTimeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
    };
    [picker setDate:[NSDate dateString:self.visitReq.visitEndTime Format:YYYY_MM_DD_HH_MM]];
    [picker show];
    
}

- (IBAction)toPickNextBackTimeAction:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    picker.didSelectDate = ^(NSDate *date) {
        
        self.rsp.nextTimeStr = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
        self.nextBackTimeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD];
    };
    [picker setDate:[NSDate dateString:self.visitReq.visitEndTime Format:YYYY_MM_DD]];
    [picker show];
    
}


- (IBAction)trainAction:(UIButton *)sender {
    
    if (self.rsp.visit.visitStatus != 2) {
        sender.selected = !sender.selected;

    }
}

- (IBAction)masterAction:(UIButton *)sender {
    if (self.rsp.visit.visitStatus != 2) {
        self.masterButton.selected = NO;
        self.noMasterButton.selected = NO;
        
        sender.selected = YES;
    }
    
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.row == YJYInsureBackVisitTypeNextBackTime) {
    
        if ([YJYRoleManager sharedInstance].roleType != YJYRoleTypeNurse) {
            H = 0;
        }
        
    }else if (indexPath.row == YJYInsureBackVisitTypeBackContentTime) {
        H = 0;
    }else if (indexPath.row == YJYInsureBackVisitTypeTrainContent) {
        
        
        CGSize size = [self.trainContentLabel.text boundingRectWithSize:CGSizeMake(self.trainContentLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.trainContentLabel.font} context:nil].size;
        double height = ceil(size.height);
        
        return 70 - 17 + height;
    }else if (indexPath.row == YJYInsureBackVisitTypeTrainWay) {
        
        if (self.rsp.visit.visitStatus != 2) {
            H = 0;
        }
        
    }else if (indexPath.row == YJYInsureBackVisitTypeTrainWayButton) {
        
        if (self.rsp.visit.visitStatus == 2) {
            H = 0;
        }
    }else if (indexPath.row == YJYInsureBackVisitTypeMasterWay) {
        
        if (self.rsp.visit.visitStatus != 2) {
            H = 0;
        }
        
    }else if (indexPath.row == YJYInsureBackVisitTypeMasterWayButton) {
        
        if (self.rsp.visit.visitStatus ==  2) {
            H = 0;
        }
    }
    
    return H;
    
}
@end


@interface YJYInsureBackVisitController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) YJYInsureBackVisitContentController *contentVC;
@end


@implementation YJYInsureBackVisitController



+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureBackVisit" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.buttonView.hidden = self.insureOrderVisitVO.status == 2;
    self.saveButton.hidden = self.insureOrderVisitVO.status == 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureBackVisitContentController"]) {
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYInsureBackVisitContentController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        self.contentVC.insureOrderVisitVO =  self.insureOrderVisitVO;
        self.contentVC.orderId = self.orderId;
        self.contentVC.visitId = self.visitId;
        self.contentVC.didLoad = ^{
            weakSelf.buttonView.hidden = weakSelf.contentVC.rsp.visit.visitStatus == 2;

        };
    }
    
}
- (IBAction)save:(id)sender {
    
    [self.contentVC setupReq];
    self.contentVC.visitReq.visitStatus = 1;

    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateInsureOrderVisit  message:self.contentVC.visitReq controller:self command:APP_COMMAND_SaasappupdateInsureOrderVisit success:^(id response) {
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)toDoneAction:(id)sender {
    
    
    [self.contentVC setupReq];
    
    if (self.contentVC.visitReq.relationImgId.length == 0 && self.contentVC.visitReq.hgImgId.length == 0) {
        [SYProgressHUD showFailureText:@"请签名"];
        return;
    }
 
    
    if (self.contentVC.visitReq.visitSkillTraining.length == 0) {
        [SYProgressHUD showFailureText:@"请选择护理员技能培训内容"];
        return;
    }
    
    if (self.contentVC.visitReq.visitMeasures.length == 0) {
        [SYProgressHUD showFailureText:@"请填写护理措施"];
        return;
    }
    
    if (self.contentVC.visitReq.visitProblem.length == 0) {
        [SYProgressHUD showFailureText:@"请填写现存护理问题"];
        return;
    }
    [UIAlertController showAlertInViewController:self withTitle:@"是否完成" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
         
            self.contentVC.visitReq.visitStatus = 2;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPUpdateInsureOrderVisit  message:self.contentVC.visitReq controller:self command:APP_COMMAND_SaasappupdateInsureOrderVisit success:^(id response) {
                if (self.didDoneBlock) {
                    self.didDoneBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    
    
    
}
@end
