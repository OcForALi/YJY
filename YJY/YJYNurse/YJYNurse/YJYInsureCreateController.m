//
//  YJYInsureCreateController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/11/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureCreateController.h"
#import "YJYPersonListController.h"
#import "YJYPersonEditController.h"

#import "YJYAddressesController.h"
#import "YJYAddressPositionController.h"
#import "YJYLongNurseWebController.h"
#import "YJYImageShowController.h"
#import "YJYInsureDetailController.h"
#import "YJYSignatureController.h"
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>
#import "YJYInsureCreateUserKowningController.h"
#pragma mark - YJYInsureCreateContentController

typedef NS_ENUM(NSInteger, YJYInsureCreateContentType) {
    
    YJYInsureCreateContentTypePhone,
    YJYInsureCreateContentTypeCarePeople,
    YJYInsureCreateContentTypeContact,
    
    YJYInsureCreateContentTypeAgentTitle,
    YJYInsureCreateContentTypeName,
    YJYInsureCreateContentTypeRelation,
    YJYInsureCreateContentTypeAgentPhone,
    
    YJYInsureCreateContentTypeApplyTitle,
    YJYInsureCreateContentTypeApplyTreatment,
    YJYInsureCreateContentTypeTreatmentType,
    YJYInsureCreateContentTypeReviewType,
    YJYInsureCreateContentTypeLongType,
    
    YJYInsureCreateContentTypeHMTitle,
    YJYInsureCreateContentTypeHMADL,
    YJYInsureCreateContentTypeHMCustomer,
    YJYInsureCreateContentTypeHMRisk,
    
    YJYInsureCreateContentTypeSign,
    YJYInsureCreateContentTypePic,

};

@interface YJYInsureCreateContentController : YJYTableViewController
//1.参保人
@property (weak, nonatomic) IBOutlet UILabel *insureNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *insurePersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureContactLabel;

//2.代理人信息
@property (weak, nonatomic) IBOutlet UITextField *agentNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *agentRelationshipLabel;
@property (weak, nonatomic) IBOutlet UITextField *agentPhoneLabel;

//3.申请单信息

@property (weak, nonatomic) IBOutlet UIButton *lifeCareButton;
@property (weak, nonatomic) IBOutlet UIButton *hospitalCareButton;

@property (weak, nonatomic) IBOutlet UIButton *hospitalTreatmentButton;
@property (weak, nonatomic) IBOutlet UIButton *homeTreatmentButton;


@property (weak, nonatomic) IBOutlet UIButton *firstReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *twiceReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyReviewButton;


@property (weak, nonatomic) IBOutlet UIButton *emsGetButton;
@property (weak, nonatomic) IBOutlet UIButton *visitToGetButton;

//4.健康经理评估
@property (weak, nonatomic) IBOutlet UILabel *adlLabel;
@property (weak, nonatomic) IBOutlet UITextView *clientStateTextView;
@property (weak, nonatomic) IBOutlet UITextView *secureTextView;
@property (weak, nonatomic) IBOutlet UIButton *adlButton;

@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

//data

@property (strong, nonatomic) AddInsureReq *req;
@property (strong, nonatomic) KinsfolkVO *kinsfolk;
@property(nonatomic, readwrite) NSString *contactPhone;
@property (assign, nonatomic) NSInteger resultADL;


@property (copy, nonatomic) NSString *signId;
@property (copy, nonatomic) NSString *signImgUrl;

@property (copy, nonatomic) NSString *takePhotoId;
@property (copy, nonatomic) NSString *takePhotoImgUrl;

@property (assign, nonatomic) BOOL isSearch;


@end

@implementation YJYInsureCreateContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.req = [AddInsureReq new];
    self.req.applyTreatmentType = 1;
    self.req.treatmentType = 2;
    self.req.assessType = 1;
    self.req.insureGetType = 2;
    
//    [self.hmADLCheckButton setTitle:insureVO.dudaoScoreAdl == 0 ? @"去评分" : @"查看" forState:0];
    self.insureNoLabel.text = [NSString stringWithFormat:@"%@",self.contactPhone];
    self.adlLabel.hidden = YES;
    
    [self loadNetworkKinsfolk];
    [self loadNetworkAddress];

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
#pragma mark - Network

- (void)loadNetworkKinsfolk {
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserKinsList message:req controller:self command:APP_COMMAND_SaasappgetUserKinsList success:^(id response) {
        
        
        GetUserKinsListRsp *rsp = [GetUserKinsListRsp parseFromData:response error:nil];
        
        for (KinsfolkVO *kinsfolk in rsp.kinsListArray) {
            
            if (kinsfolk.insureFlagType == 0) {
                [self setupKindFolk:kinsfolk];
                break;
            }
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)loadNetworkAddress {
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserAddrList message:req controller:self command:APP_COMMAND_SaasappgetUserAddrList success:^(id response) {
        
        
        GetUserAddrListRsp *rsp = [GetUserAddrListRsp parseFromData:response error:nil];
        UserAddressVO *currentAddress = rsp.addrListArray.firstObject;
        [self setupAddress:currentAddress];
        
    } failure:^(NSError *error) {
        
    }];
    

    
}

#pragma mark - Action

- (IBAction)toADLAction:(UIButton *)sender {

//    https://dev.1-1dr.com/sass/index.html#/adlassess?insureNO=201711101042047174398&edit=false&assessType=1&kinsId=12532
    // 健康1 护士2 用户自评3
    if (!self.req.kinsId) {
        [SYProgressHUD showFailureText:@"请选择参保人"];
        return;
    }
    
    NSString *assessId = nil;
    if (self.req.assessId > 0) {
        assessId = [NSString stringWithFormat:@"&assessId=%@",@(self.req.assessId)];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?assessType=1&kinsId=%@&edit=%@%@",kSAASADLURL,@(self.req.kinsId),(self.resultADL == -1 ? @"true":@"false"),assessId];
    
    YJYLongNurseWebController *vc = [YJYLongNurseWebController new];
    vc.title = @"ADL评估";
    vc.didComfire = ^(NSDictionary *dict) {
        if (dict[@"assessId"] && dict[@"score"]) {
            uint64_t assessId = (uint64_t)[dict[@"assessId"] integerValue];
            uint32_t score = (uint32_t)[dict[@"score"] integerValue];
            
            
            if (assessId == 0) {
                return;
            }
            
            self.req.assessId = assessId;
            self.req.dudaoScoreAdl = score;
            self.resultADL = [dict[@"score"] integerValue];
            
            self.adlLabel.text = [NSString stringWithFormat:@"%@分",@(score)];
            self.adlLabel.hidden = NO;
            
            [self.adlButton setTitle:@"查看" forState:0];
        }
        
    };
    vc.urlString = urlString;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)applyTypeAction:(UIButton *)sender {
   
  
    sender.selected = !sender.selected;
    self.req.applyTreatmentType = sender.selected ? 2 : 1;

    
}
- (IBAction)treatmentTypeAction:(UIButton *)sender {
    
    self.hospitalTreatmentButton.selected = NO;
    self.homeTreatmentButton.selected = NO;
    
    sender.selected = YES;
    
    self.req.treatmentType = [sender isEqual:self.hospitalTreatmentButton] ? 1 : 2;

}
- (IBAction)assessTypeAction:(UIButton *)sender {
    
    self.firstReviewButton.selected = NO;
    self.twiceReviewButton.selected = NO;
    self.modifyReviewButton.selected = NO;

    sender.selected = YES;
    
    if ([sender isEqual:self.firstReviewButton] ) {
        self.req.assessType = 1;
    }else if ([sender isEqual:self.twiceReviewButton]) {
        self.req.assessType = 2;

    }else if ([sender isEqual:self.modifyReviewButton]) {
        self.req.assessType = 3;
        
    }
    
}
- (IBAction)insureGetTypeAction:(UIButton *)sender {
    
    self.emsGetButton.selected = NO;
    self.visitToGetButton.selected = NO;
    
    sender.selected = YES;
    
    self.req.insureGetType = [sender isEqual:self.emsGetButton] ? 1 : 2;
}

- (IBAction)toSwitchPerson:(id)sender {
    
    [SYProgressHUD show];
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserKinsList message:req controller:self command:APP_COMMAND_SaasappgetUserKinsList success:^(id response) {
        
        
        
         [SYProgressHUD hide];
        GetUserKinsListRsp *rsp = [GetUserKinsListRsp parseFromData:response error:nil];
        
        if (rsp.kinsListArray.count > 0) {
            
            YJYPersonListController *vc = [YJYPersonListController instanceWithStoryBoard];
            vc.kinsType = YJYPersonListKinsTypeApply;
            vc.kinsfolksDidSelectBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
            vc.firstAdd = YES;
            vc.didDoneBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self loadNetworkKinsfolk];
                
            };
          
            [self.navigationController pushViewController:vc animated:YES];

            
        }
        
        [SYProgressHUD hide];

        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}

- (IBAction)toSwitchAddress:(id)sender {

    [SYProgressHUD show];
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserAddrList message:req controller:self command:APP_COMMAND_SaasappgetUserAddrList success:^(id response) {
        [SYProgressHUD hide];
        GetUserAddrListRsp *rsp = [GetUserAddrListRsp parseFromData:response error:nil];
        if (rsp.addrListArray.count > 0) {
            
            YJYAddressesController *vc = [YJYAddressesController instanceWithStoryBoard];
            vc.didSelectBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            
            YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
            vc.addressDidSavedBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
                if (!address.addrId) {
                    [self loadNetworkAddress];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        [SYProgressHUD hide];
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}

- (IBAction)checkImgAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        if (!self.signId) {
            [self toSignAction];
        }else {
            [self toCheckImageWithTag:0];

        }
    }else {
        if (!self.takePhotoId) {
            [self toUploadImageWithTag:1];
        }else {
            [self toCheckImageWithTag:1];
            
        }
        
    }
    
  
}
- (void)toCheckImageWithTag:(NSInteger)tag {
    
    NSString *imgURL;
    if (tag == 0) {
        imgURL = self.signImgUrl;
    }else {
        imgURL = self.takePhotoImgUrl;
    }

    [XLPhotoBrowser showPhotoBrowserWithImages:@[imgURL] currentImageIndex:0];
    
//    vc.isEdit = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)toSignAction {
    
    
    YJYSignatureController *vc = [YJYSignatureController new];
    vc.isInsure = YES;
    vc.didReturnImage = ^(NSString *imageID,NSString *imageURL) {
        
        self.signId = imageID;
        self.signImgUrl = imageURL;
        self.req.userSignPic = imageID;
        [self.signButton setTitle:@"查看" forState:0];

    };

    [self presentViewController:vc animated:YES completion:nil];
    
    
}
- (void)toUploadImageWithTag:(NSInteger)tag {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                [SYProgressHUD showLoadingWindowText:@"正在上传"];
                
                [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
                    
                    NSString *imageID = response[@"imageId"];
                    NSString *imageURL = response[@"imgUrl"];
                    
                    if (tag == 1) {

                        self.takePhotoId = imageID;
                        self.takePhotoImgUrl = imageURL;
                        self.req.entrustPic = imageID;
                        [self.takePhotoButton setTitle:@"查看" forState:0];
                    }
                    [SYProgressHUD showSuccessText:@"上传成功"];

                    
                } failure:^(NSError *error) {
                    
                    [SYProgressHUD showFailureText:@"上传失败"];
                    
                    
                }];
                
                
            } cancel:^{
                
                [SYProgressHUD hide];
                
                
            }];
        }
        
    }];
}

#pragma mark - data



- (void)setupKindFolk:(KinsfolkVO *)kinsfolk {
    
    if (!kinsfolk || kinsfolk.name.length == 0) {
        self.insurePersonLabel.text = @"被服务人信息";
        return;
    }
    NSString *sex = kinsfolk.sex == 1 ? @"男": @"女";
    
    self.insurePersonLabel.text = [NSString stringWithFormat:@"%@  年龄:%@  性别%@",kinsfolk.name,@(kinsfolk.age),sex];
    self.req.kinsId = kinsfolk.kinsId;
    
    self.req.dudaoScoreAdl = 0;
    self.adlLabel.hidden = YES;
    [self.adlButton setTitle:@"去评分" forState:0];

}
- (void)setupAddress:(UserAddressVO *)address {
    
    if (!address || address.addressInfo.length == 0) {
        self.insureContactLabel.text = @"被服务人信息";
        return;
    }
    
    NSString *contact = [NSString stringWithFormat:@"%@  %@",address.contacts,address.phone];
    NSString *full = [NSString stringWithFormat:@"%@\n%@",contact,address.addressInfo];
    
    self.insureContactLabel.text = full;
    self.req.addrId = address.addrId;
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 2) {
        
        CGSize size = [self.insureContactLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width -36-17, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        double height = ceil(size.height);
        
        H = height + (65 - 5);
        
    }else if (indexPath.row == YJYInsureCreateContentTypeSign || indexPath.row == YJYInsureCreateContentTypePic) {
        
        if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
            H = 0;
        }
        
    }
    
    return H;
    
}

#pragma mark - done


- (void)done {
    
    self.req.userId = [YJYSettingManager sharedInstance].userId;

    self.req.agencyName = self.agentNameLabel.text;
    self.req.agencyRelation = self.agentRelationshipLabel.text;
    self.req.agencyPhone = self.agentPhoneLabel.text;
    
    
    self.req.userStatusRemark = self.clientStateTextView.text;
    self.req.securityAssess = self.secureTextView.text;
    
    if (self.req.kinsId == 0) {
        [SYProgressHUD showInfoText:@"请选择参保人"];
        return;
    }
    
    if (self.req.addrId == 0) {
        [SYProgressHUD showInfoText:@"请选择联系信息"];
        return;
    }
    if (self.req.assessId == 0) {
        [SYProgressHUD showInfoText:@"请去ADL评分"];
        return;
    }
    
    if (self.req.userStatusRemark.length == 0) {
        [SYProgressHUD showInfoText:@"请输入客户状态描述"];
        return;
    }
    
//    if (self.req.securityAssess.length == 0) {
//        [SYProgressHUD showInfoText:@"请输入风险评估描述"];
//        return;
//    }
    
   
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        YJYInsureCreateUserKowningController *vc = [YJYInsureCreateUserKowningController instanceWithStoryBoard];
        vc.req = self.req;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPAddInsure  message:self.req controller:self command:APP_COMMAND_SaasappaddInsure success:^(id response) {
        
        
        AddInsureRsp *rsp = [AddInsureRsp parseFromData:response error:nil];
        
        YJYInsureDetailController *vc = [YJYInsureDetailController instanceWithStoryBoard];
        vc.insureNo = rsp.insureNo;
        vc.hasToBackRoot = YES;
        vc.didDismissBlock = ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        };
        [self.navigationController pushViewController:vc animated:YES];

    } failure:^(NSError *error) {
        
    }];
    
}
@end

#pragma mark - YJYInsureCreateController

@interface YJYInsureCreateController ()

@property (strong, nonatomic) YJYInsureCreateContentController *contentVC;
@end

@implementation YJYInsureCreateController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureCreateController *)[UIStoryboard storyboardWithName:@"YJYInsureCreate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureCreateContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.contactPhone = self.contactPhone;
        self.contentVC.isSearch = self.isSearch;

    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)done:(id)sender {
    
    [self.contentVC done];
}

@end
