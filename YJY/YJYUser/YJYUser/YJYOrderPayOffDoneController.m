//
//  YJYOrderPayOffDoneController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/30.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYOrderPayOffDoneController.h"
#import "YJYWalletController.h"
#import "YJYOrderSettleController.h"

@interface YJYOrderPayOffDoneController ()
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *upCashButton;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailButton;

@end

@implementation YJYOrderPayOffDoneController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPayOffDoneController *)[UIStoryboard storyboardWithName:@"YJYOrderPayOffDone" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.desLabel.text = [NSString stringWithFormat:@"%@元已退至您的账户余额。您可以到【个人中心】的【我的钱包】中申请提现。",@(self.returnNumber)];
    
    self.upCashButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.upCashButton.layer.borderWidth = 1;
    
    self.orderDetailButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.orderDetailButton.layer.borderWidth = 1;
}

- (IBAction)toUpCash:(id)sender {
    YJYWalletController *vc = [YJYWalletController instanceWithStoryBoard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toOrderDetail:(id)sender {
    
    YJYOrderSettleController *vc = [YJYOrderSettleController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.isToRoot = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
