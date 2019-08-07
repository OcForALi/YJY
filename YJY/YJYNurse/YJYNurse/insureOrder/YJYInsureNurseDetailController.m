//
//  YJYInsureNurseDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/26.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureNurseDetailController.h"
#import "YJYImageShowController.h"
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>
#import "RateStarView.h"

@interface YJYInsureNurseDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (strong, nonatomic)IBOutlet  UIView *starContainView;
@property (strong, nonatomic)  RateStarView *starView;

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

@implementation YJYInsureNurseDetailController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureNurseDetailController *)[UIStoryboard storyboardWithName:@"YJYInsureNurseDetail" viewControllerIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.conditionLabel.layer.cornerRadius = 10;
    self.conditionLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.conditionLabel.layer.borderWidth = 1;
    
    
    self.avatorImageView.layer.cornerRadius = 40;
    self.avatorImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatorImageView.layer.borderWidth = 5;
    
    [self loadNetworkData];
    [self setupStarView];
    
    
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

- (void)setupStarView {
    
    self.starContainView.backgroundColor = [UIColor clearColor];
    self.starView = [[RateStarView alloc] initWithNormalImage:[UIImage imageNamed:@"insure_star_unpressed_icon"] selectedImage:[UIImage imageNamed:@"insure_star_pressed_icon"] padding:5];
    self.starView.frame = self.starContainView.bounds;
    [self.starContainView addSubview:self.starView];
    self.starView.userInteractionEnabled = NO;
}

- (void)loadNetworkData {
    
    [SYProgressHUD show];
    
    GetHGInfoByOrderReq *req = [GetHGInfoByOrderReq new];
    req.orderId = self.orderId;
    req.hgType = self.hgType;
    req.hgId  = self.hgId;
    [YJYNetworkManager requestWithUrlString:SAASAPPGetHGInfoByOrder message:req controller:self command:APP_COMMAND_SaasappgetHginfoByOrder success:^(id response) {
        
        [SYProgressHUD hide];
        self.rsp = [GetHGInfoByOrderRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)reloadRsp {
    
    
    [self.avatorImageView xh_setImageWithURL:[NSURL URLWithString:self.rsp.hgInfo.headImg] placeholderImage:nil];
    self.nameLabel.text = self.rsp.hgInfo.hgName;
    
    NSString *sex = self.rsp.hgInfo.sex == 1 ? @"男" : @"女";
    NSString *age = [NSString stringWithFormat:@"%@岁",@(self.rsp.hgInfo.age)];
    self.sexAgeBelongLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",sex,age,self.rsp.hgInfo.nativeplace];
    NSString *serviceDes = [NSString stringWithFormat:@"用心服务过%@个家庭",@(self.rsp.hgInfo.serviceNum)];
    self.serverDesLabel.text = serviceDes;
    
    
    self.supplierLabel.text = self.rsp.hgInfo.companyName.length > 0 ? self.rsp.hgInfo.companyName : @"无";
    self.orderIdLabel.text = self.rsp.hgInfo.hgNo.length > 0 ?self.rsp.hgInfo.hgNo : @"无";
    self.jobAgeLabel.text = [NSString stringWithFormat:@"%@年",@(self.rsp.hgInfo.exp)];
    
    self.languageLabel.text = self.rsp.hgInfo.language.length > 0 ? self.rsp.hgInfo.language : @"无";;
    self.hosiptalLabel.text = self.rsp.hgInfo.serviceOrg.length > 0 ? self.rsp.hgInfo.serviceOrg : @"无";
    
    self.benefitLabel.text = self.rsp.hgInfo.goodAtProject;
    
    self.starView.score = 5;

}
- (IBAction)zhiyeCertCheckAction:(id)sender {
    
    
    
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.hgInfo.healthCertificate] currentImageIndex:0];

}

- (IBAction)nurseCertCheckAction:(id)sender {

    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.hgInfo.nursingCertificate] currentImageIndex:0];

}

@end
