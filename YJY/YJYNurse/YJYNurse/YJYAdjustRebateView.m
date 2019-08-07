//
//  YJYAdjustRebateView.m
//  YJYNurse
//
//  Created by wusonghe on 2017/12/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAdjustRebateView.h"
#import "YJYPayOffComfireAddController.h"

@interface YJYAdjustRebateView()

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *noIcon;
@property (weak, nonatomic) IBOutlet UIImageView *stuffIcon;
@property (weak, nonatomic) IBOutlet UIImageView *stuffFamilyIcon;

@property (weak, nonatomic) IBOutlet UILabel *stuffYouhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *stuffFamilyYouhuiLabel;

@property (strong, nonatomic) NSArray *primeButtonsTag;
@property (assign, nonatomic) YJYPrimeType primeType;
@property (strong, nonatomic) GetPriceListRsp *rsp;

@end

@implementation YJYAdjustRebateView

+ (instancetype)instancetypeWithXIB {
    
    NSArray *a = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    
    return a.firstObject;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.primeButtonsTag = @[@(YJYPrimeTypeNone),@(YJYPrimeTypeEmployeeFamily),@(YJYPrimeTypeEmployee)];
    self.primeType = YJYPrimeTypeNone;
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
//    [self.bgView addGestureRecognizer:tap];
    
  
}
- (void)setOrderId:(NSString *)orderId {
    
    _orderId = orderId;
    [self loadOrderPriceInvert];

}
- (void)loadOrderPriceInvert {
    
    
    GetOrderInfoReq*req = [GetOrderInfoReq new];
    req.orderId = self.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetOrderPriceInvert message:req controller:nil command:APP_COMMAND_SaasappgetOrderPriceInvert success:^(id response) {
        
        self.rsp = [GetPriceListRsp parseFromData:response error:nil];
        [self setupYouhui];
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

- (void)setupYouhui {
    
    BOOL isAm = [[NSDate date] isAmTimeBucketWithDate:[NSDate date]];
    
    self.stuffYouhuiLabel.text = [NSString stringWithFormat:@"可优惠%@元",isAm ? self.rsp.hgRebateFeeAm : self.rsp.hgRebateFeePm];
    self.stuffFamilyYouhuiLabel.text = [NSString stringWithFormat:@"可优惠%@元",isAm ? self.rsp.hgKinsRebateFeeAm : self.rsp.hgKinsRebateFeePm];
}

- (IBAction)primeSelectAction:(UIButton *)sender {
    
    
    for (NSNumber *num in self.primeButtonsTag) {
        
        UIImageView *selectImgView = (UIImageView *)[self viewWithTag:[num integerValue] * 10];
        [selectImgView setImage:[UIImage imageNamed:@"app_unselect_icon"]];
        
        
    }
    
    self.primeType = sender.tag;
    UIImageView *selectImgView = (UIImageView *)[sender.superview viewWithTag:sender.tag  * 10];
    [selectImgView setImage:[UIImage imageNamed:@"app_select_icon"]];
    
}

- (IBAction)comfireAction:(id)sender {
    
    

    
    AddOrderPriceReviseReq *req = [AddOrderPriceReviseReq new];
    req.hgRebateType = self.primeType - 4;
    req.orderId = self.orderId;
    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateOrderRebate message:req controller:nil command:APP_COMMAND_SaasappupdateOrderRebate success:^(id response) {
        
        if (self.didComfireBlock) {
            self.didComfireBlock();
        }
        [self hidden];

        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    [self hidden];

}

#pragma mark - show & hide
#define kActionViewHeight 220
- (void)showInView:(UIView *)view {
    
    if ([view.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    self.backgroundColor = kColorAlpha(0, 0, 0, 0.5);
    self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        self.actionView.transform = CGAffineTransformMakeTranslation(0, kActionViewHeight);
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}


@end
