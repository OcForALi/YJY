//
//  YJYInsureBackVisitController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureBackVisitController.h"
#import <XLPhotoBrowser+CoderXL/XLPhotoBrowser.h>


typedef NS_ENUM(NSInteger, YJYInsureBackVisitType) {
    
    YJYInsureBackVisitTypeTrainContent = 11,
    
};

@interface YJYInsureBackVisitController ()


@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *backVisitTextView;
@property (weak, nonatomic) IBOutlet UITextView *careProblemTextView;
@property (weak, nonatomic) IBOutlet UITextView *careMethodTextView;



@property (weak, nonatomic) IBOutlet UILabel *trainWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainContentLabel;


@property (strong, nonatomic) GetInsureOrderVisitDetailRsp *rsp;


@end

@implementation YJYInsureBackVisitController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureBackVisit" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    DeleteInsureOrderVisitReq *req = [DeleteInsureOrderVisitReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.visitId = self.insureOrderVisitVO.visitId;
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureOrderVisitDetail message:req controller:self command:APP_COMMAND_AppgetReckonSubsidy success:^(id response) {
        
        self.rsp = [GetInsureOrderVisitDetailRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    InsureOrderVisit *visit = self.rsp.visit;
    self.startTimeLabel.text = self.rsp.visitTimeStr;
    self.endTimeLabel.text = self.rsp.visitEndTimeStr;
    
    self.backVisitTextView.text = visit.visitDetial;
    self.careProblemTextView.text = visit.visitProblem;
    self.careMethodTextView.text = visit.visitMeasures;

    self.trainContentLabel.text = [visit.visitSkillTrainingArray componentsJoinedByString:@","];
    self.trainWayLabel.text = visit.visitTrainingType;
    self.masterLabel.text = visit.visitSkillStatus == 0 ? @"未掌握": @"掌握";
    
    [self reloadAllData];
}

- (IBAction)toLifeAction:(id)sender {
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&visitId=%@",kInsurelifesign,self.orderDetailRsp.order.orderId,@(self.insureOrderVisitVO.visitId)];
    vc.urlString = url;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (IBAction)toCheckControlAction:(id)sender {
    
    YJYWebController *vc = [[YJYWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&visitId=%@",kInsureqccontent,self.orderDetailRsp.order.orderId,@(self.insureOrderVisitVO.visitId)];
    vc.urlString = url;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)toFamilySignAction:(id)sender {
    
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.relationImgURL] currentImageIndex:0];

    
}

- (IBAction)toHLSignAction:(id)sender {
    
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.rsp.hgImgURL] currentImageIndex:0];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == YJYInsureBackVisitTypeTrainContent) {
        
        
        CGSize size = [self.trainContentLabel.text boundingRectWithSize:CGSizeMake(self.trainContentLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.trainContentLabel.font} context:nil].size;
        double height = ceil(size.height);
        
        return 70 - 17 + height;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}
@end
