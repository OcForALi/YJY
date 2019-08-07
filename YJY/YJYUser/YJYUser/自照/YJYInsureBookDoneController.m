//
//  YJYInsureDoneController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/8.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureBookDoneController.h"

@interface YJYInsureBookDoneController ()
@property (weak, nonatomic) IBOutlet UILabel *serviceItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceInfoLabel;

@end

@implementation YJYInsureBookDoneController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureBookDoneController *)[UIStoryboard storyboardWithName:@"YJYInsureBookDone" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(dismiss)];
    
    
    
}

- (void)dismiss {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setRsp:(AddInsureOrderRsp *)rsp {
    
    _rsp = rsp;
    self.serviceItemLabel.text = rsp.serviceItem;
    self.servicePriceLabel.text = rsp.notice;
    self.orderTimeLabel.text = rsp.notice;
    self.serviceInfoLabel.text = rsp.addrDetail;

}
- (IBAction)done:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
