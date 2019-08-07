//
//  YJYOrderRefundController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/11/1.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderRefundController.h"

@interface YJYOrderRefundContentController :YJYTableViewController


@property (strong, nonatomic) OrderVO *orderVo;
@property (assign, nonatomic) BOOL isDudao;
@property (copy, nonatomic) YJYOrderRefundDidDoneBlock didDoneBlock;


@property (weak, nonatomic) IBOutlet UILabel *prePaidLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorbanLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseRefundWayButton;

@property (strong, nonatomic)  GetOrderInfoRsp *orderInfoRsp;



@end

@implementation YJYOrderRefundContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self reloadOrder];

    
    
}

- (void)reloadOrder {
    
    self.prePaidLabel.text = [NSString stringWithFormat:@"预付款：%@元",self.orderVo.preRealFee];
    self.doorbanLabel.text = [NSString stringWithFormat:@"门禁卡押金：%@元",self.orderVo.extraFee.length > 0 ? self.orderVo.extraFee : @"0.00"];

}

- (IBAction)toChooseRefundAction:(id)sender {
    
    
   
    
}
- (void)toReturnDudao {
    
    [UIAlertController showAlertInViewController:self withTitle:nil message:nil alertControllerStyle:0 cancelButtonTitle:@"取消" destructiveButtonTitle:@"退款至账户余额" otherButtonTitles:@[@"现金退款"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        
        
        if (buttonIndex == 1) {
            
            [self toRefundToYuE];
            

        }else if (buttonIndex == 2) {
            
            [self toRefundToCash];
            
        }
        
    }];
    
}


- (IBAction)done:(id)sender {

    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeSupervisor) {
        
        if (self.orderInfoRsp.returnType == 2) {
            
            [self toRefundToYuE];

            
        }else {
            [self toReturnDudao];
            
        }
    }
  
}
- (void)toRefundToYuE {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否确定结算？（退款将在3-5个工作日内原路退回支付账户）" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self toRefundWithRefundPayType:53];
            
        }
        
    }];
    
}
- (void)toRefundToCash {
    
    
    if (!self.isDudao) {
        [UIAlertController showAlertInViewController:self withTitle:@"请提示用户到收费处进行结算！" message:nil alertControllerStyle:1 cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        
    }else {
        NSString *title = [NSString stringWithFormat:@"是否确定退现金%@元",self.orderInfoRsp.returnFeeStr];
    
        [UIAlertController showAlertInViewController:self withTitle:title message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self toRefundWithRefundPayType:72];
                
            }
            
        }];
        
    }
}

- (void)toRefundWithRefundPayType:(uint32_t)refundPayType {
    
    RefundOrderReq *req = [RefundOrderReq new];
    req.orderId = self.orderVo.orderId;
    req.refundPayType = refundPayType;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPRefundOrder message:req controller:self command:APP_COMMAND_SaasapprefundOrder success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"退款成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didDoneBlock) {
                self.didDoneBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        
        if (!self.orderInfoRsp.canRefundExtraFee) {
            return 0;
        }
        
        return [self.orderVo.extraFee floatValue] > 0 ? 50 : 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

@end

@interface YJYOrderRefundController ()

@property (strong, nonatomic) YJYOrderRefundContentController *contentVC;


@end

@implementation YJYOrderRefundController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderRefundController *)[UIStoryboard storyboardWithName:@"YJYOrderRefund" viewControllerIdentifier:NSStringFromClass([self class])];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"YJYOrderRefundContentController"]) {
        self.contentVC = segue.destinationViewController;
        self.contentVC.orderVo = self.orderVo;
        self.contentVC.isDudao = self.isDudao;
        self.contentVC.orderInfoRsp = self.orderInfoRsp;
        self.contentVC.didDoneBlock = ^{
            if (weakSelf.didDoneBlock) {
                weakSelf.didDoneBlock();
            }
            
        };
      
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)done:(id)sender {
    [self.contentVC done:nil];
}



@end
