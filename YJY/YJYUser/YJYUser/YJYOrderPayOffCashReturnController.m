//
//  YJYOrderPayOffCashReturnController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/30.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYOrderPayOffCashReturnController.h"
#import "YJYOrderSettleController.h"
@interface YJYOrderPayOffCashReturnController ()
@property (weak, nonatomic) IBOutlet UIButton *orderDetailButton;

@end

@implementation YJYOrderPayOffCashReturnController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYOrderPayOffCashReturnController *)[UIStoryboard storyboardWithName:@"YJYOrderPayOffDone" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.orderDetailButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.orderDetailButton.layer.borderWidth = 1;
}



- (IBAction)toOrderDetail:(id)sender {
    
    YJYOrderSettleController *vc = [YJYOrderSettleController instanceWithStoryBoard];
    vc.orderId = self.orderId;
    vc.isToRoot = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
