//
//  YJYInsureApplyController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureApplyController.h"
#import "YJYInsureDetailController.h"
#import "YJYKinsfolksController.h"
#import "YJYPersonEditController.h"
#import "YJYAddressesController.h"
#import "YJYAddressPositionController.h"
#import "YJYInsureQuestionController.h"


@interface YJYInsureApplyDetailController : YJYTableViewController

@property (weak, nonatomic) IBOutlet UITextField *personTextField;
@property (weak, nonatomic) IBOutlet UIButton *applyPersonButton;


@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;


//agent
@property (weak, nonatomic) IBOutlet UITextField *agentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *agentRelationshipTextField;
@property (weak, nonatomic) IBOutlet UITextField *agentPhoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *receiveWayButton;


@property (strong, nonatomic) KinsfolkVO *kinsfolk;
@property (strong, nonatomic) UserAddressVO *address;
@property (assign, nonatomic) uint64_t assessId;
@property (assign, nonatomic) uint64_t score;

@property (strong, nonatomic) AddInsureReq *addInsureReq;

@end

@implementation YJYInsureApplyDetailController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.addInsureReq = [AddInsureReq new];

    
    [self loadMyData];
    [self loadNetworkKinsfolk];
    [self loadNetworkAddress];
    
    
}
#pragma mark - Action


- (IBAction)rerateAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addressAction:(id)sender {
    
    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:APPListUserAddress message:nil controller:self command:APP_COMMAND_ApplistUserAddress success:^(id response) {
        
        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
        
        YJYAddressesController *listVC = [YJYAddressesController instanceWithStoryBoard];
        listVC.isApply = YES;
        listVC.didSelectBlock = ^(UserAddressVO *address) {
            [self setupAddress:address];
        };
        
        if (rsp.userAddressVoArray.count > 0) {
            
            [self.navigationController pushViewController:listVC animated:YES];
            
        }else {
            
            
            YJYAddressPositionController *vc = [YJYAddressPositionController instanceWithStoryBoard];
            vc.title = @"添加联系信息";
            vc.addressDidSavedBlock = ^(UserAddressVO *address) {
                [self setupAddress:address];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
         
            
        }
        [SYProgressHUD hide];
        
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD hide];
        
    }];
}
- (IBAction)personAction:(id)sender {
    

    [SYProgressHUD show];
    
    [YJYNetworkManager requestWithUrlString:APPListKinsfolk message:nil controller:self command:APP_COMMAND_ApplistKinsfolk success:^(id response) {
        
        
        [SYProgressHUD hide];
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        
       
        
        if (rsp.kinsfolkListArray.count > 0) {
            
            YJYKinsfolksController *vc = [YJYKinsfolksController instanceWithStoryBoard];
            vc.kinsType = 1;
            vc.kinsfolksDidSelectBlock = ^(KinsfolkVO *kinsfolk) {
                
                [self setupKindFolk:kinsfolk];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
            vc.firstAdd = YES;
            vc.kinsType = 1;
            vc.title = @"添加参保人";
          
            [self.navigationController pushViewController:vc animated:YES];
            

            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    

}

- (void)applyAction:(id)sender {
    
    [SYProgressHUD show];
    
    self.addInsureReq.kinsId = self.kinsfolk.kinsId;
    self.addInsureReq.addrId = self.address.addrId;
    self.addInsureReq.agencyName = self.agentNameTextField.text;
    self.addInsureReq.agencyRelation = self.agentRelationshipTextField.text;
    self.addInsureReq.agencyPhone = self.agentPhoneTextField.text;
    
    [YJYNetworkManager requestWithUrlString:APPAddInsure message:self.addInsureReq controller:self command:APP_COMMAND_AppaddInsure success:^(id response) {
        
        AddInsureRsp *rsp = [AddInsureRsp parseFromData:response error:nil];
        if (rsp.insureNo) {
            
            if (rsp.score == -1) {
                
                [self toQuestionWithRsp:rsp];
                
            }else if (rsp.score == -2) {
                
               [self toDetailWithRsp:rsp];
            
            }else if (rsp.score >= 0) {
            
                [SYProgressHUD hide];

                NSString *description = @"为了更好地为您服务，我们会将您的自理能力得分一起提交，是否重新评估？";
                
                NSString *scoreDes = [NSString stringWithFormat:@"上次评估分数：%@",@(rsp.score)];
                NSString *timeDes = [NSString stringWithFormat:@"上次评估时间：%@",rsp.lastAssessTime];
                
                NSString *des = [NSString stringWithFormat:@"%@\n\n%@\n%@",description,scoreDes,timeDes];
                
                [UIAlertController showAlertInViewController:self withTitle:nil message:des alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"直接提交" destructiveButtonTitle:@"重新评估" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        
                        [self toQuestionWithRsp:rsp];

                    }else {
                        
                        [self toDetailWithRsp:rsp];
                    }
                    
                    
                }];
            }
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
   
}

- (void)toQuestionWithRsp:(AddInsureRsp *)rsp {

    YJYInsureQuestionController *vc = [YJYInsureQuestionController new];
    vc.insureNo = rsp.insureNo;
    vc.idCardNO = self.kinsfolk.idCardNo;
    [self.navigationController pushViewController:vc animated:YES];
    
    [SYProgressHUD hide];
}

- (void)toDetailWithRsp:(AddInsureRsp *)rsp {

    YJYInsureDetailController *vc = [YJYInsureDetailController instanceWithStoryBoard];
    vc.insreNO = rsp.insureNo;
    vc.isProcess = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [SYProgressHUD hide];
}
- (IBAction)toReceiveAction:(UIButton *)sender {
    
    [UIAlertController showAlertInViewController:self withTitle:@"选择领取方式" message:nil alertControllerStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:@"邮寄" otherButtonTitles:@[@"自行领取"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex != 0) {
            
            [sender setTitle:buttonIndex == 1 ? @"邮寄" : @"自行领取" forState:0];
            
            self.addInsureReq.insureGetType = (uint32_t)(buttonIndex);
        }
        
    }];
}

#pragma mark - Network

- (void)loadNetworkKinsfolk {
    
    [YJYNetworkManager requestWithUrlString:APPListKinsfolk message:nil controller:self command:APP_COMMAND_ApplistKinsfolk success:^(id response) {
        
        
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        for (KinsfolkVO *kinsfolk in rsp.kinsfolkListArray) {
            if (kinsfolk.insureFlag) {
                self.kinsfolk = kinsfolk;
                break;
            }
        }

        [self setupKindFolk:self.kinsfolk];
        
        
    } failure:^(NSError *error) {
        [self setupKindFolk:nil];

    }];
    
}

- (void)loadMyData {
    
    [YJYNetworkManager requestWithUrlString:APPGetUserInfo message:nil controller:nil command:APP_COMMAND_AppgetUserInfo success:^(id response) {
        
        GetUserInfoRsp *rsp = [GetUserInfoRsp parseFromData:response error:nil];
        self.agentPhoneTextField.text = rsp.userVo.phone;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)loadNetworkAddress {
    
    [YJYNetworkManager requestWithUrlString:APPListUserAddress message:nil controller:self command:APP_COMMAND_ApplistUserAddress success:^(id response) {
        
        
        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
        self.address = rsp.userAddressVoArray.firstObject;
        [self setupAddress:self.address];
        
    } failure:^(NSError *error) {
        [self setupAddress:nil];
    }];
    
    
}
- (void)setupKindFolk:(KinsfolkVO *)kinsfolk {

    self.kinsfolk = kinsfolk;
    self.applyButton.hidden = (kinsfolk.name.length == 0);
    if (kinsfolk.name.length > 0) {
        self.personTextField.text =
        [NSString stringWithFormat:@"%@  年龄  %@岁  性别   %@",self.kinsfolk.name,@(self.kinsfolk.age),((self.kinsfolk.sex == 1) ? @"男" : @"女")];
        [self.tableView reloadData];

    }
    
    
}
- (void)setupAddress:(UserAddressVO *)address {

   
    self.address = address;
    BOOL isAddress = (address.addressInfo.length > 0);
    
    self.addressTextField.hidden = isAddress;
    self.addressLabel.hidden = !isAddress;
    self.nameLabel.hidden = !isAddress;
    
    if (isAddress) {
        
        self.addressLabel.attributedText = [address.addressInfo attributedStringWithLineSpacing:6];
        [self.addressLabel sizeToFit];
        self.nameLabel.text = address.contacts;
        [self.tableView reloadData];

    }

}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3 && self.address.addressInfo.length > 0) {
        
        CGSize size = [self.addressLabel.text boundingRectWithSize:CGSizeMake(self.addressLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.addressLabel.font} context:nil].size;
        double height = ceil(size.height);
        
        return 70-13 + height;
        
    }else {
    
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}
@end

#pragma mark - YJYInsureApplyController

@interface YJYInsureApplyController ()

@property (strong, nonatomic) YJYInsureApplyDetailController *detailVC;

@end

@implementation YJYInsureApplyController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureApplyController *)[UIStoryboard storyboardWithName:@"YJYInsure" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureApplyDetailController"]) {
        self.detailVC = segue.destinationViewController;
        self.detailVC.kinsfolk = self.kinsfolk;
        self.detailVC.assessId = self.assessId;
        self.detailVC.score = self.score;

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)applyAction:(id)sender {
    
    
    [self.detailVC applyAction:nil];
    
    
}




@end
