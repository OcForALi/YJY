//
//  YJYPersonEditController.m
//  YJYUser
//
//  Created by wusonghe on 2017/9/1.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYPersonEditController.h"
#import "YJYImageShowController.h"
#import "YJYInsureQuestionController.h"
#import "IDCardNumberValidator.h"
#import "UIButton+AFNetworking.h"
#import "YJYHWeightController.h"
#import "LCActionSheet.h"
#import "YJYKinsfolksController.h"


typedef NS_ENUM(NSInteger, YJYPersonEditPicType) {

    YJYPersonEditPicTypeIDUp = 0,
    YJYPersonEditPicTypeIDDown = 1,
    YJYPersonEditPicTypeServer = 2,
    YJYPersonEditPicTypeCard = 3
};


@interface YJYPersonEditContentController : YJYTableViewController



@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *idUpImageButton;
@property (weak, nonatomic) IBOutlet UIButton *idDownImageButton;
@property (weak, nonatomic) IBOutlet UIButton *serverImageButton;
@property (weak, nonatomic) IBOutlet UIButton *cardImageButton;

// other

@property (weak, nonatomic) IBOutlet UIButton *heightButton;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UITextField *personTypeField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *hospitalCardTextField;
@property (weak, nonatomic) IBOutlet UITextView *markTextView;
@property (weak, nonatomic) IBOutlet UILabel *careTagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expandImageView;
@property (weak, nonatomic) IBOutlet UITextField *jiuzhenCardTextField;


// language

@property (weak, nonatomic) IBOutlet UIView *languageView;
@property (weak, nonatomic) IBOutlet UIScrollView *languageScrollView;
@property (strong, nonatomic) NSMutableArray *lanButtons;


// rate
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateActionLabel; //重新评测 生活能力评测


//data
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) BOOL firstAdd;
@property (assign, nonatomic) BOOL isExpand;
@property(nonatomic, readwrite) uint32_t kinsType;

@property (strong, nonatomic) MedicareType *currentType;
@property (strong, nonatomic) KinsfolkVO *kinsfolk;

@property (strong, nonatomic) KinsfolkReq *kinsfolkReq;

@end

@implementation YJYPersonEditContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //ui
    
    self.languageScrollView.frame = CGRectMake(100, 0, [UIScreen mainScreen].bounds.size.width - 100 - 15, self.languageView.frame.size.height);
    self.idUpImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.idDownImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.serverImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.cardImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.lanButtons = [NSMutableArray array];
    self.isExpand = self.kinsType == 1;
    
    
    self.expandImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",!self.isExpand ? @"app_arrow_down" : @"app_arrow_up"]];

    
    //data
    
    [self loadLanguages];
    [self loadKinsfolk];
    [self loadNetKinsfolk];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetKinsfolk];
}

#pragma mark - Data


- (void)loadNetKinsfolk {
    
    GetKinsfolkReq *req = [GetKinsfolkReq new];
    req.kinsId = self.kinsfolk.kinsId;
    req.idCardNo = self.kinsfolk.idCardNo;
    [YJYNetworkManager requestWithUrlString:APPGetKins message:req controller:self command:APP_COMMAND_AppgetKins success:^(id response) {
        
        GetKinsfolkRsp *rsp = [GetKinsfolkRsp parseFromData:response error:nil];
        
        self.kinsfolk.score = (int32_t)rsp.scoreAdl;
        [self loadRateData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadKinsfolk {
    
    if (self.kinsfolk) {
        
        self.isEdit = YES;
        [self loadPersonData];
        [self loadRateData];

        
    }else {
        self.kinsfolk = [KinsfolkVO new];
        self.kinsfolk.score = -1;
    }
    
}

- (void)loadPersonData {
    
    
    
    self.nameTextField.text = self.kinsfolk.name;
    self.idCardTextField.text = self.kinsfolk.idCardNo;
    
    
    [self.idUpImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.idPicURL] placeholderImage:[UIImage imageNamed:@"insure_upload_id_up"]];
    [self.idDownImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.idPic2URL] placeholderImage:[UIImage imageNamed:@"insure_upload_id_down"]];
    [self.serverImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.kinsfolkImgURL] placeholderImage:[UIImage imageNamed:@"insure_upload_care_person"]];
    [self.cardImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.healthCareImgURL] placeholderImage:[UIImage imageNamed:@"insure_upload_card"]];


//    [self.idUpImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.idPicURL]];
//    [self.idDownImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.idPic2URL]];
//    [self.serverImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.kinsfolkImgURL]];
//    [self.cardImageButton setImageForState:0 withURL:[NSURL URLWithString:self.kinsfolk.healthCareImgURL]];

    
    self.currentType = [MedicareType new];
    self.currentType.id_p = self.kinsfolk.medicareType;
    self.currentType.medicare = self.kinsfolk.medicare;
    self.careTagLabel.hidden = (self.kinsfolk.medicareType != 1);

    
    self.cardTextField.text = self.kinsfolk.healthCareNo;
    self.cardTextField.textColor = APPDarkCOLOR;
    
    
    if (self.kinsfolk.staffType != 0) {
        self.personTypeField.text = self.kinsfolk.staffType == 1 ? @"在职" : @"退休";

    }
    
    self.markTextView.text = self.kinsfolk.extraInfo;
    
    if (self.kinsfolk.height > 0) {
        [self.heightButton setTitle:self.kinsfolk.height forState:0];

    }
    if (self.kinsfolk.weight > 0) {
        [self.weightButton setTitle:self.kinsfolk.weight forState:0];
        
    }
    self.hospitalCardTextField.text = self.kinsfolk.healthCareNo;
    [self.kinsfolk.languageArray enumerateValuesWithBlock:^(uint32_t value, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (value - 1 < self.lanButtons.count ) {
            UIButton *button = self.lanButtons[value-1];
            [self lanButtonAction:button];
        }
        
    }];
    
    

    
}
- (void)loadLanguages {
    
    
    NSArray *languages = [YJYSettingManager sharedInstance].languageList;
    
    CGFloat width = IS_IPHONE_5 ? 40 : 50;
    CGFloat margin = (self.languageScrollView.frame.size.width - (languages.count * width))/(languages.count-1) + width;
    for (NSInteger  i = 0; i < languages.count; i ++) {
        
        UIButton *lanButton = [[UIButton alloc]initWithFrame:CGRectMake(i * margin, 5, width, 21)];
        lanButton.center = CGPointMake(lanButton.center.x, self.languageScrollView.center.y);
        
        Language *lan = languages[i];
        lanButton.tag = lan.id_p - 1;
        [lanButton setTitle:lan.name forState:0];
        
        lanButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5 ? 10 : 12];
        [lanButton addTarget:self action:@selector(lanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [lanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [lanButton setTitleColor:APPDarkGrayCOLOR forState:UIControlStateNormal];
        lanButton.layer.cornerRadius = lanButton.frame.size.height/2;
        lanButton.backgroundColor = [UIColor clearColor];
        lanButton.layer.borderColor = APPDarkGrayCOLOR.CGColor;
        lanButton.layer.borderWidth = 0.5;
        
        [self.lanButtons addObject:lanButton];
        
        [self.languageScrollView addSubview:lanButton];
        
        
    }
    self.languageScrollView.showsHorizontalScrollIndicator = NO;
    self.languageScrollView.contentSize = CGSizeMake([YJYSettingManager sharedInstance].languageList.count *margin, 0);
}

- (void)loadRateData {
    
    BOOL isNotScore = (!self.kinsfolk || self.kinsfolk.score == -1);
    
    self.scoreLabel.hidden = isNotScore;
    self.scoreTipLabel.hidden = isNotScore;
    
    NSString *rateTip = isNotScore ? @"生活能力评测" : @"重新测评";
    self.rateActionLabel.text = rateTip;
    [self.rateActionLabel sizeToFit];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",@(self.kinsfolk.score)];
}

- (void)loadKinsfolkReq {
    
    if (!self.kinsfolkReq) {
        self.kinsfolkReq = [KinsfolkReq new];

    }
    self.kinsfolkReq.name = self.nameTextField.text;
    self.kinsfolkReq.height = [self.heightButton currentTitle];
    self.kinsfolkReq.weight = [self.weightButton currentTitle];
    self.kinsfolkReq.idCardNo = self.idCardTextField.text;
    self.kinsfolkReq.extraInfo = self.markTextView.text;
    self.kinsfolkReq.medicalNo = self.jiuzhenCardTextField.text;
    self.kinsfolkReq.healthCareNo = self.hospitalCardTextField.text;
    self.kinsfolkReq.medicareType = self.currentType.id_p;
    
    self.kinsfolkReq.idPic = self.kinsfolk.idPic;
    self.kinsfolkReq.idPic2 = self.kinsfolk.idPic2Id;
    self.kinsfolkReq.healthCareImg = self.kinsfolk.healthCareImgId;
    self.kinsfolkReq.kinsfolkImg = self.kinsfolk.kinsfolkImgId;
    self.kinsfolkReq.staffType = self.kinsfolk.staffType;

    
    self.kinsfolkReq.idCardNo = self.kinsfolk.idCardNo;
    self.kinsfolkReq.sex = self.kinsfolk.sex;
    self.kinsfolkReq.age = self.kinsfolk.age;
    
    
    GPBUInt32Array *larry = [GPBUInt32Array array];
    [larry removeAll];
    
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.lanButtons.count; i++) {
        
        UIButton *lanButton = self.lanButtons[i];
        if (lanButton.selected) {
            [larry insertValue:(uint32_t)lanButton.tag+1 atIndex:index++];
        }
    }
    
    self.kinsfolkReq.languageArray = larry;
    
    if (self.isEdit) {
        self.kinsfolkReq.kinsId = self.kinsfolk.kinsId;
    }
    
    self.kinsfolkReq.firstAdd = self.firstAdd;

}



#pragma mark - Image

- (void)checkImage:(NSString *)imgURL sender:(UIButton *)sender{
    
    YJYImageShowController *vc = [YJYImageShowController new];
    vc.imgurl = imgURL;
    vc.didLoadedBlock = ^(UIImage *image) {
        
        [self toUploadImage:image sender:sender];

    };
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)uploadImage:(UIButton *)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        if (buttonIndex != 0) {
            
            UIImagePickerControllerSourceType type = (buttonIndex == 2) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
            
            [[SSPhotoPickerManager sharedSSPhotoPickerManager]showOnPickerViewControllerSourceType:type onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                [self toUploadImage:image sender:sender];
                
                
            } cancel:^{
                
                [SYProgressHUD hide];
                
                
            }];
        }
        
    }];

    
}
- (void)toUploadImage:(UIImage *)image sender:(UIButton *)sender{
    
    [SYProgressHUD showLoadingWindowText:@"正在上传"];
    
    [YJYNetworkManager uploadImageToServerWithImage:image type:kHeadimg success:^(id response) {
        
        NSString *imageID = response[@"imageId"];
        NSString *imageURL = response[@"imgUrl"];
        
        
        if (sender.tag == YJYPersonEditPicTypeIDUp) {
            
            [self toVerfityIDCardWithImage:image sender:sender imgurl:imageURL];
            
        }else if (sender.tag == YJYPersonEditPicTypeIDDown) {
            self.kinsfolk.idPic2Id = imageID;
            self.kinsfolk.idPic2URL = imageURL;
            
        }else if (sender.tag == YJYPersonEditPicTypeServer) {
            self.kinsfolk.kinsfolkImgId = imageID;
            self.kinsfolk.kinsfolkImgURL = imageURL;
            
        }else if (sender.tag == YJYPersonEditPicTypeCard) {
            self.kinsfolk.healthCareImgId = imageID;
            self.kinsfolk.healthCareImgURL = imageURL;
        }
        
        if (sender.tag != YJYPersonEditPicTypeIDUp) {
            [sender setImage:image forState:0];
            [SYProgressHUD hide];
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"上传失败"];
        
        
    }];
}

- (void)toVerfityIDCardWithImage:(UIImage *)image sender:(UIButton *)sender imgurl:(NSString *)imgurl{

    
    [SYProgressHUD showLoadingWindowText:@"正在识别"];

    [YJYNetworkManager uploadImageToServerWithImage:image type:kIdcard success:^(id response) {
        
        
        NSString *imageID = response[@"imageId"];
        self.kinsfolk.idPicURL = response[@"imgUrl"];
        self.kinsfolk.idPic = imageID;

        
        GetIDCardNoReq *req = [GetIDCardNoReq new];
        req.imgId = imageID;
        
        
        [YJYNetworkManager requestWithUrlString:IDCardRecognize message:req controller:self command:APP_COMMAND_IdcardRecognize success:^(id response) {
            
            GetIDCardNoRsp *rsp = [GetIDCardNoRsp parseFromData:response error:nil];
            self.nameTextField.text = rsp.idInfo.fullName;
            self.idCardTextField.text = rsp.idInfo.idcard;
            
            
            [sender setImage:image forState:0];
            
            
            self.kinsfolk.idCardNo = rsp.idInfo.idcard;
            self.kinsfolk.sex = rsp.idInfo.sex;
            self.kinsfolk.age = rsp.idInfo.age;
            self.kinsfolk.idPicURL = imgurl;

            
            [SYProgressHUD hide];
            [SYProgressHUD showToCenterText:@"识别成功"];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Action

- (IBAction)imageButtonAction:(UIButton *)sender {
    
    //1.
    if (sender.tag == YJYPersonEditPicTypeIDUp) {
        if (self.kinsfolk.idPicURL.length > 0) {
            [self checkImage:self.kinsfolk.idPicURL sender:sender];
        }else {
            
            [self uploadImage:sender];
            
        }
    }else if (sender.tag == YJYPersonEditPicTypeIDDown) {
    
        //2.
        if (self.kinsfolk.idPic2URL.length > 0) {
            [self checkImage:self.kinsfolk.idPic2URL sender:sender];
        }else {
            
            [self uploadImage:sender];
            
        }
    }else if (sender.tag == YJYPersonEditPicTypeServer) {
        
         //3.
        if (self.kinsfolk.kinsfolkImgURL.length > 0) {
            [self checkImage:self.kinsfolk.kinsfolkImgURL sender:sender];
        }else {
            
            [self uploadImage:sender];
            
        }
    }else if (sender.tag == YJYPersonEditPicTypeCard) {
        
        //4.
        if (self.kinsfolk.healthCareImgURL.length > 0) {
            [self checkImage:self.kinsfolk.healthCareImgURL sender:sender];
        }else {
            
            [self uploadImage:sender];
            
        }
    }
    
    
}

- (IBAction)rateAction:(id)sender {
    
    
    YJYInsureQuestionController *vc = [YJYInsureQuestionController new];
    vc.idCardNO = self.idCardTextField.text;
    vc.isFromDetail = YES;
    vc.didScoreDone = ^(id responseData) {
        
        NSString *score = responseData[@"score"];
        self.kinsfolk.score = (int32_t)[score integerValue];
        [self loadRateData];
    };
    //score;
    //    calltime;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)lanButtonAction:(UIButton *)sender {
    
    sender.selected  = !sender.selected;
    if (sender.selected) {
        
        sender.backgroundColor = APPHEXCOLOR;
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        
    }else {
        
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderColor = APPDarkGrayCOLOR.CGColor;
        sender.layer.borderWidth = 0.5;
    }
    
    
    
}

- (IBAction)toWeightHeightAction:(id)sender {

    
    YJYHWeightController *vc = [YJYHWeightController instanceWithStoryBoard];
    
    if ([self.heightButton.currentTitle integerValue] == 0) {
        vc.height  = 170;
    }else {
        
        vc.height = [self.heightButton.currentTitle integerValue];
    }
    
    if ([self.weightButton.currentTitle integerValue] == 0) {
        vc.weight  = 65;
    }else {
        
        vc.weight = [self.weightButton.currentTitle integerValue];

    }
   
    vc.dismissBlcok = ^(NSInteger weight, NSInteger height) {
        
        [self.weightButton setTitle:[NSString stringWithFormat:@"%@.0",@(weight)] forState:0];
        [self.heightButton setTitle:[NSString stringWithFormat:@"%@.0",@(height)] forState:0];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)careCardAction:(id)sender {
    
    [self.view endEditing:NO];
    
    
    NSMutableArray *titlesM = [NSMutableArray array];
    for (MedicareType *type in [YJYSettingManager sharedInstance].medicareListArray) {
        [titlesM addObject:type.medicare];
    }
    
    
    LCActionSheetConfig *config = [LCActionSheetConfig config];
    config.buttonHeight = 54;
    config.buttonColor = APPDarkGrayCOLOR;
    config.buttonFont = [UIFont systemFontOfSize:15];
    config.buttonBackgroundColor = [UIColor whiteColor];
    config.animationDuration = 0.25;
    config.separatorColor = APPExtraGrayCOLOR;
    //    config.buttonColor
    
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:nil didDismiss:^(LCActionSheet * _Nonnull actionSheet, NSUInteger buttonIndex) {
        
        if (buttonIndex != 0) {
            
            NSInteger index = buttonIndex - 1;
            self.careTagLabel.hidden = (index != 0);
            self.cardTextField.text = [NSString stringWithFormat:@"%@",titlesM[index]];
            self.cardTextField.textColor = APPDarkCOLOR;
            self.currentType = [YJYSettingManager sharedInstance].medicareListArray[index];
        }
        
        
    } otherButtonTitleArray:titlesM];
    
    [actionSheet show];
    
}

- (IBAction)toPersonPicker:(id)sender {
    
    YJYKinsfolksController *vc = [YJYKinsfolksController instanceWithStoryBoard];
    vc.kinsfolksDidSelectBlock = ^(KinsfolkVO *kinsfolk) {
        self.kinsfolk  = kinsfolk;
        [self loadKinsfolk];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toPickPersonJob:(id)sender {

    [UIAlertController showAlertInViewController:self withTitle:@"选择人员类别" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:@"在职" otherButtonTitles:@[@"退休"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
    
        if (buttonIndex != 0) {
            
            self.personTypeField.text = buttonIndex == 1 ? @"在职" : @"退休";
            self.kinsfolk.staffType = (uint32_t)buttonIndex;
        }
    
    }];
}
- (IBAction)toExpandAction:(id)sender {
    
    self.isExpand = !self.isExpand;
    self.expandImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",!self.isExpand ? @"app_arrow_down" : @"app_arrow_up"]];

    [self.tableView reloadData];
    
}
#pragma mark - UITextField
- (IBAction)nameDidChange:(id)sender {
    
    if ([self.nameTextField isFirstResponder] && self.nameTextField.text.length > 6) {
        self.nameTextField.text = [self.nameTextField.text substringToIndex:6];
        return;
    }
}

- (IBAction)idCardDidChangeEditing:(id)sender {
    
    if ([self.idCardTextField isFirstResponder] && self.idCardTextField.text.length > 18) {
        self.idCardTextField.text = [self.idCardTextField.text substringToIndex:18];
        return;
    }
    
}
- (IBAction)idCardDidEndEditing:(id)sender {
    
    if (self.idCardTextField.text.length < 18) {
        
        [SYProgressHUD showFailureText:@"请输入正确的身份证号"];
        return;
    }
    
    IDCardNumberValidator *validator = [IDCardNumberValidator validateIDCardNumber:self.idCardTextField.text];
    
    if (!validator.isValidated) {
        [SYProgressHUD showFailureText:@"身份证无效"];
    }else if (!validator.isBirthday) {
        [SYProgressHUD showFailureText:@"生日无效"];
    }else if (!validator.isMouth) {
        [SYProgressHUD showFailureText:@"月份无效"];
    }else if (!validator.isDay) {
        [SYProgressHUD showFailureText:@"日期无效"];
    }else if (!validator.isZoneCode) {
        [SYProgressHUD showFailureText:@"地区编码错误"];
    }
    
    if (validator.isValidated) {
        
        
        self.kinsfolk.sex = validator.sex;
        self.kinsfolk.age = validator.age;
    }
    
    self.kinsfolk.idCardNo = self.idCardTextField.text;
    
}



#pragma mark - done

- (void)done{


    [SYProgressHUD show];
    
    
    NSString *urlString = (self.isEdit) ? APPUpdateKinsfolk : APPAddKinsfolk;
    APP_COMMAND command = (self.isEdit) ? APP_COMMAND_AppupdateKinsfolk : APP_COMMAND_AppaddKinsfolk;
    
    //self.kinsfolk
    [self loadKinsfolkReq];
    self.kinsfolkReq.kinsType = self.kinsType;
    
    
    [YJYNetworkManager requestWithUrlString:urlString message:self.kinsfolkReq controller:self command:command success:^(id response) {
        
        CreateKinsfolkRsp *rsp = [CreateKinsfolkRsp new];
        self.kinsfolk.kinsId = rsp.kinsId;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
       
            [self.navigationController popViewControllerAnimated:YES];
            [SYProgressHUD showSuccessText: (self.isEdit) ? @"修改成功" : @"添加成功"];
            
        });
        
    } failure:^(NSError *error) {
        
    }];

    
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row >= 4 && indexPath.row <=8) {
        
        if (self.isExpand) {
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];

        }else {
            return 0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end



@interface YJYPersonEditController ()


@property (strong, nonatomic) YJYPersonEditContentController *contentVC;


@end



@implementation YJYPersonEditController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYPersonEditController *)[UIStoryboard storyboardWithName:@"YJYPerson" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:NSStringFromClass([YJYPersonEditContentController class])]) {
        
        self.contentVC = (YJYPersonEditContentController *)segue.destinationViewController;
        self.contentVC.kinsfolk = self.kinsfolk;
        self.contentVC.firstAdd = self.firstAdd;
        self.contentVC.kinsType = self.kinsType;
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.kinsType == 0) {
        self.title = [NSString stringWithFormat:@"%@家庭成员",self.kinsfolk ? @"编辑" : @"添加"];
    }else {
        self.title = [NSString stringWithFormat:@"%@参保人",self.kinsfolk ? @"编辑" : @"添加"];
    }
}

- (IBAction)done:(id)sender {
    [self.contentVC done];
}


@end
