//
//  YJYInsureDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/10/19.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureDetailController.h"
#import "YJYLongNurseWebController.h"
#import "YJYNurseWorkerController.h"
#import "YJYOrderCreateController.h"
#import "YJYInsurePorcessController.h"
#import "YJYInsureDisableView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>
#import "YJYSignatureController.h"
#import "YJYInsureChooseServiceController.h"
#import "YJYInsureOrderNurseListController.h"

typedef NS_ENUM(NSInteger, YJYInsureDetailType) {
    
    YJYInsureDetailTypeBasic, //基本
    YJYInsureDetailTypeNewProcess,
    
    YJYInsureDetailTypeBasicInfoTip,//参保人
    YJYInsureDetailTypeBasicInfoContent,
    
    YJYInsureDetailTypeAgentTip,//代理人
    YJYInsureDetailTypeAgentTipContent,
    
    YJYInsureDetailTypeApplyInfoTip, //申请单信息
    YJYInsureDetailTypeApplyInfoContent,

    YJYInsureDetailTypeHMReviewTip,// 健康经理评估
    YJYInsureDetailTypeHMReviewADL,
    YJYInsureDetailTypeHMClientStateText,
    YJYInsureDetailTypeHMSecurityInfoText,
    YJYInsureDetailTypeHMReviewBlank,
    
    YJYInsureDetailTypeCustomerServiceInfo, // 客服审核意见
    YJYInsureDetailTypeCustomerServicePassTime,
    YJYInsureDetailTypeCustomerServiceMarkText,
    YJYInsureDetailTypeCustomerServiceBlank,
    
    YJYInsureDetailTypeNurseReviewInfo, // 护士评估
    YJYInsureDetailTypeNurseReviewName,
    YJYInsureDetailTypeNurseReviewAdl,
    YJYInsureDetailTypeNurseSickIntroText,
    YJYInsureDetailTypeNurseDisable,
    YJYInsureDetailTypeNurseOtherImages,
    YJYInsureDetailTypeNurseMarksText,
    YJYInsureDetailTypeNurseReviewDescribeText,
    YJYInsureDetailTypeNurseReviewResultText,
    YJYInsureDetailTypeNurseReviewBlank,

    YJYInsureDetailTypeProInfo, // 客服审核意见
    YJYInsureDetailTypeProReviewTime,
    YJYInsureDetailTypeProReviewNurse,
    YJYInsureDetailTypeProReview,
};

typedef NS_ENUM(NSInteger, YJYInsureApplyContentType) {
    
    YJYInsureApplyContentTypeNumber,
    YJYInsureApplyContentTypeLevel,
    YJYInsureApplyContentTypeTreatment,
    YJYInsureApplyContentTypeReviewType,
    YJYInsureApplyContentTypeGetType,
    YJYInsureApplyContentTypeAgentSign,
    YJYInsureApplyContentTypeAgentPic
};

typedef void(^DidSaveBlock)();
typedef void(^DidLoadRspBlock)();


#pragma -mark 1.参保人基本信息
@interface YJYInsureBasicContentController : UITableViewController<MDHTMLLabelDelegate>


@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *adlLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *kinADLButton;

@property (strong, nonatomic) KinsfolkVO *kinsfolkVO;
@property (strong, nonatomic) InsureNOModel *insureNo;
@property (strong, nonatomic) InsureListVO *insureListVO;

@end

@implementation YJYInsureBasicContentController


- (IBAction)toCheckImageAction:(UIButton *)sender {

    NSString *imgURL;
    if (sender.tag == 0) {

        imgURL = self.kinsfolkVO.idPicURL;

    }else if (sender.tag == 1) {

        imgURL = self.kinsfolkVO.idPic2URL;

    }else if (sender.tag == 2) {

        imgURL = self.kinsfolkVO.kinsfolkImgURL;

    }else if (sender.tag == 3) {

        imgURL = self.kinsfolkVO.healthCareImgURL;
    }
    
    [XLPhotoBrowser showPhotoBrowserWithImages:@[imgURL] currentImageIndex:0];

}

- (IBAction)checkKinsADL:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?insureNO=%@&edit=%@&assessType=%@&kinsId=%@",kUserassessURL,self.insureNo.insureNo,@"false",@(2),@(self.kinsfolkVO.kinsId)];
    
    YJYLongNurseWebController *vc = [YJYLongNurseWebController new];
    vc.urlString = urlString;
    vc.title = @"ADL评估";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MDHTMLLabelDelegate

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
    
}

@end

//
#pragma -mark 2.代理人信息

@interface YJYInsureAgentContentController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *agentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentRelationLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentPhoneLabel;
@property (strong, nonatomic) InsureNOModel *insureVO;

@end

@implementation YJYInsureAgentContentController

@end

//
#pragma -mark 3.申请单信息


@interface YJYInsureApplyContentController : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *applyNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyReviewTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyReceiveTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *applySignButton;
@property (weak, nonatomic) IBOutlet UIButton *applyBookButton;


@property (strong, nonatomic) InsureNOModel *insureVO;

@end

@implementation YJYInsureApplyContentController

- (void)setInsureVO:(InsureNOModel *)insureVO {
    
    _insureVO = insureVO;
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        [self.applySignButton setTitle:self.insureVO.userSignPic.length > 0 ? @"查看" : @"点击签名" forState:0];
        [self.applyBookButton setTitle:self.insureVO.entrustPic.length > 0 ? @"查看" : @"点击拍照" forState:0];
    }
    

}

- (IBAction)toCheckImageAction:(UIButton *)sender {
    
    NSString *imgURL;
    if (sender.tag == 0) {
        
        if (self.insureVO.userSignPic.length == 0) {
            
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
               
                [self toSignAction];

            }else {
                
                [SYProgressHUD showFailureText:@"没有委托人签名照片"];
            }
            return;
        }else {
            
            imgURL = self.insureVO.userSignPic;

        }
        
    }else if (sender.tag == 1) {
        
        if (self.insureVO.entrustPic.length == 0) {
            
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
                
                [self toUploadImage];

            }else {
                
                [SYProgressHUD showFailureText:@"没有委托书照片"];
            }
            
            return;
        }else {
            
            imgURL = self.insureVO.entrustPic;

        }
        
        
    }

    
    XLPhotoBrowser *b = [XLPhotoBrowser showPhotoBrowserWithImages:@[imgURL] currentImageIndex:0];
    b.backgroundColor = [UIColor whiteColor];
}


- (void)toSignAction {
    
    
    YJYSignatureController *vc = [YJYSignatureController new];
    vc.isInsure = YES;
    vc.didReturnImage = ^(NSString *imageID,NSString *imageURL) {
        
        SaveOrUpdateInsureReq *req = [SaveOrUpdateInsureReq new];
        req.insureNo = self.insureVO.insureNo;
        req.userSignPic = imageID;

        [SYProgressHUD showLoadingWindowText:@"正在上传"];

        
        [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateInsure message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateInsure success:^(id response) {
            
            [self.applySignButton setTitle:@"查看" forState:0];
            self.insureVO.userSignPic = imageURL;
            
            [SYProgressHUD showSuccessText:@"上传成功"];
            
        } failure:^(NSError *error) {
            
        }];
        
    };
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)toUploadImage {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                [SYProgressHUD showLoadingWindowText:@"正在上传"];
                
                [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
                    
                    NSString *imageID = response[@"imageId"];
                    NSString *imageURL = response[@"imgUrl"];
                    
                    
                    SaveOrUpdateInsureReq *req = [SaveOrUpdateInsureReq new];
                    req.insureNo = self.insureVO.insureNo;
                    req.entrustPic = imageID;

                    [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateInsure message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateInsure success:^(id response) {
                        
                        [self.applyBookButton setTitle:@"查看" forState:0];
                        self.insureVO.entrustPic = imageURL;
                        
                        [SYProgressHUD showSuccessText:@"上传成功"];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    
                    
                } failure:^(NSError *error) {
                    
                    [SYProgressHUD showFailureText:@"上传失败"];
                    
                    
                }];
                
                
            } cancel:^{
                
                [SYProgressHUD hide];
                
                
            }];
        }
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.row == YJYInsureApplyContentTypeAgentPic){
        
        if ([YJYRoleManager sharedInstance].roleType != YJYRoleTypeSupervisor) {
            H = 0;
        }
    }
    
    return H;
    
}


@end




#pragma -mark  YJYInsureDetailContentController
@interface YJYInsureDetailContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *processLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *nurseReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *nurseLabel;
@property (weak, nonatomic) IBOutlet UILabel *nurseADLLabel;
@property (weak, nonatomic) IBOutlet UITextView *nurseIntroTextView;
@property (weak, nonatomic) IBOutlet UIButton *disableYESButton;
@property (weak, nonatomic) IBOutlet UIButton *disableNOButton;

//
@property (weak, nonatomic) IBOutlet UIView *disableView;
@property (strong, nonatomic) YJYInsureDisableView *insureDisableView;
@property (weak, nonatomic) IBOutlet UILabel *yesInsureLabel;

@property (weak, nonatomic) IBOutlet UIView *otherImagesView;
@property (strong, nonatomic) YJYInsureDisableView *insureOtherImagesView;
@property (weak, nonatomic) IBOutlet UILabel *yesOtherLabel;
//
@property (weak, nonatomic) IBOutlet UITextView *nurseMarkTextView;
@property (weak, nonatomic) IBOutlet UITextView *nurseReviewDesTextView;
@property (weak, nonatomic) IBOutlet UITextView *nurseReviewResultTextView;
@property (weak, nonatomic) IBOutlet UILabel *nursePassIssue;
@property (weak, nonatomic) IBOutlet UIButton *nurseADLButton;

//
@property (weak, nonatomic) IBOutlet UILabel *hmReviewTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthManagerAdlLabel;
@property (weak, nonatomic) IBOutlet UITextView *clientStateTextView;
@property (weak, nonatomic) IBOutlet UITextView *safeReviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *hmADLCheckButton;

//
@property (weak, nonatomic) IBOutlet UILabel *customerReviewTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *customSuggestLabel;
@property (weak, nonatomic) IBOutlet UITextView *servicerMarkTextView;

//
@property (weak, nonatomic) IBOutlet UILabel *proTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proReCallTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proNurseLabel;
@property (weak, nonatomic) IBOutlet UITextView *proRviewResultTextView;


@property (weak, nonatomic) IBOutlet UILabel *proResultTipLabel;


//
@property (strong, nonatomic) YJYInsureBasicContentController *basicContentVC;
@property (strong, nonatomic) YJYInsureAgentContentController *agentContentVC;
@property (strong, nonatomic) YJYInsureApplyContentController *applyContentVC;




@property (strong, nonatomic) NSString *insureNo;

@property (strong, nonatomic) GetInsureDetailRsp *rsp;
@property (strong, nonatomic) InsureAssessReq *req;
@property (copy, nonatomic) DidLoadRspBlock didLoadRspBlock;


//expand
@property (assign, nonatomic) BOOL expandBasic;
@property (assign, nonatomic) BOOL expandAgent;
@property (assign, nonatomic) BOOL expandApply;
@property (assign, nonatomic) BOOL expandHM;
@property (assign, nonatomic) BOOL expandCS;
@property (assign, nonatomic) BOOL expandNurse;
@property (assign, nonatomic) BOOL expandPro;

@property (weak, nonatomic) IBOutlet UIButton *basicExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *applyExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *agentExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *hmExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *csExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *nurseExpandButton;
@property (weak, nonatomic) IBOutlet UIButton *proExpandButton;



//hidden
@property (assign, nonatomic) BOOL hiddenBasic;
@property (assign, nonatomic) BOOL hiddenAgent;
@property (assign, nonatomic) BOOL hiddenApply;
@property (assign, nonatomic) BOOL hiddenHM;
@property (assign, nonatomic) BOOL hiddenCS;
@property (assign, nonatomic) BOOL hiddenNurse;
@property (assign, nonatomic) BOOL hiddenPro;

//shadow

@property (weak, nonatomic) IBOutlet UIView *basicBg;
@property (weak, nonatomic) IBOutlet UIView *agentBg;
@property (weak, nonatomic) IBOutlet UIView *applyBg;
@property (weak, nonatomic) IBOutlet UIView *hmBg;
@property (weak, nonatomic) IBOutlet UIView *csBg;
@property (weak, nonatomic) IBOutlet UIView *nurseBg;
@property (weak, nonatomic) IBOutlet UIView *proBg;


@property (weak, nonatomic) IBOutlet UIView *oneTextView;
@property (weak, nonatomic) IBOutlet UIView *twoTextView;
@property (weak, nonatomic) IBOutlet UIView *threeTextView;
@property (weak, nonatomic) IBOutlet UIView *fourTextView;
@property (weak, nonatomic) IBOutlet UIView *fiveTextView;
@property (weak, nonatomic) IBOutlet UIView *sixTextView;
@property (weak, nonatomic) IBOutlet UIView *sevenTextView;


@end

@implementation YJYInsureDetailContentController



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureBasicContentController"]) {
        
        self.basicContentVC = segue.destinationViewController;
        self.processLabel.delegate = self.basicContentVC;

    }else if ([segue.identifier isEqualToString:@"YJYInsureAgentContentController"]) {
        
        self.agentContentVC = segue.destinationViewController;
        
    }else if ([segue.identifier isEqualToString:@"YJYInsureApplyContentController"]) {
        
        self.applyContentVC = segue.destinationViewController;
        
    }
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self setupImageView];

    self.req = [InsureAssessReq new];
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [SYProgressHUD show];
    [self loadNetworkData];
    
    [self.basicBg yjy_setBottomShadow];
    [self.agentBg yjy_setBottomShadow];
    [self.applyBg yjy_setBottomShadow];
    [self.hmBg yjy_setBottomShadow];
    [self.csBg yjy_setBottomShadow];
    [self.nurseBg yjy_setBottomShadow];
    [self.proBg yjy_setBottomShadow];
    [self setupTextViewBorder];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
   // [self loadNetworkData];
}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

}
#pragma mark -setup
- (void)setupTextViewBorder {
    
    self.oneTextView.layer.cornerRadius = 8;
    self.oneTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.oneTextView.layer.borderWidth = 0.5;
    
    self.twoTextView.layer.cornerRadius = 8;
    self.twoTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.twoTextView.layer.borderWidth = 0.5;
    
    self.threeTextView.layer.cornerRadius = 8;
    self.threeTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.threeTextView.layer.borderWidth = 0.5;
    
    
    self.fourTextView.layer.cornerRadius = 8;
    self.fourTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.fourTextView.layer.borderWidth = 0.5;
    
    
    self.fiveTextView.layer.cornerRadius = 8;
    self.fiveTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.fiveTextView.layer.borderWidth = 0.5;
    
    self.sixTextView.layer.cornerRadius = 8;
    self.sixTextView.layer.borderColor = APPNurseGrayRGBCOLOR.CGColor;
    self.sixTextView.layer.borderWidth = 0.5;
    
    self.sevenTextView.layer.cornerRadius = 8;
    self.sevenTextView.layer.borderColor = APPNurseGrayCOLOR.CGColor;
    self.sevenTextView.layer.borderWidth = 0.5;
    
}
- (void)setupImageView {
    
    __weak typeof(self) weakSelf = self;
    //1
    self.insureDisableView = [[YJYInsureDisableView alloc]initWithFrame:self.disableView.bounds];
    self.insureDisableView.imagesType = YJYInsureImagesTypeDisable;
    self.insureDisableView.didAddImageBlock = ^{
        
        
        [UIAlertController showAlertInViewController:weakSelf withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex > 0) {
                [weakSelf toSelectImagesActionWithType:YJYInsureImagesTypeDisable isTakePicture:buttonIndex == 3];

            }
            
            
        }];
        
    };
    self.insureDisableView.didSelectBlock = ^(NSString *imgurl, NSInteger index) {

        [XLPhotoBrowser showPhotoBrowserWithImages:weakSelf.insureDisableView.picArray currentImageIndex:index];

    };
    
    self.disableView.backgroundColor = [UIColor clearColor];
    [self.disableView addSubview:self.insureDisableView];
    
 
    
    //2
    self.insureOtherImagesView = [[YJYInsureDisableView alloc]initWithFrame:self.otherImagesView.bounds];
    self.insureOtherImagesView.imagesType = YJYInsureImagesTypeOther;
    self.insureOtherImagesView.didAddImageBlock = ^{
        
        
        [UIAlertController showAlertInViewController:weakSelf withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            
            if (buttonIndex > 0) {
                [weakSelf toSelectImagesActionWithType:YJYInsureImagesTypeOther isTakePicture:buttonIndex == 3];
                
            }
          
            
        }];
    };
    self.insureOtherImagesView.didSelectBlock = ^(NSString *imgurl, NSInteger index) {
        
        [XLPhotoBrowser showPhotoBrowserWithImages:weakSelf.insureOtherImagesView.picArray currentImageIndex:index];

    };
    
    self.otherImagesView.backgroundColor = [UIColor clearColor];
    [self.otherImagesView addSubview:self.insureOtherImagesView];
    
}
- (void)loadNetworkData {
    
    GetInsureDetailReq*req = [GetInsureDetailReq new];
    req.insureId = self.insureNo;


    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureDetail message:req controller:self command:APP_COMMAND_SaasappgetInsureDetail success:^(id response) {
        
        
        self.rsp = [GetInsureDetailRsp parseFromData:response error:nil];
        [self setupRsp];
        if (self.didLoadRspBlock) {
            self.didLoadRspBlock();
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

#pragma mark - 数据


- (void)setupRsp {
    

    //1 基础信息
    [self setupBasic];
    
   
    //2 申请单跟代理人
    
    [self setupAgentAndApply];
    
    //5.健康经理评估
  
    [self setupHM];
    
    //6.客服审核意见
    
    [self setupCS];
    
    //7.护士

    [self setupNurse];

    //8. 专家
 
    [self setupPro];
    
    //9.相册
   
    [self setupDisableImages];
    
    // reload
    
    [self setupReloadAll];
 
}

- (void)setupBasic {
    
    InsureNOModel *insureVO = self.rsp.insureNo;
    KinsfolkVO *kinsfolk = self.rsp.kinsfolk;
    
    //1.基础
    self.nameLabel.text = insureVO.kinsName;
    self.sexLabel.text = insureVO.sex == 1 ? @"男" : @"女";
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",@(insureVO.age)];
    
    InsureNODetailVO *insureNODetailVO = self.rsp.detailListArray.firstObject;
    self.processLabel.htmlText = [NSString stringWithFormat:@"最新进度 %@ %@",insureNODetailVO.createTime,insureNODetailVO.content];
    
    
    //2.参保人基本信息
    self.basicContentVC.kinsfolkVO = kinsfolk;
    self.basicContentVC.insureNo = insureVO;
    self.basicContentVC.IDLabel.text = kinsfolk.idCardNo;
    if (kinsfolk.staffType == 0) {
        self.basicContentVC.personTypeLabel.text = @"无";
    }else {
        self.basicContentVC.personTypeLabel.text = kinsfolk.staffType == 2 ? @"退休" : @"在职";
        
    }
    
    self.basicContentVC.insureTypeLabel.text = kinsfolk.medicare;
    if (self.rsp.scoreAdl == -1) {
        self.basicContentVC.adlLabel.text = @"无";
        self.basicContentVC.kinADLButton.hidden = YES;
    }else {
        self.basicContentVC.kinADLButton.hidden = NO;
        self.basicContentVC.adlLabel.text = [NSString stringWithFormat:@"%@分",@(self.rsp.scoreAdl)];
        
    }
    self.basicContentVC.contactLabel.htmlText = [NSString yjy_ContactStringWithContact:insureVO.name phone:insureVO.phone];
    self.basicContentVC.contactAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@",insureVO.province,insureVO.city,insureVO.district,insureVO.building,insureVO.addrDetail];
}
- (void)setupAgentAndApply {
    
    
    InsureNOModel *insureVO = self.rsp.insureNo;
    
    //3.代理人信息
    self.agentContentVC.insureVO = insureVO;
    self.agentContentVC.agentNameLabel.text = insureVO.agencyName;
    self.agentContentVC.agentRelationLabel.text = insureVO.agencyRelation;
    self.agentContentVC.agentPhoneLabel.text = insureVO.agencyPhone;
    
    //4.申请单信息
    self.applyContentVC.insureVO = insureVO;
    self.applyContentVC.applyNoLabel.text = insureVO.insureNo;
    self.applyContentVC.applyLevelLabel.text = insureVO.applyTreatmentType == 1 ? @"生活照料" : @"生活照料+医疗护理";
    self.applyContentVC.applyTypeLabel.text = insureVO.treatmentType == 1 ? @"机构护理" : @"居家护理";
    self.applyContentVC.applyReceiveTypeLabel.text = insureVO.insureGetType == 1 ? @"邮寄" : @"自行领取";
    if (insureVO.assessType == 1) {
        self.applyContentVC.applyReviewTypeLabel.text = @"首次评估";
    }else {
        self.applyContentVC.applyReviewTypeLabel.text = insureVO.assessType == 2 ? @"复检评估" : @"变更评估";
    }
    
    
}
- (void)setupHM {
    
    InsureNOModel *insureVO = self.rsp.insureNo;

    
    self.hmReviewTimeLabel.text = [NSString stringWithFormat:@"健康经理评估  %@",self.rsp.managerAssessTimeStr];
    self.healthManagerAdlLabel.text = [NSString stringWithFormat:@"%@分",@(insureVO.dudaoScoreAdl)];
    self.clientStateTextView.text = insureVO.userStatusRemark;
    self.safeReviewTextView.text = insureVO.securityAssess;
    
    [self.hmADLCheckButton setTitle:insureVO.dudaoScoreAdl == -1 ? @"编辑" : @"查看" forState:0];
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
        (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview || self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse)) {
        [self.hmADLCheckButton setTitle:@"编辑" forState:0];
    }
}
- (void)setupCS {
//    InsureNOModel *insureVO = self.rsp.insureNo;

    self.customerReviewTimeLabel.text = [NSString stringWithFormat:@"客服审核意见  %@",self.rsp.kfTimeStr];
    self.customSuggestLabel.text =  [NSString stringWithFormat:@"%@",self.rsp.appointTimeStr];
    self.servicerMarkTextView.text = self.rsp.kfStatusStr;
}
- (void)setupNurse {
    
    InsureNOModel *insureVO = self.rsp.insureNo;
    
    self.nurseReviewLabel.text = [NSString stringWithFormat:@"护士评估 :%@",self.rsp.assessTimeStr];
    self.nurseLabel.text = insureVO.nurseName.length > 0 ? insureVO.nurseName : @"未指派";
    self.nurseIntroTextView.text = insureVO.hsCasePresentation;
    self.nurseMarkTextView.text = insureVO.hsRemark;
    self.nurseReviewDesTextView.text = insureVO.medicalHistory;
    self.nurseReviewResultTextView.text = self.rsp.loseNoPassRemark;
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
        self.nursePassIssue.text = @"";
    }else {
        self.nursePassIssue.text =  self.rsp.assessStatus ? @"通过" : @"不通过";
        
    }
    self.nurseADLLabel.text = insureVO.scoreAdl == -1 ? @"无" : [NSString stringWithFormat:@"%@分", @(insureVO.scoreAdl)];
    [self.nurseADLButton setTitle:insureVO.scoreAdl == -1 ? @"编辑" : @"查看" forState:0];
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
        (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview || self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse)) {
        [self.nurseADLButton setTitle:@"编辑" forState:0];
    }
}


- (void)setupPro {
    
    InsureNOModel *insureVO = self.rsp.insureNo;
    
    
    self.proReCallTimeLabel.text = self.rsp.appointTimeStr;
    self.proNurseLabel.text = insureVO.loseNurseName.length > 0 ? insureVO.loseNurseName : @"未指派";
    
    
    
    //复审备注
    
    
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {

        self.proResultTipLabel.text = @"现场评估备注";
        self.proRviewResultTextView.text = self.rsp.insureNo.loseRemark;
    }else {

        self.proResultTipLabel.text = @"评审结果";
        self.proRviewResultTextView.text = self.rsp.loseAppointStatus ? @"评审通过" : [NSString stringWithFormat:@"评审不通过，评审结果有效期至%@",self.rsp.aptitudeEndTimeStr];


    }

}

- (void)setupDisableImages {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
        self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
        
        [self toChooseDisableAction:self.disableNOButton];

    }else {
           [self toChooseDisableAction:self.rsp.insureNo.isAmentia == 0 ? self.disableNOButton : self.disableYESButton];
    }
 

    
    BOOL hiddenButton = YES;
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
        (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview ||
         self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse)) {
        hiddenButton = NO;
        
    }
    self.yesInsureLabel.text = self.rsp.insureNo.isAmentia ? @"是" : @"否";
    self.yesInsureLabel.hidden = !hiddenButton;
    self.disableYESButton.hidden = hiddenButton;
    self.disableNOButton.hidden = hiddenButton;
    self.yesOtherLabel.hidden = self.rsp.insureNo.caseDiagnosePicArray_Count > 0 || !hiddenButton;
    
    self.insureDisableView.insureNo = self.rsp.insureNo;
    self.insureDisableView.picURLIdArray = self.rsp.dysgnosiaePicURLIdArray;
    
    self.insureOtherImagesView.insureNo = self.rsp.insureNo;
    self.insureOtherImagesView.picURLIdArray = self.rsp.caseDiagnosePicURLIdArray;
}

- (void)setupReloadAll {
    
    [self setupHiddenAndDisable];
    [self setupExpand];
    [self setupTextViewEdit];
    
    [self.insureDisableView.collectionView reloadData];
    [self.insureOtherImagesView.collectionView reloadData];
    
    [self reloadAllData];

    
}
#pragma mark - 模块展开收起

- (void)setupExpand {
    
    //护士长 + //健康经理
    self.expandBasic = YES; self.expandAgent = YES; self.expandApply = YES; self.expandHM = YES; self.expandCS = YES; self.expandNurse = YES; self.expandPro = YES;

    //护士
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
            
            self.expandBasic = NO; self.expandAgent = NO; self.expandCS = NO; self.expandHM = NO;
            self.expandApply =  NO;//self.rsp.insureNo.entrustPic.length > 0 && self.rsp.insureNo.userSignPic.length > 0 ? NO : YES;
            self.expandNurse = YES;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse) {
            
            self.expandBasic = YES; self.expandAgent = YES; self.expandApply = YES; self.expandHM = YES; self.expandCS = NO; self.expandNurse = YES;
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
            
            self.expandBasic = YES; self.expandAgent = YES; self.expandApply = YES; self.expandHM = YES; self.expandCS = NO; self.expandNurse = YES;

        }

    }
    
    [self.basicExpandButton setImage:[UIImage imageNamed:self.expandBasic ? @"order_down_icon" : @"order_up_icon"] forState:0];
    [self.applyExpandButton setImage:[UIImage imageNamed:self.expandApply ? @"order_down_icon" : @"order_up_icon"] forState:0];
    [self.agentExpandButton setImage:[UIImage imageNamed:self.expandAgent ? @"order_down_icon" : @"order_up_icon"] forState:0];
    [self.csExpandButton setImage:[UIImage imageNamed:self.expandCS ? @"order_down_icon" : @"order_up_icon"] forState:0];
    [self.hmExpandButton setImage:[UIImage imageNamed:self.expandHM ? @"order_down_icon" : @"order_up_icon"] forState:0];
    [self.nurseExpandButton setImage:[UIImage imageNamed:self.expandNurse ? @"order_down_icon" : @"order_up_icon"] forState:0];
    [self.proExpandButton setImage:[UIImage imageNamed:self.expandPro ? @"order_down_icon" : @"order_up_icon"] forState:0];


}

#pragma mark - 模块隐藏显示
- (void)setupHiddenAndDisable {
    
    
    //护士
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
            
            //护士初审
            self.hiddenPro = YES;
            self.hiddenHM = self.rsp.insureNo.entrustPic.length > 0 && self.rsp.insureNo.entrustPic.length > 0 ? NO :YES;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse) {
            //初审驳回
            self.hiddenPro = YES;
            self.hiddenHM = YES;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
            //复审中
            self.hiddenPro = NO;
            self.hiddenHM = YES;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateWaitReSubmitReview ||
                  self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
            
            //等待提交复审 复审拒绝
            self.hiddenPro = self.rsp.insureNo.status != YJYInsureTypeStateReReviewRefuse;
            self.hiddenHM = NO;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateWaitReReview ||
                  self.rsp.insureNo.status == YJYInsureTypeStateClose) {
            
            //等待复审 复审关闭
            self.hiddenPro = YES;
            self.hiddenHM = NO;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass) {
            
            //复审通过
            self.hiddenPro = NO;
            self.hiddenHM = NO;
            
        }
       
     //护士长
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
            
            self.hiddenPro = YES;
            self.hiddenHM = NO;
         
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
            //复审中
            self.hiddenPro = NO;
            self.hiddenHM = YES;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateWaitReReview ||
                  self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
            
            //等待提交复审 等待拒绝
            self.hiddenPro = YES;
            self.hiddenHM = NO;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing ||
                  self.rsp.insureNo.status == YJYInsureTypeStateClose) {
            
            //等待复审 复审关闭
            self.hiddenPro = YES;
            self.hiddenHM = NO;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass) {
            
            //复审通过
            self.hiddenPro = NO;
            self.hiddenHM = NO;
            
        }
     //健康经理
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        

        if (self.rsp.insureNo.status == YJYInsureTypeStateCSReviewing || self.rsp.insureNo.status == YJYInsureTypeStateCSRefuse) {
           // 健康经理端-客服审核阶段

            self.hiddenCS = self.rsp.insureNo.status == YJYInsureTypeStateCSRefuse ? NO : YES;
            self.hiddenNurse = YES;
            self.hiddenPro = YES;

        }else if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview  || self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse) {

            //健康经理端-护士评估
            self.hiddenCS = NO;
            self.hiddenNurse = self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse ? NO : YES;
            self.hiddenPro = YES;
   

        }else if (self.rsp.insureNo.status == YJYInsureTypeStateWaitReSubmitReview  || self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {

            //等待提交复审(健康经理/护士/护士长）
            self.hiddenCS = NO;
            self.hiddenNurse = NO;
            self.hiddenPro = !self.rsp.loseAppointStatus;

            
    
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateWaitReReview  || self.rsp.insureNo.status == YJYInsureTypeStateClose) {
            
            //等待复审(健康经理/护士/护士长
            self.hiddenCS = NO;
            self.hiddenNurse = NO;
            self.hiddenPro = YES;
           
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing  || self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
            
            self.hiddenCS = NO;
            self.hiddenNurse = NO;
            self.hiddenPro = self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse ? NO : YES;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass) {
            
            self.hiddenCS = NO;
            self.hiddenNurse = NO;
            self.hiddenPro = NO;
            
        }
        
    }
    
    self.hiddenHM = !self.rsp.isManagerShow;

}

#pragma mark - TextViewEdit

- (void)setupTextViewEdit {
    

    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
            
            self.nurseIntroTextView.userInteractionEnabled = YES;
            self.nurseReviewDesTextView.userInteractionEnabled = YES;
            self.nurseMarkTextView.userInteractionEnabled = YES;
            self.nurseReviewResultTextView.userInteractionEnabled = YES;

            self.clientStateTextView.userInteractionEnabled = NO;
            self.safeReviewTextView.userInteractionEnabled = NO;
            self.proRviewResultTextView.userInteractionEnabled = NO;

            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse) {
            
            self.nurseIntroTextView.userInteractionEnabled = NO;
            self.nurseReviewDesTextView.userInteractionEnabled = NO;
            self.nurseMarkTextView.userInteractionEnabled = NO;
            self.nurseReviewResultTextView.userInteractionEnabled = NO;

            self.proRviewResultTextView.userInteractionEnabled = NO;
            self.clientStateTextView.userInteractionEnabled = NO;
            self.safeReviewTextView.userInteractionEnabled = NO;
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
            
            self.nurseIntroTextView.userInteractionEnabled = NO;
            self.nurseReviewDesTextView.userInteractionEnabled = NO;
            self.nurseMarkTextView.userInteractionEnabled = NO;
            self.nurseReviewResultTextView.userInteractionEnabled = NO;

            
            self.proRviewResultTextView.userInteractionEnabled = YES;
            self.clientStateTextView.userInteractionEnabled = NO;
            self.safeReviewTextView.userInteractionEnabled = NO;
        }else {
            
            self.nurseIntroTextView.userInteractionEnabled = NO;
            self.nurseReviewDesTextView.userInteractionEnabled = NO;
            self.nurseMarkTextView.userInteractionEnabled = NO;
            self.nurseReviewResultTextView.userInteractionEnabled = NO;

            self.proRviewResultTextView.userInteractionEnabled = NO;
            self.clientStateTextView.userInteractionEnabled = NO;
            self.safeReviewTextView.userInteractionEnabled = NO;
        }
        
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        
        self.nurseIntroTextView.userInteractionEnabled = NO;
        self.nurseReviewDesTextView.userInteractionEnabled = NO;
        self.nurseMarkTextView.userInteractionEnabled = NO;
        self.nurseReviewResultTextView.userInteractionEnabled = NO;

        self.proRviewResultTextView.userInteractionEnabled = NO;
        self.clientStateTextView.userInteractionEnabled = NO;
        self.safeReviewTextView.userInteractionEnabled = NO;
    }else {
        
        self.nurseIntroTextView.userInteractionEnabled = NO;
        self.nurseReviewDesTextView.userInteractionEnabled = NO;
        self.nurseMarkTextView.userInteractionEnabled = NO;
        self.nurseReviewResultTextView.userInteractionEnabled = NO;

        self.proRviewResultTextView.userInteractionEnabled = NO;
        self.clientStateTextView.userInteractionEnabled = NO;
        self.safeReviewTextView.userInteractionEnabled = NO;
    }
    
    self.servicerMarkTextView.userInteractionEnabled = NO;


    
}

#pragma mark - Action

- (void)toSelectImagesActionWithType:(YJYInsureImagesType)type isTakePicture:(BOOL)isTakePicture{
    
    
    if (!isTakePicture) {
        
        NSInteger maxSelectCount = 0;
        if (type == YJYInsureImagesTypeDisable) {
            maxSelectCount = 9 - self.insureDisableView.picArray.count;
        }else if (type == YJYInsureImagesTypeOther) {
            
            maxSelectCount = 9 - self.insureOtherImagesView.picArray.count;
            
        }
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxSelectCount delegate:nil];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self toUploadImags:photos type:type];

        }];
    
        [self presentViewController:imagePickerVc animated:YES completion:nil];
  
    }else {
        
        
        [[SSPhotoPickerManager sharedSSPhotoPickerManager] showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            
            UIImage *i = [YJYNetworkManager cropImage:image scale:0.3];
            NSData * data =UIImageJPEGRepresentation(i,1);
            image = [UIImage imageWithData:data];
            
            [self toUploadImags:@[image] type:type];

        } cancel:^{
            
        }];
    }
  
    
}
- (void)toUploadImags:(NSArray *)images type:(YJYInsureImagesType)type{
    
    NSString *uploadURL = [NSString stringWithFormat:@"%@?type=%@",UploadImage,kHeadimg];

    [SYProgressHUD show];
    [YJYNetworkManager CRPOSTUploadtWithRequestUrl:uploadURL withParameter:@{@"name":@"file"} withImageArray:images WithReturnValueBlock:^(id responder) {
        
        NSArray *imageArray = responder[@"imageArray"];
        if (imageArray && [imageArray count]) {
            
            NSMutableArray<NSString *> *urls = [NSMutableArray array];
            NSMutableArray<NSString *> *imageIds = [NSMutableArray array];
            for (NSDictionary *dict in imageArray) {
                [urls addObject:dict[@"imgUrl"]];
                [imageIds addObject:dict[@"imageId"]];
            }
            
            NSMutableArray *imageStrIDs = [NSMutableArray array];
            for (NSNumber *ids in imageIds) {
                [imageStrIDs addObject:[NSString stringWithFormat:@"%@",ids]];
            }
            
            if (type == YJYInsureImagesTypeDisable) {
                
                [self.insureDisableView.picArray addObjectsFromArray:urls];
                [self.insureDisableView.imageIds addObjectsFromArray:imageStrIDs];
                [self.tableView reloadData];
                [self.insureDisableView.collectionView reloadData];
                
            }else {
                [self.insureOtherImagesView.picArray addObjectsFromArray:urls];
                [self.insureOtherImagesView.imageIds addObjectsFromArray:imageStrIDs];
                [self.tableView reloadData];
                [self.insureOtherImagesView.collectionView reloadData];
                
            }
            [SYProgressHUD hide];
            
        }else {
            
            [SYProgressHUD hide];
            
        }
        
        
        
        
    } errorCodeBlock:^(id errorCode) {
        
        [SYProgressHUD showFailureText:@"网络错误"];

    }];
    
}

- (IBAction)toExpandAction:(UIButton *)sender {
    
    if (sender.tag == 0) {
        
        self.expandBasic = !self.expandBasic;
        [sender setImage:[UIImage imageNamed:self.expandBasic ? @"order_down_icon" : @"order_up_icon"] forState:0];
    }else if (sender.tag == 1) {
        self.expandAgent = !self.expandAgent;
        [sender setImage:[UIImage imageNamed:self.expandAgent ? @"order_down_icon" : @"order_up_icon"] forState:0];
        
    }else if (sender.tag == 2) {
        self.expandApply = !self.expandApply;
        [sender setImage:[UIImage imageNamed:self.expandApply ? @"order_down_icon" : @"order_up_icon"] forState:0];
        
    }else if (sender.tag == 3) {
        self.expandHM = !self.expandHM;
        [sender setImage:[UIImage imageNamed:self.expandHM ? @"order_down_icon" : @"order_up_icon"] forState:0];
        
    }else if (sender.tag == 4) {
        self.expandCS = !self.expandCS;
        [sender setImage:[UIImage imageNamed:self.expandCS ? @"order_down_icon" : @"order_up_icon"] forState:0];
        
    }else if (sender.tag == 5) {
        self.expandNurse = !self.expandNurse;
        [sender setImage:[UIImage imageNamed:self.expandNurse ? @"order_down_icon" : @"order_up_icon"] forState:0];
        
    }else if (sender.tag == 6) {
        self.expandPro = !self.expandPro;
        [sender setImage:[UIImage imageNamed:self.expandPro ? @"order_down_icon" : @"order_up_icon"] forState:0];
        
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == YJYInsureDetailTypeBasicInfoTip){
        
        self.basicBg.hidden = !self.expandBasic;
        cell.contentView.superview.clipsToBounds = !self.expandBasic;
        
        self.expandBasic ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
       
        
    }else if (indexPath.row == YJYInsureDetailTypeAgentTip){
     
        self.agentBg.hidden = !self.expandAgent;
        cell.contentView.superview.clipsToBounds = !self.expandAgent;
        self.expandAgent ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
        
    }else if (indexPath.row == YJYInsureDetailTypeApplyInfoTip){
       
        self.applyBg.hidden = !self.expandApply;
    

        cell.contentView.superview.clipsToBounds = !self.expandApply;
        self.expandApply ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
        
    }else  if (indexPath.row == YJYInsureDetailTypeHMReviewTip){
       
        self.hmBg.hidden = !self.expandHM;
        self.hmBg.hidden = self.hiddenHM;
        self.hmReviewTimeLabel.hidden = self.hiddenHM;

        cell.contentView.superview.clipsToBounds = !self.expandHM;
        self.expandHM ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
        
    }else if (indexPath.row == YJYInsureDetailTypeCustomerServiceInfo){
       
        self.csBg.hidden = !self.expandCS;
        self.csBg.hidden = self.hiddenCS;
        self.customerReviewTimeLabel.hidden = self.hiddenCS;
        cell.contentView.superview.clipsToBounds = !self.expandCS;
        self.expandCS ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
        
    }else if (indexPath.row == YJYInsureDetailTypeNurseReviewInfo){
      
        
        self.nurseBg.hidden = !self.expandNurse;
        self.nurseBg.hidden = self.hiddenNurse;
        self.nurseReviewLabel.hidden = self.hiddenNurse;
        cell.contentView.superview.clipsToBounds = !self.expandNurse;
        self.expandNurse ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
        
    }else if (indexPath.row == YJYInsureDetailTypeProInfo){
       
        
        self.proBg.hidden = !self.expandPro;
        self.proBg.hidden = self.hiddenPro;
        self.proTimeLabel.hidden = self.hiddenPro;

        
        cell.contentView.superview.clipsToBounds = !self.expandPro;
        self.expandPro ? [cell.superview bringSubviewToFront:cell] : [cell.superview sendSubviewToBack:cell];
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];

    
    //textView
    
    height = [self setupCellTextViewTableView:tableView heightForRowAtIndexPath:indexPath heigth:height];
    
    //image
    
    height = [self setupImageViewTableView:tableView heightForRowAtIndexPath:indexPath heigth:height];
    
    //Role
    
    height = [self setupRoleCellHiddenTableView:tableView heightForRowAtIndexPath:indexPath heigth:height];
    
    //expand
    
    height = [self setupExpandTableView:tableView heightForRowAtIndexPath:indexPath heigth:height];
    
 
    //hidden & display
    
    height = [self setupHiddenTableView:tableView heightForRowAtIndexPath:indexPath heigth:height];
    
    
    

  
    
    return height;
   
}

- (CGFloat)setupImageViewTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath heigth:(CGFloat)height {

    //相册
    
    if (indexPath.row == YJYInsureDetailTypeNurseDisable) {
        
        self.disableView.hidden = !self.rsp.insureNo.isAmentia;
        height = self.rsp.insureNo.isAmentia == 0 ? 50 : [self.insureDisableView cellHeight];
        if (!self.expandNurse) {
            height = 0;
        }
        
    }else if (indexPath.row == YJYInsureDetailTypeNurseOtherImages) {
        
        height = [self.insureOtherImagesView cellHeight];
    }
    
    return height;
}

- (CGFloat)setupCellTextViewTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath heigth:(CGFloat)height {
    
    NSString *textViewStr = @"";
    
    if (indexPath.row == YJYInsureDetailTypeHMClientStateText) {
       
        textViewStr = self.clientStateTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeHMSecurityInfoText) {
        
        textViewStr = self.safeReviewTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeCustomerServiceMarkText) {
        
        textViewStr = self.clientStateTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeNurseSickIntroText) {
        
        textViewStr = self.nurseIntroTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeNurseReviewDescribeText) {
        
        textViewStr = self.nurseReviewDesTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeNurseMarksText) {
        
        textViewStr = self.nurseMarkTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeNurseReviewResultText) {
        
        textViewStr = self.nurseReviewResultTextView.text;
        
    }else if (indexPath.row == YJYInsureDetailTypeProReview) {
        
        textViewStr = self.proRviewResultTextView.text;
        
    }
    
    if (indexPath.row == YJYInsureDetailTypeHMClientStateText ||
        indexPath.row == YJYInsureDetailTypeHMSecurityInfoText ||
        indexPath.row == YJYInsureDetailTypeCustomerServiceMarkText ||
        indexPath.row == YJYInsureDetailTypeNurseSickIntroText ||
        indexPath.row == YJYInsureDetailTypeNurseReviewDescribeText ||
        indexPath.row == YJYInsureDetailTypeNurseMarksText ||
        indexPath.row == YJYInsureDetailTypeNurseReviewResultText||
        indexPath.row == YJYInsureDetailTypeProReview) {
        
        
        CGSize size = [textViewStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 36 - 36 - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        height =  size.height + 90;
      
        
    }
    
    return height;
    
    
}
- (CGFloat)setupRoleCellHiddenTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath heigth:(CGFloat)heigth{

    
    //护士
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse) {
        
        
        if (indexPath.row ==  YJYInsureDetailTypeProReviewTime || indexPath.row == YJYInsureDetailTypeProReviewNurse) {
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass ||
                self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
                
                
                heigth = 0;

            }
        }else if (indexPath.row == YJYInsureDetailTypeNurseReviewDescribeText){
            
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass ||
                self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
                
                heigth = 0;

            }
            
        }else if (indexPath.row == YJYInsureDetailTypeNurseReviewResultText) {
            
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass ||
                self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
                
                // 护士初审是否通过
                if (self.rsp.assessStatus && self.expandNurse) {
                    heigth = 50;
                }
            }else {
                
                heigth = 0;
            
            }
        }
        
    //护士长
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) {
        
        if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
            
            //护士长端-待指派（健康经理申请）
            
            if (indexPath.row >  YJYInsureDetailTypeNurseReviewName && indexPath.row <  YJYInsureDetailTypeNurseReviewBlank) {
    
                heigth = 0;
            }
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
            
            if (indexPath.row ==  YJYInsureDetailTypeProReview) {
                
                heigth = 0;
            }
            
        }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass) {
            
            if (indexPath.row ==  YJYInsureDetailTypeProReviewTime || indexPath.row == YJYInsureDetailTypeProReviewNurse) {
                
                heigth = 0;
            }
            
        }else if (indexPath.row == YJYInsureDetailTypeNurseReviewDescribeText){
            
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass ||
                self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
                
                heigth = 0;
                
            }
            
        }
    }else if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeHealthManager) {
        
        if (indexPath.row == YJYInsureDetailTypeProReviewTime || indexPath.row == YJYInsureDetailTypeProReviewNurse) {
            
            heigth = 0;
            
        }else if (indexPath.row == YJYInsureDetailTypeNurseReviewDescribeText){
            
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass ||
                self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
                
                heigth = 0;
                
            }
            
        }
        
    }else {
        
        if (indexPath.row == YJYInsureDetailTypeNurseReviewDescribeText){
            
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewPass ||
                self.rsp.insureNo.status == YJYInsureTypeStateReReviewRefuse) {
                
                heigth = 0;
                
            }
            
        }
    }
    
    return  heigth;


}

- (CGFloat)setupHiddenTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath heigth:(CGFloat)heigth{
    
    
    if (indexPath.row >= YJYInsureDetailTypeBasicInfoTip && indexPath.row <=  YJYInsureDetailTypeBasicInfoContent && self.hiddenBasic) {
        
        heigth = 0;
        
    }else if (indexPath.row >= YJYInsureDetailTypeAgentTip && indexPath.row <=  YJYInsureDetailTypeAgentTipContent && self.hiddenAgent) {
        
        heigth =  0;
        
    }else if (indexPath.row >= YJYInsureDetailTypeApplyInfoTip && indexPath.row <=  YJYInsureDetailTypeApplyInfoContent && self.hiddenApply) {
        
        heigth =  0;
        
    }else if (indexPath.row >= YJYInsureDetailTypeHMReviewTip && indexPath.row <= YJYInsureDetailTypeHMReviewBlank  && self.hiddenHM) {
        heigth =  0;

        
    }else if (indexPath.row >= YJYInsureDetailTypeCustomerServiceInfo && indexPath.row <= YJYInsureDetailTypeCustomerServiceBlank && self.hiddenCS) {
        
        heigth =  0;
        
    }else if (indexPath.row >= YJYInsureDetailTypeNurseReviewInfo && indexPath.row <= YJYInsureDetailTypeNurseReviewBlank && self.hiddenNurse) {
        
        heigth =  0;

    }else if (indexPath.row >= YJYInsureDetailTypeProInfo && indexPath.row <= YJYInsureDetailTypeProReview && self.hiddenPro) {
        heigth =  0;

        
    }
    
    return heigth;

}

- (CGFloat)setupExpandTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  heigth:(CGFloat)heigth{
    
    //expand
    
    if (indexPath.row == YJYInsureDetailTypeBasicInfoContent) {
        //self.basicContentVC.tableView.contentSize.height
        heigth = self.expandBasic ? 480 : 0;
        
    }else if (indexPath.row == YJYInsureDetailTypeAgentTipContent) {
        
        heigth = self.expandAgent ? 142 : 0;
        
    }else if (indexPath.row == YJYInsureDetailTypeApplyInfoContent) {
        
        heigth = self.expandApply ? 270 : 0;
        
    }else if (indexPath.row > YJYInsureDetailTypeHMReviewTip && indexPath.row <= YJYInsureDetailTypeHMReviewBlank) {
        heigth = self.expandHM ? heigth : 0;
        
        
    }else if (indexPath.row > YJYInsureDetailTypeCustomerServiceInfo && indexPath.row <= YJYInsureDetailTypeCustomerServiceBlank) {
        
        heigth = self.expandCS ? heigth : 0;
        
    }else if (indexPath.row > YJYInsureDetailTypeNurseReviewInfo && indexPath.row <= YJYInsureDetailTypeNurseReviewBlank) {
        
        heigth = self.expandNurse ? heigth : 0;
        
    }else if (indexPath.row > YJYInsureDetailTypeProInfo && indexPath.row <= YJYInsureDetailTypeProReview) {
        heigth = self.expandPro ? heigth : 0;
        
        
    }
    
    return  heigth;

}


#pragma mark - Action

- (void)toNaviToADLWithHM:(BOOL)isHM
                   isEdit:(BOOL)isEdit
                    label:(UILabel *)label
                   button:(UIButton *)button{


    NSString *edit =  isEdit ? @"true" : @"false";
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
        (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview || self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse)) {
        edit = @"true";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?insureNO=%@&edit=%@&assessType=%@&kinsId=%@",kSAASADLURL,self.rsp.insureNo.insureNo,edit,@(isHM ? 1 :2),@(self.rsp.insureNo.kinsId)];
    
    YJYWebController *vc = [YJYWebController new];
    vc.title = @"ADL评估";
    vc.urlString = urlString;
    vc.didDone = ^(id dict) {
       
        
        if (dict[@"assessId"] && dict[@"score"]) {
         //   uint64_t assessId = (uint64_t)[dict[@"assessId"] integerValue];
            uint32_t score = (uint32_t)[dict[@"score"] integerValue];
            
            if (!isHM) {
                
                label.text = [NSString stringWithFormat:@"%@分",@(score)];
                label.hidden = NO;
                [button setTitle:@"查看" forState:0];
                
                if ([label isEqual:self.nurseADLLabel]) {
                    self.rsp.insureNo.scoreAdl = score;

                }else {
                    
                    self.rsp.insureNo.dudaoScoreAdl = score;

                }
                
                
                if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse &&
                    (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview || self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse)) {
                    
                    [button setTitle:@"编辑" forState:0];

                }

                
            }
           
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toCheckPMADLAction:(id)sender {

    
    [self toNaviToADLWithHM:YES isEdit:self.rsp.insureNo.dudaoScoreAdl == -1 ? YES : NO label:self.healthManagerAdlLabel button:self.hmADLCheckButton];
    
}

- (IBAction)toCheckNurseADLAction:(id)sender {
    
    [self toNaviToADLWithHM:NO isEdit:self.rsp.insureNo.scoreAdl == -1 ? YES : NO label:self.nurseADLLabel button:self.nurseADLButton];

}

- (IBAction)toChooseDisableAction:(UIButton *)sender {
    
    self.disableYESButton.selected = NO;
    self.disableNOButton.selected = NO;
    sender.selected = YES;
    
    self.rsp.insureNo.isAmentia = ![sender isEqual:self.disableNOButton];
    [self.tableView reloadData];
}
- (IBAction)toProcessDetailAction {

    YJYInsurePorcessController *vc = [YJYInsurePorcessController instanceWithStoryBoard];
    vc.detailListArray = self.rsp.detailListArray;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)toPass {
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"确定通过长护险申请" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];

            if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview||self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse) {
                
                self.req.insureNo = self.rsp.insureNo.insureNo;
                self.req.status = 1;
                self.req.assessType = 1;

                self.req.hsCasePresentation = self.nurseIntroTextView.text;
                self.req.medicalHistory = self.nurseReviewDesTextView.text;
                self.req.rejectDesc = self.nurseReviewResultTextView.text;
                self.req.isAmentia = self.rsp.insureNo.isAmentia;
                if (self.rsp.insureNo.isAmentia) {
                    self.req.dysgnosiaePicArray = self.insureDisableView.imageIds;
                    
                }
                self.req.caseDiagnosePicArray = self.insureOtherImagesView.imageIds;

            }else if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
                
                self.req.insureNo = self.rsp.insureNo.insureNo;
                self.req.assessType = 54;

            }
            
            self.req.remark = self.rsp.insureNo.assessType == YJYInsureTypeStateReReviewing ? self.proRviewResultTextView.text : self.nurseMarkTextView.text;
            self.req.rejectDesc = self.nurseReviewResultTextView.text;

            [YJYNetworkManager requestWithUrlString:SAASAPPInsureAssess message:self.req controller:self command:APP_COMMAND_SaasappinsureAssess success:^(id response) {
                
                
                [SYProgressHUD showSuccessText:@"操作成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadNetworkData];
                    
                });
                
            } failure:^(NSError *error) {
                
             
            }];

        }
        
    }];
}
- (IBAction)toRejuct {
    
    [UIAlertController text_showAlertInViewController:self withTitle:@"不通过原因" message:nil cancelButtonTitle:@"取消" doneButtonTitle:@"确定" textFieldText:nil placeholder:@"不通过原因" secureTextEntry:NO tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];

            self.req.insureNo = self.rsp.insureNo.insureNo;
            self.req.status = 2;
            self.req.assessType = 1;
            
            self.req.remark = self.rsp.insureNo.assessType == YJYInsureTypeStateReReviewing ? self.proRviewResultTextView.text : self.nurseMarkTextView.text;
            
            self.req.hsCasePresentation = self.nurseIntroTextView.text;
            self.req.medicalHistory = self.nurseReviewDesTextView.text;
            
            
            self.req.isAmentia = self.rsp.insureNo.isAmentia;
            if (self.rsp.insureNo.isAmentia) {
                self.req.dysgnosiaePicArray = self.insureDisableView.imageIds;
                
            }
            self.req.caseDiagnosePicArray = self.insureOtherImagesView.imageIds;
            
            if (controller.textFields.firstObject) {
                self.req.rejectDesc = [controller.textFields.firstObject text];
            }else {
                self.req.rejectDesc = self.nurseReviewResultTextView.text;
            }

            [YJYNetworkManager requestWithUrlString:SAASAPPInsureAssess message:self.req controller:self command:APP_COMMAND_SaasappinsureAssess success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"操作成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadNetworkData];
                    
                });
                
            } failure:^(NSError *error) {
                
                
            }];
            
        }
        
        
    }];
}
- (void)toSave{
    
       [UIAlertController showAlertInViewController:self withTitle:@"确定保存" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex == 1) {
            
            
            [SYProgressHUD show];
            
            
            self.req.insureNo = self.rsp.insureNo.insureNo;
            self.req.status = self.rsp.insureNo.status;
            
            if (self.rsp.insureNo.status == YJYInsureTypeStateReReviewing) {
                
                self.req.assessType = 54;

            }else if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReviewRefuse) {
                self.req.assessType = 51;

            }else if (self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
                self.req.assessType = 51;

                
            }
            
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && self.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
                self.req.assessType = 1;
                self.req.status = 3;

            }
            
            
            self.req.hsCasePresentation = self.nurseIntroTextView.text;
            self.req.medicalHistory = self.nurseReviewDesTextView.text;
            
            self.req.rejectDesc = self.nurseReviewResultTextView.text;
            self.req.isAmentia = self.rsp.insureNo.isAmentia;
            if (self.rsp.insureNo.isAmentia) {
                self.req.dysgnosiaePicArray = self.insureDisableView.imageIds;
                
            }
            self.req.caseDiagnosePicArray = self.insureOtherImagesView.imageIds;
            self.req.remark = self.rsp.insureNo.status == YJYInsureTypeStateReReviewing ? self.proRviewResultTextView.text : self.nurseMarkTextView.text;
            self.req.rejectDesc = self.nurseReviewResultTextView.text;

            [YJYNetworkManager requestWithUrlString:SAASAPPInsureAssess message:self.req controller:self command:APP_COMMAND_SaasappinsureAssess success:^(id response) {
                
                [SYProgressHUD showSuccessText:@"保存成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadNetworkData];

                });
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
        
    }];
    
    
    
}


//指派护士
- (void)toGuideAction {
    
    
    YJYInsureOrderNurseListController *vc = [YJYInsureOrderNurseListController instanceWithStoryBoard];
    vc.insureVo = self.rsp.insureNo;
    vc.nurseWorkType = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YJYNurseWorkTypeNurse : YJYNurseWorkTypeWorker;
    vc.isNurse = ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurseLeader) ? YES : NO;
    vc.isGuide = YES;
    
    vc.didSelectBlock = ^(InsureHGListVO *insureHGListVO) {
        

        self.nurseLabel.text = insureHGListVO.fullName;
        self.req.hgId = insureHGListVO.id_p;
        [self loadNetworkData];
   
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)toBookServerAction {
    
    YJYInsureChooseServiceController *vc = [YJYInsureChooseServiceController instanceWithStoryBoard];
    vc.insureNo = self.insureNo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

@interface YJYInsureDetailController ()

@property (strong, nonatomic) YJYInsureDetailContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewHConstraint;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSMutableArray *buttonViews;
@end

@implementation YJYInsureDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureDetailController *)[UIStoryboard storyboardWithName:@"YJYInsureDetail" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"YJYInsureDetailContentController"]) {
        
        
        if (self.insreNO) {
            self.insureNo = self.insreNO;
        }
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.insureNo = self.insureNo;
        __weak typeof(self) weakSelf = self;
        self.contentVC.didLoadRspBlock = ^{
            
            if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeNurse && self.contentVC.rsp.insureNo.status == YJYInsureTypeStateFirstReview) {
                weakSelf.saveButton.hidden = NO;
            }else {
                weakSelf.saveButton.hidden = YES;
            }
            
            [weakSelf reloadToolView];
            
        };
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.buttonViews = [NSMutableArray array];
    self.toolView.hidden = YES;
    
    
    if (self.hasToBackRoot) {
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];
    }
   
}

- (IBAction)toSave:(id)sender {
    [self.contentVC toSave];
}


#pragma mark - toolview
- (void)reloadToolView {
    
    //先清空
    for (UIView *subView in self.buttonViews) {
        [subView removeFromSuperview];
    }
    self.buttonViews = [NSMutableArray array];
    NSArray *menuItems = [[YJYRoleManager sharedInstance] LongNurseMenuItemsWithInsureNoRsp:self.contentVC.rsp];
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
        [button addTarget:self.contentVC action:NSSelectorFromString(item.func) forControlEvents:UIControlEventTouchUpInside];
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
- (void)close {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
