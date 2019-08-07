//
//  YJYInsureApplyDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureReApplyDetailController.h"

typedef NS_ENUM(NSInteger,YJYInsureApplyDetailType) {
    
    YJYInsureApplyDetailTypeBasic,
    YJYInsureApplyDetailTypeBasicName,
    YJYInsureApplyDetailTypeBasicPeople,

    
    YJYInsureApplyDetailTypeQualificationTitle,
    YJYInsureApplyDetailTypeQualificationDate,
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
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet UILabel *insureQualificationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleDisableLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *insureDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureSickDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *insureMarkLabel;

@property (strong, nonatomic) GetKinsInsureRsp *rsp;

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
    
    GetKinsInsureReq *req = [GetKinsInsureReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.hgnoName = self.orderDetailRsp.order.hgName;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetKinsInsure message:req controller:self command:APP_COMMAND_SaasappgetKinsInsure success:^(id response) {
        
        self.rsp = [GetKinsInsureRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    [self reloadAllData];
    
    self.joinPeopleLabel.text = [NSString stringWithFormat:@"%@",self.rsp.kinsName];
    self.sexLabel.text = self.rsp.sex == 1 ? @"男" :@"女";
    self.ageLabel.text = [NSString stringWithFormat:@"%@",@(self.rsp.age)];
    if (self.rsp.staffType == 0) {
        self.typeLabel.text = @"无";
    }else {
        self.typeLabel.text = self.rsp.staffType == 1 ? @"在职" : @"退休";

    }
    
    
    self.insureQualificationTimeLabel.text = [NSString stringWithFormat:@"%@至%@",self.rsp.startTimeStr,self.rsp.endTimeStr];
    self.insureScoreLabel.text = [NSString stringWithFormat:@"%@分",@(self.rsp.scoreAdl)];
    self.middleDisableLabel.text = self.rsp.isAmentia == 0 ? @"否" : @"是";
    self.insureDescLabel.text = self.rsp.medicalHistory;
    self.insureSickDescLabel.text = self.rsp.hsCasePresentation;
    self.insureMarkLabel.text = self.rsp.hsRemark;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}



@end
