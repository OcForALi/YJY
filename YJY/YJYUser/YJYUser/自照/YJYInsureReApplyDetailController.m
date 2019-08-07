//
//  YJYInsureApplyDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureReApplyDetailController.h"

typedef NS_ENUM(NSInteger,YJYInsureApplyDetailType) {
    
    YJYInsureApplyDetailTypeJoin,
    
    YJYInsureApplyDetailTypeQualificationTitle,
    YJYInsureApplyDetailTypeQualification,
    
    YJYInsureApplyDetailTypeADLTitle,
    YJYInsureApplyDetailTypeADL,
    
    YJYInsureApplyDetailTypeMiddleTitle,
    YJYInsureApplyDetailTypeMiddle,
    
    YJYInsureApplyDetailTypeReviewDescTitle,
    YJYInsureApplyDetailTypeReviewDesc,
    
    YJYInsureApplyDetailTypeSickDescTitle,
    YJYInsureApplyDetailTypeSickDesc,
    
    YJYInsureApplyDetailTypeMarkDescTitle,
    YJYInsureApplyDetailTypeMarkDesc,
};

@interface YJYInsureReApplyDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *joinPeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureQualificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleDisableLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *insureDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureSickDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureMarkLabel;

@property (strong, nonatomic) GetInsureRsp *rsp;

@end

@implementation YJYInsureReApplyDetailController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureReApplyDetail" viewControllerIdentifier:className];
    return vc;
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetInsureReq *req = [GetInsureReq new];
    req.insureNo = self.orderDetailRsp.order.insureNo;
    req.assessType = 1;
    
    [YJYNetworkManager requestWithUrlString:GetInsureDetail message:req controller:self command:APP_COMMAND_GetInsureDetail success:^(id response) {
        
        self.rsp = [GetInsureRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    [self reloadAllData];
    
    self.joinPeopleLabel.text = [NSString stringWithFormat:@"参保人：%@",self.rsp.kinsName];
    self.insureQualificationLabel.text = self.rsp.aptitudeTime;
    self.insureScoreLabel.text = [NSString stringWithFormat:@"%@分",@(self.rsp.score)];
    self.middleDisableLabel.text = self.rsp.isAmentia == 0 ? @"否" : @"是";
    self.insureDescLabel.text = self.rsp.medicalHistory;
    self.insureSickDescLabel.text = self.rsp.hsCasePresentation;
    self.insureMarkLabel.text = self.rsp.hsRemark;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}



@end
