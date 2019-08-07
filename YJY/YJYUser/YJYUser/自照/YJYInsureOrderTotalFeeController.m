//
//  YJYInsureOtherFeeController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderTotalFeeController.h"

@interface YJYInsureOrderTotalFeeController ()

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnReasonLabel;

@end

@implementation YJYInsureOrderTotalFeeController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderFee" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
