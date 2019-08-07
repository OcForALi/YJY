//
//  YJYInsureOrderFamilyController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/8.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderFamilyController.h"

@interface YJYInsureOrderFamilyController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexAgePhoneLabel;


//order

@property (weak, nonatomic) IBOutlet UILabel *qualificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverOrderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;


@property (strong, nonatomic) GetHgAppRsp *rsp;

@end

@implementation YJYInsureOrderFamilyController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderFamily" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"陪护家属";
    self.isLayout = YES;
    [self loadNetworkData];
    


    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_white_icon" highImage:@"back_white_icon" target:self action:@selector(dismiss)];
}

- (void)dismiss {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self navigationBarAlphaWithWhiteTint];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self navigationBarNotAlphaWithBlackTint];
}

- (void)loadNetworkData {
    
    
    
    GetKinsInsureReq *req = [GetKinsInsureReq new];
    req.hgnoName = self.orderDetailRsp.order.fullName;
    req.orderId = self.orderDetailRsp.order.orderId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHgApply message:req controller:self command:APP_COMMAND_SaasappgetHgApply success:^(id response) {
        
        self.rsp = [GetHgAppRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)reloadRsp {
    
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.rsp.hgApply.hgName];
    
    self.sexAgePhoneLabel.text = [NSString stringWithFormat:@"%@ | %@岁 | %@",self.rsp.hgApply.sex == 1 ? @"男" :@"女",@(self.rsp.hgApply.age),self.rsp.hgApply.phone];
    
    ///// 获取资质状态 0-未获得 1-已获得
    
    self.qualificationLabel.text = [NSString stringWithFormat:@"%@",self.rsp.hgApply.status == 0 ? @"未获得" : @"已获得"];
    self.getTimeLabel.text = self.rsp.sendTimeStr;
    self.serverOrderNumberLabel.text = [NSString stringWithFormat:@"%@单",@(self.rsp.orderNumber)];
    self.idCardLabel.text = self.rsp.hgApply.idcard;
}


@end
