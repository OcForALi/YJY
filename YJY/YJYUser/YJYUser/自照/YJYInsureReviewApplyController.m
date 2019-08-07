//
//  YJYInsureReviewApplyController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureReviewApplyController.h"
#import "YJYInsureBookDoneController.h"
#import "YJYAddressPositionController.h"
#import "YJYAddressesController.h"
#import "MDHTMLLabel.h"
#import "YJYWeakTimerManager.h"


typedef NS_ENUM(NSInteger, YJYInsureReviewApplyType) {
    
    YJYInsureReviewApplyTypeServeTitle,
    YJYInsureReviewApplyTypeServeItem,
    YJYInsureReviewApplyTypeBeServe,
    YJYInsureReviewApplyTypeServeCompany,
    YJYInsureReviewApplyTypeServeBlank,
    
    //
    YJYInsureReviewApplyTypeContactTitle,
    YJYInsureReviewApplyTypeContact,
    YJYInsureReviewApplyTypeContactBlank,
    
    //
    
    YJYInsureReviewApplyTypeWorkerTitle,
    YJYInsureReviewApplyTypeWorkerContact,
    YJYInsureReviewApplyTypeWorkerCode,
    YJYInsureReviewApplyTypeWorkerBlank,
    
    //
    
    YJYInsureReviewApplyTypeFamilyName,
    YJYInsureReviewApplyTypeFamilyCardID,
    YJYInsureReviewApplyTypeFamilyRelation,
    YJYInsureReviewApplyTypeCommendPeople,
    YJYInsureReviewApplyTypeFamilyBlank,
    
    //
    
    YJYInsureReviewApplyTypeOtherTitle,
    YJYInsureReviewApplyTypeOtherTime,
    YJYInsureReviewApplyTypeOtherCommendPeople,
    YJYInsureReviewApplyTypeOtherBlank,
};

@interface YJYInsureReviewApplyContentController : YJYTableViewController
@property (weak, nonatomic) IBOutlet UILabel *serviceItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServedPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *adlScoreLabel;

@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;


//TextField

@property (weak, nonatomic) IBOutlet UITextField *familyPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *veriftyCodeTextField;


@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyRelationTextField;
@property (weak, nonatomic) IBOutlet UITextField *recommendTextField;

//data

@property (strong, nonatomic) InsurePriceVO *insurePriceVO;
@property (strong, nonatomic) GetInsureOrderInfoRsp *rsp;
@property (assign, nonatomic) NSInteger currentCountDown;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UserAddressVO *address;

@property (copy, nonatomic) NSString *insureNo;

@end

@implementation YJYInsureReviewApplyContentController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNetworkData];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(dismiss)];

    
    
}

- (void)dismiss {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)loadNetworkData {
    
  
    
    GetInsureOrderInfoReq *req = [GetInsureOrderInfoReq new];
    req.insureNo = [self insureNo];
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureOrderInfo message:req controller:self command:APP_COMMAND_AppgetInsureOrderInfo success:^(id response) {
        
        self.rsp = [GetInsureOrderInfoRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)reloadRsp {
    
    self.serviceItemLabel.text = self.insurePriceVO.serviceItem;
    
    self.beServedPersonLabel.text = self.rsp.kinsName;
    self.adlScoreLabel.text = [NSString stringWithFormat:@"(ADL %@分)",@(self.rsp.scoreAdl)];//分数
    self.orgLabel.text = self.rsp.companyName;
    self.contactLabel.htmlText =  [NSString yjy_ContactStringWithContact:self.rsp.contactName phone:self.rsp.contactPhone];
    self.addressLabel.text = self.rsp.address;
    self.startTimeLabel.text = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];

}

#pragma mark - Action


- (IBAction)addressAction:(id)sender {
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:APPListUserAddress message:nil controller:self command:APP_COMMAND_ApplistUserAddress success:^(id response) {
        
        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
        
        YJYAddressesController *listVC = [YJYAddressesController instanceWithStoryBoard];
        listVC.isApply = YES;
        listVC.didSelectBlock = ^(UserAddressVO *address) {
            [self setupAddress:address];
        };
        
        if (rsp.userAddressVoArray.count > 0) {
            
            [self.navigationController pushViewController:listVC animated:YES];
            
        }else {
            
            
            YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
            vc.title = @"添加联系信息";
            vc.addressDidSavedBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }
        [SYProgressHUD hide];
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}
- (void)setupAddress:(UserAddressVO *)address {

    self.address = address;
    
    self.addressLabel.attributedText = [address.addressInfo attributedStringWithLineSpacing:6];
    [self.addressLabel sizeToFit];
    self.contactLabel.htmlText = [NSString yjy_ContactStringWithContact: address.contacts phone:address.phone];
    self.rsp.addrId = self.address.addrId;
    [self.tableView reloadData];
    
}
- (IBAction)toSendCode:(UIButton *)sender {
    
    if (self.familyPhoneTextField.text.length == 0) {
        
        [SYProgressHUD showFailureText:@"手机不能为空"];
        return;
    }
    
    if (self.familyPhoneTextField.text.length != 11) {
        [SYProgressHUD showFailureText:@"手机号输入错误"];
        return;
    }
    sender.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    sender.spinner.color = APPHEXCOLOR;
    [sender updateActivityIndicatorVisibility];
    
    GetVerifyCodeReq *codeReq = [GetVerifyCodeReq new];
    codeReq.phone = self.familyPhoneTextField.text;
    codeReq.purpose = @"Login";
    codeReq.source = 0;
    
    [YJYNetworkManager requestWithUrlString:GetSMSCode message:codeReq controller:self command:APP_COMMAND_GetSmscode success:^(id response) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self beginCountdown];
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)beginCountdown {
    
    [_authCodeButton stopActivityIndicatorVisibility];
    _authCodeButton.enabled = NO;
    
    _currentCountDown = 60;
    _timer = [YJYWeakTimerManager scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
        
        
        if (_timer && _currentCountDown == 0 ) {
            [_timer invalidate];
            _timer = nil;
            [_authCodeButton setTitle:@"获取验证码" forState:0];
            _authCodeButton.enabled = YES;
            
            return;
        }
        
        _currentCountDown -=1;
        [_authCodeButton setTitle:[NSString stringWithFormat:@"剩余%d秒",(int)_currentCountDown] forState:UIControlStateNormal];
        
    } userInfo:@"fire" repeats:YES];
    
    [_timer fire];
}

- (void)done {
    
    AddInsureOrderReq *req = [AddInsureOrderReq new];
    req.priceId = self.insurePriceVO.priceId;
    req.insureNo = [self insureNo];
    req.phone = self.familyPhoneTextField.text;
    req.code = self.veriftyCodeTextField.text;
    
    //
    req.hgName = self.familyNameTextField.text;
    req.idcard = self.familyIDTextField.text;
    req.relation = self.familyRelationTextField.text;
    req.hgNo = self.recommendTextField.text;
    //
    req.addrId = self.rsp.addrId;
    
    [YJYNetworkManager requestWithUrlString:APPAddInsureOrder  message:req controller:self command:APP_COMMAND_AppaddInsureOrder success:^(id response) {
        
        AddInsureOrderRsp *rsp = [AddInsureOrderRsp parseFromData:response error:nil];
        YJYInsureBookDoneController *vc = [YJYInsureBookDoneController instanceWithStoryBoard];
        vc.rsp = rsp;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= YJYInsureReviewApplyTypeOtherTitle &&
        indexPath.row <= YJYInsureReviewApplyTypeOtherBlank) {
        
        return 0;
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end

#pragma mark - YJYInsureReviewApplyController

@interface YJYInsureReviewApplyController ()


@property (strong, nonatomic) YJYInsureReviewApplyContentController *contentVC;

@end

@implementation YJYInsureReviewApplyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureReviewApplyController *)[UIStoryboard storyboardWithName:@"YJYInsureReviewApply" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureReviewApplyContentController"]) {
        self.contentVC = (YJYInsureReviewApplyContentController *)segue.destinationViewController;
        self.contentVC.insureNo = self.insureNo;
        self.contentVC.insurePriceVO = self.insurePriceVO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];


}
- (IBAction)done:(id)sender {
    
    [self.contentVC done];
}


@end
