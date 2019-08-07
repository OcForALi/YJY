//
//  YJYInsureDailyDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureDailyDetailController.h"


#define YJYInsureDailyDetailHeaderH 50

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
        
        self.backgroundColor = APPSaasF8Color;
        
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, frame.size.height-10)];
        self.whiteView.backgroundColor = APPSaasF8Color;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, 300, 20)];
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.center.y- 5);
        self.titleLabel.textColor = APPNurseGrayCOLOR;
        
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


typedef void (^YJYInsureDailyDetailCellDidDoneBlock)();

@interface YJYInsureDailyDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;


@property (strong, nonatomic) InsureTendItemContentVO *insureTendItemContentVO;
@property (copy, nonatomic) YJYInsureDailyDetailCellDidDoneBlock didDoneBlock;

@property (assign, nonatomic) BOOL toComfire;
@end

@implementation YJYInsureDailyDetailCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setInsureTendItemContentVO:(InsureTendItemContentVO *)insureTendItemContentVO {
    
    _insureTendItemContentVO = insureTendItemContentVO;
    self.serverLabel.text = insureTendItemContentVO.content;
    self.stateLabel.text = insureTendItemContentVO.status == 0 ? @"未完成" : insureTendItemContentVO.finishTimeStr;
    
    self.stateImageView.image = [UIImage imageNamed:insureTendItemContentVO.status == 0 ? @"insure_finished_orange_icon" : @"insure_finished_green_icon"];
    
    self.dotView.backgroundColor = insureTendItemContentVO.status == 0 ? APPORANGECOLOR :APPNurseDarkGrayCOLOR ;
    self.stateLabel.textColor = insureTendItemContentVO.status == 0 ? APPORANGECOLOR : APPHEXCOLOR;
    
    self.serverLabel.textColor = insureTendItemContentVO.status == 0 ? APPNurseDarkGrayCOLOR : APPNurseGrayCOLOR;
    
    
    
}
- (IBAction)toDoAction:(id)sender {
    if (self.toComfire && self.insureTendItemContentVO.status == 0) {
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }
        
    }
   
    
}
@end

#pragma mark - YJYInsureDailyDetailController

typedef void (^YJYInsureDailyDetailContentDidLoad)();


@interface YJYInsureDailyDetailContentController : YJYTableViewController

@property (strong, nonatomic) GetInsureOrderTendItemDetailRsp *rsp;
@property (strong, nonatomic) InsureOrderTendItemVO *insureOrderTendItemVO;
@property (strong, nonatomic) NSString *orderId;
@property (assign, nonatomic) BOOL toComfire;
@property (copy, nonatomic) YJYInsureDailyDetailContentDidLoad didLoad;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//header
@property (weak, nonatomic)IBOutlet UIView *headerView;
@property (weak, nonatomic)IBOutlet UILabel *todayLabel;
@property (weak, nonatomic)IBOutlet UILabel *serviceFinishLabel;

@end

@implementation YJYInsureDailyDetailContentController

+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureDailyList" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    if (!self.toComfire) {
        self.todayLabel.hidden = YES;
        self.imgView.hidden = YES;

        self.headerView.frame =  CGRectMake(0, 0, self.headerView.frame.size.width, 50);
        
    }else {
        self.todayLabel.hidden = NO;
        self.imgView.hidden = NO;
        self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, 200);
        self.todayLabel.text = [NSString stringWithFormat:@"今天是%@",[NSDate getRealDateTime:[NSDate date] withFormat:YYYY_MM_DD]];

    }
    
    
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    /// 服务地点 0-无 1-在家 2-住院
    
    GetInsureOrderTendItemDetailReq *req = [GetInsureOrderTendItemDetailReq new];
    req.orderId = self.orderId;
    req.itemId = self.insureOrderTendItemVO.itemId;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderTendItemDetail  message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderTendItemDetail success:^(id response) {
        
        self.rsp = [GetInsureOrderTendItemDetailRsp parseFromData:response error:nil];
        [self reloadRsp];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
    }];
}
- (void)reloadRsp {
    if (self.toComfire) {
        
        if (self.rsp.status == 1) {
            self.serviceFinishLabel.text = @"今日服务已完成";
        }else {
            
            self.serviceFinishLabel.text = self.rsp.addrStr;
        }
        self.serviceFinishLabel.textColor = APPNurseDarkGrayCOLOR;
        
    }else {
        
    
        self.serviceFinishLabel.text = self.rsp.addrStr;
        self.serviceFinishLabel.textColor = APPHEXCOLOR;

    }
 
    if (self.didLoad) {
        self.didLoad();
    }
    
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
    cell.toComfire = self.toComfire;
    
    cell.insureTendItemContentVO = insureTendItemContentVO;
    cell.didDoneBlock = ^{
        
        if (self.rsp.status == 0) {
            [UIAlertController showAlertInViewController:self withTitle:@"是否确认完成该服务?" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    [self toComfireWith:insureTendItemContentVO status:2];
                }
                
            }];
        }
        
    };
    
    return cell;
    

    
}
- (void)toComfireWith:(InsureTendItemContentVO *)insureTendItemContentVO status:(uint32_t)status{
    
    ConfirmInsureOrderTendItemDetailReq *req = [ConfirmInsureOrderTendItemDetailReq new];
    req.orderId = self.orderId;
    req.itemDetailId = insureTendItemContentVO.orderTendItemDetailId;
    req.itemId = self.rsp.itemId;
    req.status = status;
    

    [YJYNetworkManager requestWithUrlString:SAASAPPConfirmInsureOrderTendItemDetail message:req controller:self command:APP_COMMAND_SaasappconfirmInsureOrderTendItemDetail success:^(id response) {
        
        [self loadNetworkData];
       
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YJYInsureDailyDetailHeader *header = [[YJYInsureDailyDetailHeader alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, YJYInsureDailyDetailHeaderH)];
    
    InsureOrderTendItemDetailVO *detailVO = self.rsp.itemVoArray[section];
    header.title = detailVO.title;
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InsureOrderTendItemDetailVO *detailVO = self.rsp.itemVoArray[indexPath.section];
    InsureTendItemContentVO *insureTendItemContentVO = detailVO.voArray[indexPath.row];
    
    
    CGSize size = [insureTendItemContentVO.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width-34, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    double height = ceil(size.height);
    
    return 65 + (height - 17);

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return YJYInsureDailyDetailHeaderH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.rsp.itemVoArray.count == section + 1) {
        return 50;

    }
    return 10;
}

@end


@interface YJYInsureDailyDetailController ()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) YJYInsureDailyDetailContentController *contentVC;
@end


@implementation YJYInsureDailyDetailController



+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureDailyList" viewControllerIdentifier:className];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self reloadView];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.toComfire) {
        [self navigationBarAlphaWithWhiteTint];
        
    }else {
        [self navigationBarNotAlphaWithBlackTint];

    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self navigationBarNotAlphaWithBlackTint];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"YJYInsureDailyDetailContentController"]) {
        
        self.contentVC = (YJYInsureDailyDetailContentController *)segue.destinationViewController;
        self.contentVC.insureOrderTendItemVO = self.insureOrderTendItemVO;
        self.contentVC.orderId =  self.orderId;
        self.contentVC.toComfire = self.toComfire;
        self.contentVC.didLoad = ^{
            
            [weakSelf reloadView];
        };
    }
    
}
- (void)reloadView {
    
    if ([YJYRoleManager sharedInstance].roleType == YJYRoleTypeWorker) {
        
        self.buttonView.hidden = !self.toComfire;
        if (self.contentVC.rsp.status == 1) {
            self.buttonView.hidden = YES;
        }

    }else {
        
        self.buttonView.hidden = YES;

    }

}

- (IBAction)done:(id)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"当前有未完成的服务，更改之后不可再修改，是否提交？" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [self.contentVC toComfireWith:nil status:1];
        }
        
    }];
}
@end
