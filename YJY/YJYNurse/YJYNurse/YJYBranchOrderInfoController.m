//
//  YJYBranchOrderInfoController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/29.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYBranchOrderInfoController.h"
#import "YJYPaymentAdjustController.h"
@interface YJYBranchOrderInfoContentController : YJYTableViewController


/// data
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) uint64_t branchId;
@property(nonatomic, readwrite) uint64_t priceId;
@property (strong, nonatomic) ConfirmNewOrderRsp *confirmNewOrderRsp;

@property (copy, nonatomic) YJYBranchOrderInfoDidDoneBlock didDoneBlock;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *contactLabel;

@property (weak, nonatomic) IBOutlet UILabel *hosiptalLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;


@end

@implementation YJYBranchOrderInfoContentController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    [self loadNetworkData];
}
- (void)loadNetworkData {
    
    
    ConfirmNewOrderReq *req = [ConfirmNewOrderReq new];
    req.orderId = self.orderId;
    req.branchId = self.branchId;
    req.priceId = self.priceId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPConfirmNewOrder message:req controller:self command:APP_COMMAND_SaasappconfirmNewOrder success:^(id response) {
        
        ConfirmNewOrderRsp *rsp = [ConfirmNewOrderRsp parseFromData:response error:nil];
        
        self.nameLabel.text = rsp.kinsName;
        self.numberLabel.text = rsp.orgNo;
        self.contactLabel.htmlText = [NSString yjy_PhoneNumberStringWithOrigin:rsp.contactPhone];
        
        self.hosiptalLabel.text = rsp.orgName;
        self.sectionLabel.text = rsp.branchName;
        self.serviceLabel.text = rsp.serviceItem;
        
        self.confirmNewOrderRsp = rsp;
        
    } failure:^(NSError *error) {
        
    }];
}




- (void)done {
    
    [UIAlertController showAlertInViewController:self withTitle:@"请确认转科，并确定原订单费用！" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            
            
            
            CreateOrderReq *req = [CreateOrderReq new];
            req.orderId = self.orderId;
            req.branchId = self.branchId;
            req.priceId = self.priceId;
            req.userId = self.confirmNewOrderRsp.userId;
            
            
            [YJYNetworkManager requestWithUrlString:SAASAPPCreateOrder message:req controller:self command:APP_COMMAND_SaasappcreateOrder success:^(id response) {
                
                YJYPaymentAdjustController *vc = [YJYPaymentAdjustController instanceWithStoryBoard];
                vc.orderId = self.orderId;
                vc.jumpType = YJYOrderPaymentAdjustTypeAdjustSection;
                [self.navigationController pushViewController:vc animated:YES];
                
                [SYProgressHUD showSuccessText:@"创建成功"];
                
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }];
    

    
    
    
   
}

@end


@interface YJYBranchOrderInfoController ()
@property (strong, nonatomic) YJYBranchOrderInfoContentController *contentVC;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@end

@implementation YJYBranchOrderInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (instancetype)instanceWithStoryBoard {
    
    return (YJYBranchOrderInfoController *)[UIStoryboard storyboardWithName:@"YJYBranchNewService" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYBranchOrderInfoContentController"]) {
        
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderId = self.orderId;
        self.contentVC.branchId = self.branchId;
        self.contentVC.priceId = self.priceId;
        
        
        
        
    }
}

- (IBAction)done:(id)sender {
    if (!self.switchButton.selected) {
        [SYProgressHUD showInfoText:@"请勾选用户知情书"];
        return;
    }
    [self.contentVC done];
}

- (IBAction)toUserKnow:(id)sender {
    
    if (!self.priceId) {
        [SYProgressHUD showInfoText:@"请选择服务"];
        return;
    }
    if (!self.branchId) {
        [SYProgressHUD showInfoText:@"请选择科室"];
        return;
    }
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?priceId=%@&branchId=%@",kUserKnowing,@(self.priceId),@(self.branchId)];
    vc.urlString = url;
    vc.title = @"用户知情书";

    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toSwitch:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
