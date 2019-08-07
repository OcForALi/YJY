//
//  YJYBookHospitalController.m
//  YJYUser
//
//  Created by wusonghe on 2017/8/4.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBookHospitalController.h"
#import "YJYOrderCreatePriceCell.h"
#import "YJYKinsfolksController.h"
#import "YJYPersonEditController.h"
#import "YJYTimePicker.h"
#import "YJYNearHospitalController.h"
#import "YJYBookBranchController.h"
#import "YJYOrderDetailController.h"
#import "YJYOrderPackageDetailController.h"


typedef void(^CompleteNoneBlock)(void);
typedef void(^CompleteResultBlock)(id result);

@interface YJYBookHospitalContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet YJYOrderCreatePriceCell *priceCell;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UITextField *bookTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *hospitalNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNumberTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *bedNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateInButton;

@property (weak, nonatomic) IBOutlet UIImageView *doorBanSelectView;
@property (weak, nonatomic) IBOutlet UILabel *doorBanNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorBanTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *prePayLabel;

@property (weak, nonatomic) IBOutlet UIView *chooseHosiptalHeader;
@property (weak, nonatomic) IBOutlet UIView *rePictureHeader;

@property (weak, nonatomic) IBOutlet UIButton *chooseKinsButton;
@property (weak, nonatomic) IBOutlet UIButton *rePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseHospitalButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseBranchButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseBookTimeButton;


//data


@property (strong, nonatomic) GetPriceRsp *rsp;
@property (strong, nonatomic) CreateOrderReq *createOrderReq;
@property (strong, nonatomic) HospitalBra *hospitalBra;
@property (assign, nonatomic) BOOL isDoorBan;
@property (assign, nonatomic) BOOL isHis;
@property (strong, nonatomic) NSString *hospitalNumber;

@property (strong, nonatomic) OrgDistanceModel *currentOrg;
@property (strong, nonatomic) BranchModel *currentBranch;
@property (strong, nonatomic) KinsfolkVO *currentKinsfolk;
@property (strong, nonatomic) OrderTimeData *currentDate;
@property (strong, nonatomic) UserAddressVO *currentAddress;
@property (strong, nonatomic) Price *currentPrice;
@property (assign, nonatomic) uint64_t currentPriceId;

@property (copy, nonatomic) CompleteResultBlock didSelectPriceBlock;

@end

@implementation YJYBookHospitalContentController



- (void)viewDidLoad {
    
    self.isNaviError = YES;

    [super viewDidLoad];
    
    self.createOrderReq = [CreateOrderReq new];
    self.priceCell.priceArray = [NSMutableArray array];
    self.rePictureHeader.hidden = self.isHis;
    
    
    //load data
    if ([YJYSettingManager sharedInstance].currentOrgVo.orgName.length > 0) {
        self.hospitalLabel.text = [YJYSettingManager sharedInstance].currentOrgVo.orgName;

    }
    if (!self.currentOrg) {
        self.currentOrg = [OrgDistanceModel new];
        self.currentOrg.orgVo = [YJYSettingManager sharedInstance].currentOrgVo;
    }
   
    self.createOrderReq.orgId = self.currentOrg.orgVo.orgId;
    self.hospitalLabel.text = self.currentOrg.orgVo.orgName;
//    self.hospitalNumberTextField.text = self.hospitalNumber;

    [self loadTimeNetwork];

   
    //data
    
    if (self.hospitalBra) {
        [self setupHospitalBra];

    }else {
        [self loadNetworkKinsfolk];
        [self.dateInButton setTitle:[NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD] forState:0];
    }
    
    // placeholder
    
    if (self.currentOrg.orgVo.hisType == 3) {
        self.hospitalNumberTipLabel.text = @"住院号(选填)";
    }
    
    //cell
    
    __weak typeof(self) weakSelf = self;
    self.priceCell.didSelectBlock = ^(Price *price) {
        
        weakSelf.currentPrice = price;
        weakSelf.prePayLabel.text = [NSString stringWithFormat:@"%@元",price.prepayFeeStr];
        if (weakSelf.didSelectPriceBlock) {
            weakSelf.didSelectPriceBlock(price);
        }

    };
    
    self.priceCell.didSwitchBlock = ^(NSInteger tag) {
        
        weakSelf.priceCell.priceArray = (tag == 1) ? weakSelf.rsp.pList12NArray : weakSelf.rsp.pList121Array;
        [weakSelf reloadAllData];
        if (weakSelf.didSelectPriceBlock) {
            weakSelf.didSelectPriceBlock(weakSelf.currentPrice);
        }

    };
    self.priceCell.didSelectToDetailBlock = ^(Price *price) {
        
        YJYOrderPackageDetailController *vc = [YJYOrderPackageDetailController instanceWithStoryBoard];
        vc.price = price;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.chooseHosiptalHeader yjy_setBottomShadow];

    
}

#pragma mark - Network
- (void)loadPackage {
    
    GetPriceReq *req = [GetPriceReq new];
    
    req.branchId = self.currentBranch.id_p;

    
    [YJYNetworkManager requestWithUrlString:APPGetPrice message:req controller:self command:APP_COMMAND_AppgetPrice success:^(id response) {
        
        //rsp
        
        self.rsp = [GetPriceRsp parseFromData:response error:nil];
        
        self.doorBanNumberLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.entranceCardPriceStr];
        self.isDoorBan = self.rsp.entranceCardPrice > 0 ? YES : NO;

        self.prePayLabel.text = [NSString stringWithFormat:@"%@元",self.rsp.prepayAmount];

        
        YJYPriceType priceType = YJYPriceTypeBoth;

        if (self.rsp.pList121Array_Count > 0 && self.rsp.pList12NArray_Count == 0) {
            priceType = YJYPriceTypeOnlyOne;

            self.priceCell.priceArray = self.rsp.pList12NArray;
            self.priceCell.isSingle = YES;
            
            [self reloadAllData];
           

        }else if (self.rsp.pList121Array_Count == 0 && self.rsp.pList12NArray_Count > 0) {
            
            priceType = YJYPriceTypeOnlyMany;

            self.priceCell.priceArray = self.rsp.pList12NArray;
            self.priceCell.isSingle = YES;
            [self reloadAllData];
        }else {
            
            self.priceCell.priceArray = self.rsp.pList12NArray;
            self.priceCell.isSingle = NO;
            [self reloadAllData];
             [self.priceCell toSwitchPackage:self.priceCell.pubButton];
        }

        self.priceCell.priceType = priceType;

     
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    
}

- (void)loadNetworkKinsfolk {
    
    [YJYNetworkManager requestWithUrlString:APPListKinsfolk message:nil controller:self command:APP_COMMAND_ApplistKinsfolk success:^(id response) {
        
        
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        self.currentKinsfolk = rsp.kinsfolkListArray.firstObject;
        
        [self setupKindFolk:self.currentKinsfolk];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)loadTimeNetwork {
    
    GetOrderTimeReq *req = [GetOrderTimeReq new];
    req.orderType = 1;
    
    [YJYNetworkManager requestWithUrlString:APPGetOrderTime message:req controller:nil command:APP_COMMAND_AppgetOrderTime success:^(id response) {
        
        GetOrderTimeRsp *rsp = [GetOrderTimeRsp parseFromData:response error:nil];
        self.currentDate = rsp.defaultTimeData;
        self.createOrderReq.serviceStartTime = self.currentDate.serviceStartTime;
        self.createOrderReq.serviceEndTime = self.currentDate.serviceEndTime;
        
        NSString *serviceStartTime = self.currentDate.serviceStartTime;
        NSString *serviceEndTime = self.currentDate.serviceEndTime;
        
        NSDate *startDate = [NSDate dateString:serviceStartTime Format:YYYY_MM_DD_HH_MM_SS];
        NSDate *endDate = [NSDate dateString:serviceEndTime Format:YYYY_MM_DD_HH_MM_SS];
        NSString *startDataString = [NSDate getRealDateTime:startDate withFormat:YYYY_MM_DD_HH_MM];
        
        NSString *endDataString = [NSDate getRealDateTime:endDate withFormat:HH_MM];
        
        NSString *fullTime = [NSString stringWithFormat:@"%@-%@",startDataString,endDataString];
        
        self.bookTimeTextField.text = fullTime;
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}


#pragma mark - Data

- (void)setupHospitalBra {
    
    self.createOrderReq.kinsId = self.hospitalBra.kinsId;
    self.nameTextField.text = self.hospitalBra.name;
    self.createOrderReq.kinsName = self.hospitalBra.name;
    
    /// 性别 0-未知 1-男 2-女
    if(self.hospitalBra.sex == 1) {
        [self.sexTextField setText:@"男"];
        
    }else if (self.hospitalBra.sex == 2) {
        [self.sexTextField setText:@"女"];
        
    }
    self.createOrderReq.sex = self.hospitalBra.sex;

    self.ageTextField.text = [NSString stringWithFormat:@"%@岁",@(self.hospitalBra.age)];
    self.createOrderReq.age = self.hospitalBra.age;
    
    
    self.hospitalLabel.text = self.hospitalBra.orgName;
    self.createOrderReq.orgId = self.hospitalBra.orgId;
    self.currentOrg = [OrgDistanceModel new];
    self.currentOrg.orgVo.orgId = self.hospitalBra.orgId;
    self.currentOrg.orgVo.orgName = self.hospitalBra.orgName;
    
    if (self.hospitalBra.branchId > 0) {
        self.branchLabel.text = self.hospitalBra.branchName;
        self.createOrderReq.branchId = self.hospitalBra.branchId;
    }
    
    
    self.hospitalNumberTextField.text = self.hospitalBra.orgNo;
  
    self.createOrderReq.orgNo = self.hospitalBra.orgNo;
    
    self.bedNumberTextField.text = self.hospitalBra.bedNo;
    self.createOrderReq.bedNo = self.hospitalBra.bedNo;

    if (self.hospitalBra.admissionDate.length > 0) {
        [self.dateInButton setTitle:self.hospitalBra.admissionDate forState:0];

    }else {
        [self.dateInButton setTitle:[NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD] forState:0];

    }
    self.createOrderReq.admissionDate = self.hospitalBra.admissionDate;
    
    //是否可以编辑
   
    [self enableEdit:YES];

    if (self.hospitalBra.branchId) {
        self.currentBranch = [BranchModel new];
        self.currentBranch.id_p = self.hospitalBra.branchId;
        [self loadPackage];
    }
    
    
}

- (void)setupKindFolk:(KinsfolkVO *)kinsfolk {
    
    if (!kinsfolk || kinsfolk.name.length == 0) {
        self.nameTextField.placeholder = @"被服务人姓名";
        return;
    }else {
        
        [self enableEdit:NO];
    }
    
    
    self.createOrderReq.kinsId = kinsfolk.kinsId;
    self.nameTextField.text = kinsfolk.name;
    self.createOrderReq.kinsName = kinsfolk.name;

    if(kinsfolk.sex == 1) {
        [self.sexTextField setText:@"男"];

    }else if (kinsfolk.sex == 2) {
        [self.sexTextField setText:@"女"];
        
    }
    self.createOrderReq.sex = kinsfolk.sex;

    self.ageTextField.text = [NSString stringWithFormat:@"%@岁",@(kinsfolk.age)];
    self.createOrderReq.age = kinsfolk.age;

    
    [self.chooseKinsButton setTitle:[NSString stringWithFormat:@"    选择已有被陪护人:%@",kinsfolk.name] forState:0];

}

- (void)enableEdit:(BOOL)edit {
    
    self.nameTextField.enabled = edit;
    self.sexTextField.enabled = edit;
    self.ageTextField.enabled = edit;
    [self enableEditIsHis];
    
}
- (void)enableEditIsHis {
    
    if (self.isHis) {
        
        self.rePictureButton.enabled = NO;
        self.chooseHospitalButton.enabled = self.createOrderReq.orgId == 0;
        self.chooseBranchButton.enabled = self.createOrderReq.branchId == 0;
        self.bookTimeTextField.enabled = NO;
//        self.chooseBookTimeButton.enabled = NO;
        
        self.nameTextField.enabled = self.nameTextField.text.length == 0;
        self.sexTextField.enabled = self.sexTextField.text.length == 0;
        self.ageTextField.enabled = self.ageTextField.text.length == 0;
        self.hospitalNumberTextField.enabled = self.hospitalNumberTextField.text.length == 0;
        self.dateInButton.enabled = self.dateInButton.currentTitle.length == 0;
        self.bedNumberTextField.enabled = self.bedNumberTextField.text.length == 0;;

        
        self.branchLabel.textColor = self.hospitalBra.branchName.length == 0 || self.hospitalBra.branchId == 0 ? APPGrayCOLOR : [UIColor blackColor];

    }
}
#pragma mark - Action

- (IBAction)toChangeSexAction:(UIButton *)sender {
   
    if (self.sexTextField.text.length > 0) {
        return;
    }
    
    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"男",@"女"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (buttonIndex != 0) {
            
            if(buttonIndex == 2) {
                [self.sexTextField setText:@"男"];
                
            }else if (buttonIndex == 3) {
                [self.sexTextField setText:@"女"];
                
            }
            /// 1-男 2-女
            self.createOrderReq.sex = (uint32_t)buttonIndex - 1;
            self.currentKinsfolk.sex = self.createOrderReq.sex;

        }
    }];
    
}

- (IBAction)toChangeKinAction:(id)sender {
    if (self.isHis) {
        return;
    }
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:APPListKinsfolk message:nil controller:self command:APP_COMMAND_ApplistKinsfolk success:^(id response) {
        
        
        [SYProgressHUD hide];
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        if (rsp.kinsfolkListArray.count > 0) {
            
            YJYKinsfolksController *vc = [YJYKinsfolksController instanceWithStoryBoard];
            vc.kinsfolksDidSelectBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
            vc.firstAdd = YES;
            vc.didDoneBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}

- (IBAction)rePictureAction:(id)sender {
    
    [self takePhotoActionWithCompleteBlock:^(NSString *imageId) {
        
        [SYProgressHUD showLoadingWindowText:@"正在识别"];
        
        OrgNORecognizeReq *req = [OrgNORecognizeReq new];
        req.imgId = imageId;
        
        [YJYNetworkManager requestWithUrlString:OrgNORecognize message:req controller:self command:APP_COMMAND_OrgNorecognize success:^(id response) {
            
            [SYProgressHUD hide];

            OrgNORecognizeRsp *rsp = [OrgNORecognizeRsp parseFromData:response error:nil];
            if (rsp.hospitalBra.orgNo.length > 0) {
                //图片识别失败，是否手工输入
                self.hospitalBra = rsp.hospitalBra;
                [self setupHospitalBra];
            }else {
                
                [UIAlertController showAlertInViewController:self withTitle:@"图片识别失败，是否手工输入？" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新拍照" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        [self rePictureAction:nil];
                    }
                    
                    
                    
                }];
                
            }
            
       
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
}

- (IBAction)changeHospitalAction:(id)sender {
    
   
    YJYNearHospitalController *vc = [YJYNearHospitalController instanceWithStoryBoard];
    vc.nearHospitalDidSelectBlock = ^(OrgDistanceModel *org) {
        self.currentOrg = org;
        self.createOrderReq.orgId = org.orgVo.orgId;
        self.hospitalLabel.text = self.currentOrg.orgVo.orgName;
        [self.hospitalLabel sizeToFit];
        
        if (self.currentBranch) {
            self.currentBranch = nil;
            self.branchLabel.text = nil;
            [self loadPackage];

        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)changeBranchAction:(id)sender {
    
   
    
    YJYBookBranchController *vc = [YJYBookBranchController instanceWithStoryBoard];
    vc.currentOrg = self.currentOrg;
    vc.didSelectBlock = ^(BranchModel *branch) {
        self.currentBranch = branch;
        self.createOrderReq.branchId = branch.id_p;
        [self loadPackage];
        self.branchLabel.text = branch.branchName;
        self.branchLabel.textColor = branch.branchName.length == 0 ? APPGrayCOLOR : [UIColor blackColor];

    };
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (IBAction)toSetBookTimeAction:(id)sender {
    
    
    [self showTimePickerWithComplete:^(OrderTimeData *orderTimeData, NSString *fullTime) {
    
        self.bookTimeTextField.text = fullTime;
        self.currentDate = orderTimeData;
        self.createOrderReq.serviceStartTime =  self.currentDate.serviceStartTime;
        self.createOrderReq.serviceEndTime =  self.currentDate.serviceEndTime;
        
    }];
    
}

- (IBAction)toChangeEnterDate:(id)sender {
    
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
    picker.didSelectDate = ^(NSDate *date) {
        
        [self.dateInButton setTitle:[NSDate getRealDateTime:date withFormat:YYYY_MM_DD] forState:0];

    };
    [picker show];
   
    
    
}
- (IBAction)toChangeDoorBanCardAction:(id)sender {
    
    self.isDoorBan = !self.isDoorBan;
    self.doorBanSelectView.image = [UIImage imageNamed:self.isDoorBan ? @"app_select_icon" :@"app_unselect_icon"];
    
    self.doorBanTipLabel.textColor = self.isDoorBan ? APPHEXCOLOR : APPDarkCOLOR;
    self.doorBanNumberLabel.textColor = self.isDoorBan ? APPHEXCOLOR : APPDarkCOLOR;
    
    if (self.didSelectPriceBlock) {
        self.didSelectPriceBlock(self.currentPrice);
    }
    
}

typedef void(^CompleteTimePickerBlock)(OrderTimeData *orderTimeData, NSString *fullTime);

- (void)showTimePickerWithComplete:(CompleteTimePickerBlock)completeBlock {
    
    YJYTimePicker *picker = [YJYTimePicker instancetypeWithXIB];
    picker.orderType = 1;
    [picker loadNetwork];
    picker.timePickerDidSelectBlock = ^(TimeData *currentTimeData, OrderTimeData *orderTimeData) {
        
        NSString *serviceStartTime = orderTimeData.serviceStartTime;
        NSString *serviceEndTime = orderTimeData.serviceEndTime;
        
        
        NSDate *startDate = [NSDate dateString:serviceStartTime Format:YYYY_MM_DD_HH_MM_SS];
        NSDate *endDate = [NSDate dateString:serviceEndTime Format:YYYY_MM_DD_HH_MM_SS];
        
        NSString *startDataString = [NSDate getRealDateTime:startDate withFormat:YYYY_MM_DD_HH_MM];
        
        NSString *endDataString = [NSDate getRealDateTime:endDate withFormat:HH_MM];
        
        NSString *fullTime = [NSString stringWithFormat:@"%@-%@",startDataString,endDataString];
        
        if (completeBlock) {
            completeBlock(orderTimeData,fullTime);
        }
        
       
        
        
    };
    
    [picker showInView:nil];
    
}

- (void)done {

    
    [SYProgressHUD show];
    
    if (!self.createOrderReq.serviceStartTime || self.createOrderReq.serviceStartTime.length == 0) {
        [SYProgressHUD showFailureText:@"请选择时间"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self toSetBookTimeAction:nil];
        });
        return;
    }
    
    self.createOrderReq.pic1 = self.hospitalBra.imgId;
    self.createOrderReq.needExtra = self.isDoorBan;
    self.createOrderReq.orderType = 1;
    self.createOrderReq.priceId = self.currentPrice.priceId;
    self.createOrderReq.orgNo = self.hospitalNumberTextField.text;
    self.createOrderReq.bedNo = self.bedNumberTextField.text;

 
    
    if (self.createOrderReq.kinsId == 0) {
        self.createOrderReq.kinsName = self.nameTextField.text;
        self.createOrderReq.sex = [self.sexTextField.text isEqualToString:@"男"] ? 1 : 2;
        self.createOrderReq.age =  (uint32_t)[self.ageTextField.text integerValue];
    }
   

 
    
    [YJYNetworkManager requestWithUrlString:APPCreateOrder message:self.createOrderReq controller:self command:APP_COMMAND_AppcreateOrder success:^(id response) {
        
        CreateOrderRsp *rsp = [CreateOrderRsp parseFromData:response error:nil];
        

        YJYOrderDetailController *vc = [YJYOrderDetailController instanceWithStoryBoard];
        vc.fromBooking = YES;
        vc.orderId = rsp.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        [SYProgressHUD hide];
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 拍照
typedef void(^CompleteBlock)(NSString *imageId);

- (void)takePhotoActionWithCompleteBlock:(CompleteBlock)completeBlock {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                
                [SYProgressHUD showLoadingWindowText:@"正在上传"];
                
                [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
                    
                    if (completeBlock) {
                        completeBlock(response[@"imageId"]);
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


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        if (self.currentOrg.orgVo.hisType != 2) {
            return 0;

        }else {
            return 60;
        }
    }else if (indexPath.row == 4) {
        
        return self.isHis ? 50 : 100;
        
    }else if (indexPath.row >= 11 && indexPath.row <= 14 && !self.currentBranch) {
        return 0;
        
    }else if (indexPath.row == 13) {
        
        return self.rsp.entranceCardPrice > 0 ? 44: 0;
    }else if (indexPath.row == 14) {
        
        return self.currentBranch ? [self.priceCell cellHeight] : 0;
    }else {
        
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];

    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        
    {
        [cell.superview bringSubviewToFront:cell];
        cell.contentView.superview.clipsToBounds = NO;
    }
}

@end

@interface YJYBookHospitalController ()

@property (strong, nonatomic) YJYBookHospitalContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIButton *waitPayButton;

@end

@implementation YJYBookHospitalController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"YJYBookHospitalContentController"]) {
        self.contentVC = (YJYBookHospitalContentController *)segue.destinationViewController;
        self.contentVC.hospitalBra = self.hospitalBra;
        self.contentVC.currentOrg = self.currentOrg;
        self.contentVC.isHis = self.isHis;
        self.contentVC.hospitalNumber = self.hospitalNumber;
        
        
        __weak typeof(self) weakSelf = self;
        self.contentVC.didSelectPriceBlock = ^(id result) {
            
            Price *price = result;
            NSString *payMoney = (price.totalPrice.length > 0 ? price.totalPrice : @"0.00");
            
            if (!weakSelf.contentVC.isDoorBan) {
                payMoney = price.prepayFeeStr.length > 0 ? price.prepayFeeStr : @"0.00";
            }
            
            payMoney = [NSString stringWithFormat:@"总金额 %@元",payMoney];
            [weakSelf.waitPayButton setTitle:payMoney forState:0];
            
        };
        
       
    }
}


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBookHospitalController *)[UIStoryboard storyboardWithName:@"YJYBookHospital" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)bookAction:(id)sender {
    
    [self.contentVC done];
}

@end
