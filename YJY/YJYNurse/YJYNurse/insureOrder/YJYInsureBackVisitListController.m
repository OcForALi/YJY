//
//  YJYInsureBackVisitListController.m
//  YJYUser
//
//  Created by wusonghe on 2018/3/5.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureBackVisitListController.h"
#import "YJYInsureBackVisitController.h"
#import "YJYInsureAddVisitBackController.h"
typedef void(^YJYInsureBackVisitListCellDidDeleteBlock)();

@interface YJYInsureBackVisitListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *visitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateIconLabel;
@property (weak, nonatomic) IBOutlet UIView *stateLineView;

@property (strong, nonatomic) InsureOrderVisitVO *insureOrderVisitVO;
@property (copy, nonatomic) YJYInsureBackVisitListCellDidDeleteBlock didDeleteBlock;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tailConstraint;
@end

@implementation YJYInsureBackVisitListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

}
- (void)setInsureOrderVisitVO:(InsureOrderVisitVO *)insureOrderVisitVO {
    
    _insureOrderVisitVO = insureOrderVisitVO;
    self.visitTimeLabel.text = [NSString stringWithFormat:@"回访时间：%@",insureOrderVisitVO.visitTimeStr];
    self.stateLabel.text = insureOrderVisitVO.statusStr;
    self.stateLabel.textColor = (insureOrderVisitVO.status != 0) ? APPHEXCOLOR : APPORANGECOLOR;
    
    //icon
    self.stateLineView.hidden = (insureOrderVisitVO.status != 0);
    self.stateIconImageView.hidden = (insureOrderVisitVO.status != 0);
    self.stateIconLabel.hidden = (insureOrderVisitVO.status != 0);

//    self.accessoryType == (insureOrderVisitVO.status == -1) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    
    self.tailConstraint.constant = (insureOrderVisitVO.status != 0) ? 0 : 80;
    
    self.deleteButton.hidden = self.insureOrderVisitVO.status != 0;
    

}
- (IBAction)toDelete:(UIButton *)sender {

    if ((self.insureOrderVisitVO.status == 0)) {
        
        if (self.didDeleteBlock) {
            self.didDeleteBlock();
        }
    }

}

@end

@interface YJYInsureBackVisitListContentController : YJYTableViewController

@property (strong, nonatomic) GetInsureOrderVisitListRsp *rsp;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
/// 状态 0-全部，1-历史记录
@property(nonatomic, readwrite) uint32_t status;
@end

@implementation YJYInsureBackVisitListContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    GetInsureOrderVisitListReq *req = [GetInsureOrderVisitListReq new];
    req.orderId = self.orderDetailRsp.order.orderId;
    req.status = self.status;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetInsureOrderVisitList message:req controller:self command:APP_COMMAND_SaasappgetInsureOrderVisitList success:^(id response) {
        
        self.rsp = [GetInsureOrderVisitListRsp parseFromData:response error:nil];
        [self reloadRsp];
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
    }];
}

- (void)reloadRsp {
    
    [self reloadAllData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYInsureBackVisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureBackVisitListCell" forIndexPath:indexPath];
    
    InsureOrderVisitVO *insureOrderVisitVO = self.rsp.visitVoArray[indexPath.row];
    cell.insureOrderVisitVO = insureOrderVisitVO;
    cell.didDeleteBlock = ^{
        
        [self toDeleteWithInsureOrderVisitVO:insureOrderVisitVO];

        
        
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InsureOrderVisitVO *insureOrderVisitVO = self.rsp.visitVoArray[indexPath.row];
    YJYInsureBackVisitController *vc =[YJYInsureBackVisitController instanceWithStoryBoard];
    vc.insureOrderVisitVO = insureOrderVisitVO;
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.didDoneBlock = ^{
        [self loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rsp.visitVoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark - Action

- (IBAction)toEditAction:(InsureOrderVisitVO *)insureOrderVisitVO {
    
    YJYInsureAddVisitBackController *vc = [YJYInsureAddVisitBackController instanceWithStoryBoard];
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.insureOrderVisitVO = insureOrderVisitVO;
    vc.didDoneBlock = ^{
        [self loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toDeleteWithInsureOrderVisitVO:(InsureOrderVisitVO *)insureOrderVisitVO {
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否删除回访记录" message:nil alertControllerStyle:1 cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [SYProgressHUD show];
            DeleteInsureOrderVisitReq *req = [DeleteInsureOrderVisitReq new];
            req.orderId = self.orderDetailRsp.order.orderId;
            req.visitId = insureOrderVisitVO.visitId;
            
            [YJYNetworkManager requestWithUrlString:SAASAPPDeleteInsureOrderVisit message:req controller:self command:APP_COMMAND_SaasappdeleteInsureOrderVisit success:^(id response) {
                
                [SYProgressHUD hide];
                [self loadNetworkData];

                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
    }];
    
   
    
}

@end
@interface YJYInsureBackVisitListController ()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) YJYInsureBackVisitListContentController *contentVC;
@end


@implementation YJYInsureBackVisitListController



+ (instancetype)instanceWithStoryBoard {
    
    NSString *className = NSStringFromClass([self class]);
    id vc = [UIStoryboard storyboardWithName:@"YJYInsureBackVisitList" viewControllerIdentifier:className];
    return vc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureBackVisitListContentController"]) {
        
        self.contentVC = (YJYInsureBackVisitListContentController *)segue.destinationViewController;
        self.contentVC.status = self.status;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        
        self.buttonView.hidden = [YJYRoleManager sharedInstance].roleType != YJYRoleTypeNurse;
        
    }
    
}

- (IBAction)toAddAction:(id)sender {
    
    YJYInsureAddVisitBackController *vc = [YJYInsureAddVisitBackController instanceWithStoryBoard];
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.didDoneBlock = ^{
        [self.contentVC loadNetworkData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end




