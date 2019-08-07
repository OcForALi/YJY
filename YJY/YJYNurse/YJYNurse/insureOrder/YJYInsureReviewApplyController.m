//
//  YJYInsureReviewApplyController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureReviewApplyController.h"
#import "YJYAddressPositionController.h"
#import "YJYAddressesController.h"
#import "MDHTMLLabel.h"
#import "YJYWeakTimerManager.h"
#import "YJYInsureOrderDetailController.h"

typedef NS_ENUM(NSInteger, YJYInsureReviewApplyType) {
    
    YJYInsureReviewApplyTypeServeTitle,
    YJYInsureReviewApplyTypeBeServe,
    
    //
    YJYInsureReviewApplyTypeContactTitle,
    YJYInsureReviewApplyTypeContact,
    YJYInsureReviewApplyTypeContactBlank,
    
//
    
    YJYInsureReviewApplyTypeFamilyService,
    YJYInsureReviewApplyTypeFamilyRelationPhone,
    YJYInsureReviewApplyTypeFamilyName,
    YJYInsureReviewApplyTypeFamilyCardID,
    YJYInsureReviewApplyTypeFamilyRelation,
    YJYInsureReviewApplyTypeFamilyBlank,
    
    //
    
    YJYInsureReviewApplyTypeReview,
    YJYInsureReviewApplyTypeReviewBlank,
    YJYInsureReviewApplyTypeTeachTitle,
};

@interface YJYInsureReviewApplyContentController : YJYTableViewController


@property (copy, nonatomic) NSString *orderId;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *serviceItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServedPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *adlScoreLabel;

@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;


//TextField

@property (weak, nonatomic) IBOutlet UITextField *familyPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyRelationTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

//data
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;


@property (strong, nonatomic) InsurePriceVO *insurePriceVO;
@property (strong, nonatomic) GetInsureOrderInfoRsp *rsp;
@property (assign, nonatomic) NSInteger currentCountDown;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UserAddressVO *address;
@property(nonatomic, readwrite) uint64_t priceId;

@property (copy, nonatomic) NSString *insureNo;

@end

@implementation YJYInsureReviewApplyContentController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.insurePriceVO.serviceType == 181) {
        
        [self setupLocalData];
        [self loadNetworkData];
        
    }else {
        [self loadNetworkData];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(dismiss)];
        
        
        [self.familyPhoneTextField addTarget:self action:@selector(toGetHGIdcardByPhone:) forControlEvents:UIControlEventEditingDidEnd];
        
    }
    
    
    
}
- (void)setupLocalData {
    self.beServedPersonLabel.text = self.orderDetailRsp.order.contacts;
    self.adlScoreLabel.text = [NSString stringWithFormat:@"(ADL %@分)",@(self.orderDetailRsp.adlScore)];//分数
    
    self.contactLabel.htmlText =  [NSString yjy_ContactStringWithContact:self.orderDetailRsp.order.contacts phone:self.orderDetailRsp.order.contactPhone];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@",self.orderDetailRsp.order.province,self.orderDetailRsp.order.city,self.orderDetailRsp.order.district,self.orderDetailRsp.order.building,self.orderDetailRsp.order.addrDetail];
    
}

- (void)setupOrderDetailRsp {
    
    if (self.orderDetailRsp) {
        self.familyPhoneTextField.text = self.orderDetailRsp.order.relationPhone;
        self.familyNameTextField.text = self.orderDetailRsp.order.relationName;
        self.familyIDTextField.text = self.orderDetailRsp.order.idCard;
        self.familyRelationTextField.text = self.orderDetailRsp.order.relation;
        self.serviceItemLabel.text = self.orderDetailRsp.order.serviceItem;

    }
    
   
    
}

- (void)dismiss {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)toGetHGIdcardByPhone:(UITextField *)textField {
    
    if (self.familyPhoneTextField.text.length == 11) {
        
        GetHGIdcardByPhoneReq *req = [GetHGIdcardByPhoneReq new];
        req.phone = self.familyPhoneTextField.text;
        req.isSaasapp = YES;
        [YJYNetworkManager requestWithUrlString:GetHGIdcardByPhone message:req controller:self command:APP_COMMAND_GetHgidcardByPhone success:^(id response) {
            
            
            GetHGIdcardByPhoneRsp *rsp = [GetHGIdcardByPhoneRsp parseFromData:response error:nil];
            
            self.familyIDTextField.text = rsp.idcard;
            self.familyNameTextField.text = rsp.hgName;
            
            
        } failure:^(NSError *error) {
        
        }];
    }
}


- (void)loadNetworkData {
    
  
    GetInsureOrderInfoReq *req = [GetInsureOrderInfoReq new];
    req.insureNo = [self insureNo];
    req.orderId = self.orderId ? self.orderId : self.orderDetailRsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderInfo message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderInfo success:^(id response) {
        
        self.rsp = [GetInsureOrderInfoRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self setupOrderDetailRsp];
        [self reloadAllData];

        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)reloadRsp {
    
    self.titleLabel.text = self.rsp.phone;
    self.serviceItemLabel.text = self.insurePriceVO.serviceItem;
    
    self.beServedPersonLabel.text = self.rsp.kinsName;
    self.adlScoreLabel.text = [NSString stringWithFormat:@"(ADL %@分)",@(self.rsp.scoreAdl)];//分数

    self.contactLabel.htmlText =  [NSString yjy_ContactStringWithContact:self.rsp.contactName phone:self.rsp.contactPhone];
    self.addressLabel.text = self.rsp.address;
    self.startTimeLabel.text = [NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD];
    [YJYSettingManager sharedInstance].userId = self.rsp.userId;
    if (self.insurePriceVO.serviceType == 181) {
        
        [self setupLocalData];
        
    }
}

#pragma mark - Action


- (IBAction)addressAction:(id)sender {
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserAddrList message:nil controller:self command:APP_COMMAND_SaasappgetUserAddrList success:^(id response) {
        
        [YJYSettingManager sharedInstance].userId = self.rsp.userId;

        
//        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
//        YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
//        vc.title = @"添加联系信息";
//        vc.addressDidSavedBlock = ^(UserAddressVO *address) {
//            [self setupAddress:address];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
        
        YJYAddressesController *listVC = [YJYAddressesController instanceWithStoryBoard];
        listVC.isApply = YES;
        listVC.didSelectBlock = ^(UserAddressVO *address) {
            [self setupAddress:address];
        };

        [self.navigationController pushViewController:listVC animated:YES];

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


- (void)done {
    
    AddInsureOrderReq *req = [AddInsureOrderReq new];
    req.orderId = self.orderId ? self.orderId : self.orderDetailRsp.order.orderId;
    req.remark = self.remarkTextView.text;

    
    req.priceId = self.insurePriceVO.priceId > 0 ? self.insurePriceVO.priceId : self.priceId;
    req.insureNo = self.insureNo;
    
    //
    req.hgName = self.familyNameTextField.text;
    req.idcard = self.familyIDTextField.text;
    req.relation = self.familyRelationTextField.text;
    req.phone  = self.familyPhoneTextField.text;
    
    if (self.rsp.addrId > 0) {
        req.addrId = self.rsp.addrId;
    }else if (self.orderDetailRsp.order.addrId > 0) {
        req.addrId = self.orderDetailRsp.order.addrId;

    }
    
    
    NSString *urlstring = SAASAPPAddInsureOrder;
    APP_COMMAND command = APP_COMMAND_SaasappaddInsureOrder;
    if (self.orderId) {
        
        //带教
        urlstring = SAASAPPAddInsureOrderTeach;
        command = APP_COMMAND_SaasappaddInsureOrderTeach;
    }
    
    [YJYNetworkManager requestWithUrlString:urlstring  message:req controller:self command:command success:^(id response) {
        
        AddInsureOrderRsp *orderRsp = [AddInsureOrderRsp parseFromData:response error:nil];
        
        YJYInsureOrderDetailController *vc = [YJYInsureOrderDetailController instanceWithStoryBoard];
        vc.orderId = orderRsp.orderId;
        vc.insureNo = self.insureNo;
        vc.hasToBackRoot = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat H = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.row >= YJYInsureReviewApplyTypeFamilyService &&
        indexPath.row <= YJYInsureReviewApplyTypeFamilyBlank) {
        
        
        if (self.orderId) {
            H= 0;

        }
        
    }
    
    if (indexPath.row >= YJYInsureReviewApplyTypeReview &&
        indexPath.row <= YJYInsureReviewApplyTypeTeachTitle) {
        
        
        if (!self.orderId) {
            H = 0;
        }
        
    }
    
    return H;
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
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        self.contentVC.orderId =  self.orderId;
        self.contentVC.priceId =  self.priceId;

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];


}
- (IBAction)done:(id)sender {
    
    [self.contentVC done];
}


@end
