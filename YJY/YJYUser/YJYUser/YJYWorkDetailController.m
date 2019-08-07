//
//  YJYWorkDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/26.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYWorkDetailController.h"
#import "YJYImageShowController.h"
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>

@interface YJYWorkDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UIView *starView;

//info
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexAgeBelongLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverDesLabel;

//order info
@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *hosiptalLabel;


//benefit
@property (weak, nonatomic) IBOutlet UILabel *benefitLabel;

//cert
@property (weak, nonatomic) IBOutlet UIButton *certifiedCert;
@property (weak, nonatomic) IBOutlet UIButton *nurseCert;


//data

@property (strong, nonatomic) GetHGInfoByOrderRsp *rsp;

@end

@implementation YJYWorkDetailController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYWorkDetailController *)[UIStoryboard storyboardWithName:@"YJYWorkDetail" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetworkData];

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
    
    [SYProgressHUD show];
    
    GetHGInfoByOrderReq *req = [GetHGInfoByOrderReq new];
    req.orderId = self.orderId;
    req.hgType = self.hgType;
    
    [YJYNetworkManager requestWithUrlString:APPGetHGInfoByOrder message:req controller:self command:APP_COMMAND_AppgetHginfoByOrder success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp = [GetHGInfoByOrderRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)reloadRsp {
    
    
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:self.rsp.hgInfo.headImg] placeholderImage:nil];
    self.nameLabel.text = self.rsp.hgInfo.hgName;
    
    NSString *sex = self.rsp.hgInfo.sex == 1 ? @"男" : @"女";
    NSString *age = [NSString stringWithFormat:@"%@岁",@(self.rsp.hgInfo.age)];
    self.sexAgeBelongLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",sex,age,self.rsp.hgInfo.nativeplace];
    NSString *serviceDes = [NSString stringWithFormat:@"用心服务过%@个家庭",@(self.rsp.hgInfo.serviceNum)];
    self.serverDesLabel.text = serviceDes;
    
    
    self.supplierLabel.text = self.rsp.hgInfo.companyName;
    self.orderIdLabel.text = self.rsp.hgInfo.hgNo;
    self.jobAgeLabel.text = [NSString stringWithFormat:@"%@年",@(self.rsp.hgInfo.exp)];
    
    self.languageLabel.text = self.rsp.hgInfo.language;
    self.hosiptalLabel.text = self.rsp.hgInfo.serviceOrg;
    
    self.benefitLabel.text = self.rsp.hgInfo.goodAtProject;
}
- (IBAction)zhiyeCertCheckAction:(id)sender {
    
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.hgInfo.healthCertificate] currentImageIndex:0];

}

- (IBAction)nurseCertCheckAction:(id)sender {

    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.hgInfo.nursingCertificate] currentImageIndex:0];

}

@end
