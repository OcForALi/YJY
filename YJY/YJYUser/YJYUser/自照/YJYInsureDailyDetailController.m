//
//  YJYInsureDailyDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureDailyDetailController.h"


#define YJYInsureDailyDetailHeaderH 60

@interface YJYInsureDailyDetailHeader : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) NSString *title;
@end

@implementation YJYInsureDailyDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = APPGrayCOLOR;
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-10)];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, 300, 20)];
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.whiteView.center.y);
        
        [self.whiteView addSubview:self.titleLabel];
        [self addSubview:self.whiteView];
        
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
    
}

@end

@interface YJYInsureDailyDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;


@property (strong, nonatomic) InsureTendItemContentVO *insureTendItemContentVO;

@end

@implementation YJYInsureDailyDetailCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setInsureTendItemContentVO:(InsureTendItemContentVO *)insureTendItemContentVO {
    
    _insureTendItemContentVO = insureTendItemContentVO;
    self.serverLabel.text = insureTendItemContentVO.content;
    self.stateLabel.text = insureTendItemContentVO.status == 0 ? @"未完成" : @"已完成";
    
    self.stateImageView.image = [UIImage imageNamed:insureTendItemContentVO.status == 0 ? @"insure_await_icon" : @"insure_finish_icon"];
    
    self.dotView.backgroundColor = insureTendItemContentVO.status == 0 ? APPGrayCOLOR : APPORANGECOLOR;
    
    
    
}
@end

#pragma mark - YJYInsureDailyDetailController

@interface YJYInsureDailyDetailController ()

@property (strong, nonatomic) GetInsureOrderTendItemDetailRsp *rsp;

@end

@implementation YJYInsureDailyDetailController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureOrderHelp" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    /// 服务地点 0-无 1-在家 2-住院
    
    GetInsureOrderTendItemDetailReq *req = [GetInsureOrderTendItemDetailReq new];
    req.orderId = self.orderId;
    req.itemId = self.insureOrderTendItemVO.itemId;
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureOrderTendItemDetail message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderTendItemDetail success:^(id response) {
        
        self.rsp = [GetInsureOrderTendItemDetailRsp parseFromData:response error:nil];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.rsp.itemVoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    InsureOrderTendItemDetailVO *detailVO = self.rsp.itemVoArray[section];
    return detailVO.voArray_Count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YJYInsureDailyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureDailyDetailCell" forIndexPath:indexPath];
    
    InsureOrderTendItemDetailVO *detailVO = self.rsp.itemVoArray[indexPath.section];
    InsureTendItemContentVO *insureTendItemContentVO = detailVO.voArray[indexPath.row];
    
    cell.insureTendItemContentVO = insureTendItemContentVO;
    
    return cell;
    

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YJYInsureDailyDetailHeader *header = [[YJYInsureDailyDetailHeader alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, YJYInsureDailyDetailHeaderH)];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return YJYInsureDailyDetailHeaderH;
}

@end
