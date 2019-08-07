//
//  YJYInsureChooseServiceController.m
//  YJYUser
//
//  Created by wusonghe on 2018/2/7.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureChooseServiceController.h"
#import "YJYInsureReviewApplyController.h"

@interface YJYInsureChooseServiceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) InsurePriceVO *insurePriceVO;

@end

@implementation YJYInsureChooseServiceCell


- (void)setInsurePriceVO:(InsurePriceVO *)insurePriceVO {
    
    _insurePriceVO = insurePriceVO;
    self.titleLabel.text = insurePriceVO.serviceItem;
    self.desLabel.text = insurePriceVO.serviceIntro;
    self.priceLabel.text = insurePriceVO.priceDesc;
    
    //serviceType 182
}

@end


@interface YJYInsureChooseServiceController ()

@property (strong, nonatomic)  GetInsurePriceListRsp *rsp;

@end

@implementation YJYInsureChooseServiceController


+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureChooseService" viewControllerIdentifier:className];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetworkData];

}

- (void)loadNetworkData {
    
    GetInsurePriceListReq *req = [GetInsurePriceListReq new];
    req.insureNo = self.insureNo;
    if (self.serviceType) {
        req.serviceType = self.serviceType;

    }
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsurePriceList message:req controller:self command:APP_COMMAND_SaasappgetInsurePriceList success:^(id response) {
        
        self.rsp = [GetInsurePriceListRsp parseFromData:response error:nil];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.rsp.priceListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJYInsureChooseServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureChooseServiceCell" forIndexPath:indexPath];
    cell.insurePriceVO = self.rsp.priceListArray[indexPath.row];
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsurePriceVO *insurePriceVO = self.rsp.priceListArray[indexPath.row];
    CGFloat cellH  = 110;
    CGFloat detalH = insurePriceVO.priceDesc.length == 0 ? - 21 : 0;
    CGFloat secondH = insurePriceVO.serviceIntro.length == 0 ? -21 :0;
    
    CGFloat addressWidth = self.tableView.frame.size.width - (17 + 17);
    CGFloat markExtraHeight = [insurePriceVO.serviceIntro boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height - 21;
    
    return cellH + secondH + detalH + markExtraHeight;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsurePriceVO *insurePriceVO = self.rsp.priceListArray[indexPath.row];

    YJYInsureReviewApplyController *vc = [YJYInsureReviewApplyController instanceWithStoryBoard];
    vc.insureNo = self.insureNo;
    vc.insurePriceVO = insurePriceVO;
    vc.orderId = self.orderId;
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
