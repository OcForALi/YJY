//
//  YJYInsureGuideTeachDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureGuideTeachDetailController.h"
#import "YJYInsureDisableView.h"
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "YJYSignatureController.h"

typedef NS_ENUM(NSInteger,YJYInsureGuideTeachDetailType) {
    
    YJYInsureGuideTeachDetailTypeTrainTime,
    YJYInsureGuideTeachDetailTypeTrainBeginTime,
    YJYInsureGuideTeachDetailTypeTrainEndTime,
    YJYInsureGuideTeachDetailTypeHourTime,
    YJYInsureGuideTeachDetailTypeDoHourTitle,
    YJYInsureGuideTeachDetailTypeDoHourTime,
    YJYInsureGuideTeachDetailTypeBlankOne,
    
    YJYInsureGuideTeachDetailTypeContentTrain,
    YJYInsureGuideTeachDetailTypeContentTextView,
    YJYInsureGuideTeachDetailTypeReviewContent,
    YJYInsureGuideTeachDetailTypeReviewTextView,
    YJYInsureGuideTeachDetailTypeBlankTwo,
    
    YJYInsureGuideTeachDetailTypeSelfReview,
    YJYInsureGuideTeachDetailTypeSelfReviewTextView,
    YJYInsureGuideTeachDetailTypeGuide,
    YJYInsureGuideTeachDetailTypeGuideTextView,
    YJYInsureGuideTeachDetailTypeBlankThree,

    YJYInsureGuideTeachDetailTypeOther,
    YJYInsureGuideTeachDetailTypeOtherTextView,
    YJYInsureGuideTeachDetailTypePic,
    YJYInsureGuideTeachDetailTypeBlankFour,
    
    YJYInsureGuideTeachDetailTypeObjectSign,
    YJYInsureGuideTeachDetailTypeGuideSign,
};

@interface YJYInsureGuideTeachDetailContentController : YJYTableViewController
@property (weak, nonatomic) IBOutlet UILabel *trainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainEndTimeLabel;



@property (weak, nonatomic) IBOutlet UITextField *trainHoursLabel;
@property (weak, nonatomic) IBOutlet UITextField *trainDoHourLabel;
@property (weak, nonatomic) IBOutlet UITextView *trainContentLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewContentLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkContentLabel;

@property (weak, nonatomic) IBOutlet UIView *otherImageView;

@property (strong, nonatomic)IBOutlet YJYInsureDisableView *insureImageView;
@property (strong, nonatomic) GetTeachRecordRsp *rsp;
@property (strong, nonatomic) AddTeachRecordReq *addTeachRecordReq;



@property (strong, nonatomic) TeachRecordVO *teachRecordVO;
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) uint64_t recordId;
@property (copy, nonatomic) YJYInsureGuideTeachDetailDidDoneBlock didDoneBlock;

//button
@property (weak, nonatomic) IBOutlet UIButton *timeBeginPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *timeEndPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *selfSignURLButton;
@property (weak, nonatomic) IBOutlet UIButton *hgSignURLButton;
//自我评价
@property (weak, nonatomic) IBOutlet UIButton *selfMasterReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *selfRequestReviewButton;

//带教评价
@property (weak, nonatomic) IBOutlet UIButton *guideMasterReviewButton;
@property (weak, nonatomic) IBOutlet UIButton *guideRequestReviewButton;


@property (weak, nonatomic) IBOutlet UIButton *trainContentButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewContentButton;


@property(nonatomic, copy) NSString *oneToken;
@property(nonatomic, copy) NSString *token;


@end

@implementation YJYInsureGuideTeachDetailContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selfSignURLButton.backgroundColor = [UIColor clearColor];
    self.hgSignURLButton.backgroundColor = [UIColor clearColor];
    self.rsp = [GetTeachRecordRsp new];
    
    self.addTeachRecordReq = [AddTeachRecordReq new];
    
    [self setupImageView];
    
    if (self.teachRecordVO.recordId) {
        [self loadNetworkData];
    }
    [self setupEnable];
}

- (void)loadNetworkData {
    [SYProgressHUD show];
    GetTeachRecordReq *req = [GetTeachRecordReq new];
    req.recordId = self.teachRecordVO.recordId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetTeachRecord message:req controller:self command:APP_COMMAND_SaasappgetTeachRecord success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp  = [GetTeachRecordRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadRsp {
    
    self.insureImageView.backgroundColor = [UIColor clearColor];
    NSMutableArray *picM = [NSMutableArray array];
    for (NSString *pic in self.rsp.record.picUrlsArray) {
        picUrlId *picobj = [picUrlId new];
        picobj.picId = 0;
        picobj.picURL = pic;
        [picM addObject:picobj];
    }
    self.insureImageView.picURLIdArray = picM;

    
    //
    
    self.trainTimeLabel.text = [NSString stringWithFormat:@"%@",self.rsp.record.teachTimeStr];
    self.trainHoursLabel.text = [NSString stringWithFormat:@"%@小时",@(self.rsp.record.trainTime)];
    self.trainDoHourLabel.text = [NSString stringWithFormat:@"%@小时",@(self.rsp.record.exerciseTime)];
    
    //
    
    self.trainContentLabel.text = [self.rsp.record.trainContentArray componentsJoinedByString:@"\n"];
    
    self.reviewContentLabel.text = [self.rsp.record.exerciseContentArray componentsJoinedByString:@"\n"];
    
    self.remarkContentLabel.text = self.rsp.record.remark;
    
    //自我评价
    
    if (self.rsp.selfPraise != 0){
     
        
        [self reviewAction:self.rsp.record.selfPraise== 1 ? self.selfMasterReviewButton : self.selfRequestReviewButton];
    }else {
        
        [self reviewAction:nil];
    }
    
    if (self.rsp.hgPraise != 0){
        
        [self guideReviewAction: self.rsp.record.hgPraise== 1 ? self.guideMasterReviewButton : self.guideRequestReviewButton];

     

    }else {
        
        [self guideReviewAction:nil];
    }
    
    
    
    //签名
    self.selfSignURLButton.backgroundColor = [UIColor clearColor];
    self.hgSignURLButton.backgroundColor = [UIColor clearColor];
    
    if (self.teachRecordVO) {
        [self.selfSignURLButton setImageForState:0 withURL:[NSURL URLWithString:self.rsp.record.selfSignURL]];
        [self.hgSignURLButton setImageForState:0 withURL:[NSURL URLWithString:self.rsp.record.hgSignURL]];
    }else {
        
        [self.selfSignURLButton setTitle:@"未签名" forState:0];
        [self.hgSignURLButton setTitle:@"未签名" forState:0];

        
    }
    
    self.insureImageView.frame = self.otherImageView.bounds;
    
    [self.tableView reloadData];



}
- (void)setupEnable {
    
    BOOL isEdit = self.teachRecordVO == nil;
    self.timeEndPickerButton.hidden = !isEdit;
    self.timeBeginPickerButton.hidden = !isEdit;

    self.trainHoursLabel.userInteractionEnabled = isEdit;
    self.trainDoHourLabel.userInteractionEnabled = isEdit;
//    self.trainContentLabel.userInteractionEnabled = isEdit;
    self.remarkContentLabel.userInteractionEnabled = isEdit;
    
    self.timeBeginPickerButton.hidden = !isEdit;
    self.timeEndPickerButton.hidden = !isEdit;
    self.trainContentButton.hidden = !isEdit;
    self.reviewContentButton.hidden = !isEdit;
    
    self.selfMasterReviewButton.userInteractionEnabled = isEdit;
    self.selfRequestReviewButton.userInteractionEnabled = isEdit;
    self.guideMasterReviewButton.userInteractionEnabled = isEdit;
    self.guideRequestReviewButton.userInteractionEnabled = isEdit;

    

}
- (void)setupImageView {
    
    __weak typeof(self) weakSelf = self;
    self.insureImageView = [[YJYInsureDisableView alloc]initWithFrame:self.otherImageView.bounds];
    [self.otherImageView addSubview:self.insureImageView];
    self.otherImageView.backgroundColor = [UIColor clearColor];
    self.insureImageView.isAdd = self.teachRecordVO == nil;

    self.insureImageView.imagesType = YJYInsureImagesTypeOther;
    self.insureImageView.didSelectBlock = ^(NSString *imgurl, NSInteger index) {
        
        [XLPhotoBrowser showPhotoBrowserWithImages:weakSelf.insureImageView.picArray currentImageIndex:index];
        
    };
    self.insureImageView.didAddImageBlock = ^{
        
        
        [UIAlertController showAlertInViewController:weakSelf withTitle:@"选择图片" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            
            if (buttonIndex > 0) {
                [weakSelf toSelectImagesActionWithType:YJYInsureImagesTypeOther isTakePicture:buttonIndex == 3];
                
            }
            
            
        }];
    };
}


- (void)toSelectImagesActionWithType:(YJYInsureImagesType)type isTakePicture:(BOOL)isTakePicture{
    
    
    if (!isTakePicture) {
        
        NSInteger maxSelectCount = 0;
        if (type == YJYInsureImagesTypeDisable) {
            maxSelectCount = 9 - self.insureImageView.picArray.count;
        }else {
            
            maxSelectCount = 9 - self.insureImageView.picArray.count;
            
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
            
            [self.insureImageView.picArray addObjectsFromArray:urls];
            [self.insureImageView.imageIds addObjectsFromArray:imageStrIDs];
            [self.tableView reloadData];
            [self.insureImageView.collectionView reloadData];
            [SYProgressHUD hide];
            
        }else {
            
            [SYProgressHUD hide];
            
        }
        
        
        
        
    } errorCodeBlock:^(id errorCode) {
        
        [SYProgressHUD showFailureText:@"网络错误"];
        
    }];
    
}
- (IBAction)toselfSign:(UIButton *)sender {
    
    
    if (self.rsp.record.selfSignURL.length > 0) {
        
        [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.record.selfSignURL] currentImageIndex:0];

        
    }else {
        
        YJYSignatureController *vc = [YJYSignatureController new];
        vc.orderId = self.orderId;
        vc.isInsure = YES;
        vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
            self.addTeachRecordReq.selfSign = imageID;
            self.rsp.record.selfSignURL = imageURL;
            
            [SYProgressHUD showSuccessText:@"签名成功"];
            [sender setTitle:@"查看" forState:0];

            
            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    

}

- (IBAction)tohgSign:(UIButton *)sender {
    
    if (self.rsp.record.hgSignURL.length > 0) {
        
        [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.record.hgSignURL] currentImageIndex:0];
        
        
    }else {
        
        YJYSignatureController *vc = [YJYSignatureController new];
        vc.orderId = self.orderId;
        vc.isInsure = YES;
        vc.didReturnImage = ^(NSString *imageID, NSString *imageURL) {
            self.addTeachRecordReq.hgSign = imageID;
            self.rsp.record.hgSignURL = imageURL;
            
            [SYProgressHUD showSuccessText:@"签名成功"];
            [sender setTitle:@"查看" forState:0];

        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
}
- (IBAction)reviewAction:(UIButton *)sender {
    self.selfMasterReviewButton.selected = NO;
    self.selfMasterReviewButton.backgroundColor = APPSaasF8Color;
    
    
    self.selfRequestReviewButton.selected = NO;
    self.selfRequestReviewButton.backgroundColor = APPSaasF8Color;
    if (sender) {
        sender.selected = YES;
        sender.backgroundColor = APPHEXCOLOR;
    }
    
    
    
}
- (IBAction)guideReviewAction:(UIButton *)sender {
    
    self.guideMasterReviewButton.selected = NO;
    self.guideMasterReviewButton.backgroundColor = APPSaasF8Color;
    self.guideRequestReviewButton.selected = NO;
    self.guideRequestReviewButton.backgroundColor = APPSaasF8Color;
    
    if (sender) {
        sender.selected = YES;
        sender.backgroundColor = APPHEXCOLOR;
    }
    
}
- (IBAction)trainContentAction:(UIButton *)sender {
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    
    NSString *tokenStr = @"";
    if (self.oneToken) {
        tokenStr = [NSString stringWithFormat:@"&token=%@",self.oneToken];
    }
    //&flag=edit
    NSString *url = [NSString stringWithFormat:@"%@?tmpType=%@%@",kInsureteachskill,@(1),tokenStr];
    vc.urlString = url;
    vc.didDone = ^(id result) {
        
        NSString *token = result[@"token"];
        GetTeachRecordTmpValueReq *req = [GetTeachRecordTmpValueReq new];
        req.token = token;
        self.oneToken = token;
        [YJYNetworkManager requestWithUrlString:SAASAPPGetTeachRecordTmpValue message:req controller:self command:APP_COMMAND_SaasappgetTeachRecordTmpValue success:^(id response) {
            
            GetTeachRecordTmpValueRsp *rsp= [GetTeachRecordTmpValueRsp parseFromData:response error:nil];
            self.addTeachRecordReq.exerciseContentArray = rsp.contentArray;
            
            self.trainContentLabel.text = [self.addTeachRecordReq.exerciseContentArray componentsJoinedByString:@"\n"];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    };
    vc.title = @"培训内容";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reviewContentAction:(id)sender {
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    
    
    NSString *tokenStr = @"";
    if (self.token) {
        tokenStr = [NSString stringWithFormat:@"&token=%@",self.token];
    }
    //&flag=edit
    NSString *url = [NSString stringWithFormat:@"%@?tmpType=%@%@",kInsureteachskill,@(2),tokenStr];
    
    vc.urlString = url;
    vc.didDone = ^(id result) {
        
        NSString *token = result[@"token"];
        GetTeachRecordTmpValueReq *req = [GetTeachRecordTmpValueReq new];
        req.token = token;
        self.token = token;

        [YJYNetworkManager requestWithUrlString:SAASAPPGetTeachRecordTmpValue message:req controller:self command:APP_COMMAND_SaasappgetTeachRecordTmpValue success:^(id response) {
            
            GetTeachRecordTmpValueRsp *rsp= [GetTeachRecordTmpValueRsp parseFromData:response error:nil];
            self.addTeachRecordReq.trainContentArray = rsp.contentArray;
            self.reviewContentLabel.text = [self.addTeachRecordReq.trainContentArray componentsJoinedByString:@"\n"];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    };
    vc.title = @"考核内容";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)beginTimeAction:(id)sender {
    
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];

    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;
    picker.didSelectDate = ^(NSDate *date) {
        self.trainBeginTimeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
    };
    [picker setDate:[NSDate dateString:self.trainBeginTimeLabel.text Format:YYYY_MM_DD_HH_MM]];
    [picker show];
}

- (IBAction)endTimeAction:(id)sender {
    
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];

    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;
    picker.didSelectDate = ^(NSDate *date) {
        self.trainEndTimeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
    };
    [picker setDate:[NSDate dateString:self.trainEndTimeLabel.text Format:YYYY_MM_DD_HH_MM]];
    [picker show];
}

- (IBAction)done:(id)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否提交" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
         
            AddTeachRecordReq *req  = [AddTeachRecordReq new];
            req.orderId = self.orderId ? self.orderId : self.teachRecordVO.orderId;
            req.trainTime = [self.trainHoursLabel.text integerValue];
            req.exerciseTime = [self.trainDoHourLabel.text integerValue];
            req.remark = self.remarkContentLabel.text;
            req.trainContentArray = [NSMutableArray arrayWithArray:[self.trainContentLabel.text componentsSeparatedByString:@"\n"]];
            req.exerciseContentArray = [NSMutableArray arrayWithArray:[self.reviewContentLabel.text componentsSeparatedByString:@"\n"]];

            req.startTime = self.trainBeginTimeLabel.text;
            req.endTime = self.trainEndTimeLabel.text;
            
            req.selfPraise = self.selfRequestReviewButton.selected ? 2: 1;
            req.hgPraise = self.guideRequestReviewButton.selected ? 2: 1;
            
            req.picsArray = self.insureImageView.imageIds;
            
            //addTeachRecordReq
            req.selfSign = self.addTeachRecordReq.selfSign;
            req.hgSign = self.addTeachRecordReq.hgSign;
            
            if (!req.trainContentArray) {
                req.trainContentArray = self.addTeachRecordReq.trainContentArray;

            }
            if (!req.exerciseContentArray) {
                req.exerciseContentArray = self.addTeachRecordReq.exerciseContentArray;

            }
            
            [YJYNetworkManager requestWithUrlString:SAASAPPAddTeachRecord message:req controller:self command:APP_COMMAND_SaasappaddTeachRecord success:^(id response) {
                
                if (self.didDoneBlock) {
                    self.didDoneBlock();
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.row == YJYInsureGuideTeachDetailTypeTrainTime) {
        H = self.teachRecordVO ? H : 0;
    }else if (indexPath.row >= YJYInsureGuideTeachDetailTypeTrainBeginTime &&
              indexPath.row <= YJYInsureGuideTeachDetailTypeTrainEndTime) {
        H = self.teachRecordVO ? 0 : H;
        
    }else if (indexPath.row == YJYInsureGuideTeachDetailTypePic) {
        H =  [self.insureImageView cellHeight] + 20;

    }else if (indexPath.row == YJYInsureGuideTeachDetailTypeContentTextView) {
        
        NSArray *arr = [self.trainContentLabel.text componentsSeparatedByString:@"\n"];
        
        H = arr.count * 21 + arr.count == 0 ? 200 : 200;
        
    }else if (indexPath.row == YJYInsureGuideTeachDetailTypeReviewTextView) {
        NSArray *arr = [self.reviewContentLabel.text componentsSeparatedByString:@"\n"];

        H = arr.count * 21 + arr.count == 0 ? 200  :200;
    }
    
    return H;
    
}
@end

@interface YJYInsureGuideTeachDetailController ()

@property (strong, nonatomic) YJYInsureGuideTeachDetailContentController *contentVC;

@end

@implementation YJYInsureGuideTeachDetailController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureGuideTeachDetailController *)[UIStoryboard storyboardWithName:@"YJYInsureGuideTeach" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureGuideTeachDetailContentController"]) {
        
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYInsureGuideTeachDetailContentController *)segue.destinationViewController;
        self.contentVC.teachRecordVO = self.teachRecordVO;
        self.contentVC.orderId = self.orderId;
        self.buttonView.hidden = self.teachRecordVO != nil;
        
        
        self.contentVC.didDoneBlock = ^{
            
            if (weakSelf.didDoneBlock) {
                weakSelf.didDoneBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];

            
        };
        
        
        
    }
}

- (IBAction)done:(id)sender {
    [self.contentVC done:nil];
}


@end
