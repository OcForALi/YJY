//
//  YJYInsureOrderRelationController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderRelationController.h"

@interface YJYInsureOrderRelationContentController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *relationLabel;
@property (weak, nonatomic) IBOutlet UITextField *idcardLabel;
@property (weak, nonatomic) IBOutlet UITextField *getTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (copy, nonatomic) YJYInsureOrderRelationDidDoneBlock didDoneBlock;

@end

@implementation YJYInsureOrderRelationContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.phoneLabel addTarget:self action:@selector(toGetHGIdcardByPhone:) forControlEvents:UIControlEventEditingDidEnd];

}

- (IBAction)done:(id)sender {
    
    [SYProgressHUD show];
    
    SaveOrUpdateInsureOrderRelationReq *req = [SaveOrUpdateInsureOrderRelationReq new];
    req.relation = self.relationLabel.text;
    req.orderId = self.orderDetailRsp.order.orderId;
    req.phone = self.phoneLabel.text;
    req.name = self.nameLabel.text;
    req.idcard = self.idcardLabel.text;
    req.sendDate = self.getTimeLabel.text;

    
    [YJYNetworkManager requestWithUrlString:SAASAPPSaveOrUpdateInsureOrderRelation message:req controller:self command:APP_COMMAND_SaasappsaveOrUpdateInsureOrderRelation success:^(id response) {
        
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }
        [SYProgressHUD showSuccessText:@"修改成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];

        });
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)toTime:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"时间选择" delegate:nil];
    
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    picker.actionSheetPickerStyle = IQActionSheetPickerStyleDateTimePicker;
    picker.didSelectDate = ^(NSDate *date) {
        self.getTimeLabel.text = [NSDate getRealDateTime:date withFormat:YYYY_MM_DD_HH_MM];
    };
    [picker setDate:[NSDate dateString:self.getTimeLabel.text Format:YYYY_MM_DD_HH_MM]];
    [picker show];
}

- (void)toGetHGIdcardByPhone:(UITextField *)textField {
    
    if (self.phoneLabel.text.length == 11) {
        
        GetHGIdcardByPhoneReq *req = [GetHGIdcardByPhoneReq new];
        req.phone = self.phoneLabel.text;
        req.isSaasapp = YES;
        [YJYNetworkManager requestWithUrlString:GetHGIdcardByPhone message:req controller:self command:APP_COMMAND_GetHgidcardByPhone success:^(id response) {
            
            
            GetHGIdcardByPhoneRsp *rsp = [GetHGIdcardByPhoneRsp parseFromData:response error:nil];
            
            self.idcardLabel.text = rsp.idcard;
            self.nameLabel.text = rsp.hgName;
            
            if (rsp.sendDate.length > 0) {
                self.getTimeLabel.text = rsp.sendDate;
                self.timeButton.hidden = YES;
            }

        } failure:^(NSError *error) {
            
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {
        if (self.orderDetailRsp.order.status == YJYOrderInsureTypeWaitGuide) {
            return 0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}
@end

@interface YJYInsureOrderRelationController ()

@property (strong, nonatomic) YJYInsureOrderRelationContentController *contentVC;


@end

@implementation YJYInsureOrderRelationController


+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureOrderRelationController *)[UIStoryboard storyboardWithName:@"YJYInsureOrderUpdate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureOrderRelationContentController"]) {
        
        
        __weak typeof(self) weakSelf = self;
        self.contentVC = (YJYInsureOrderRelationContentController *)segue.destinationViewController;
        self.contentVC.orderDetailRsp = self.orderDetailRsp;
        
        
        self.contentVC.didDoneBlock = ^{
           
            if (weakSelf.didDoneBlock) {
                weakSelf.didDoneBlock();
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
        };
        
        
        
    }
}

- (IBAction)done:(id)sender {
    [self.contentVC done:nil];
}

@end

