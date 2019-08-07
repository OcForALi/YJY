//
//  YJYInsureContinuelFeeController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureContinuelFeeController.h"


@interface YJYInsureContinuelFeeContentController : YJYTableViewController


@property (weak, nonatomic) IBOutlet UILabel *serveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *servePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *continuelTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (strong, nonatomic) GetHomeOrderDetailRsp *orderDetailRsp;

@end

@implementation YJYInsureContinuelFeeContentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.serveTypeLabel.text = orderDetailRsp.t
}

@end

@interface YJYInsureContinuelFeeController ()
@property (weak, nonatomic) IBOutlet UIView *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic) YJYInsureContinuelFeeContentController *contentVC;

@end

@implementation YJYInsureContinuelFeeController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderFee" viewControllerIdentifier:className];
    return vc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"YJYInsureContinuelFeeContentController"]) {
        self.contentVC = (YJYInsureContinuelFeeContentController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
