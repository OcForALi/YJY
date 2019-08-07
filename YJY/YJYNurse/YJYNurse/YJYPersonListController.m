//
//  YJYKinsfolksController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYPersonListController.h"
#import "YJYPersonEditController.h"

@class KinsfolkVO;

typedef void(^DidEditAction)(KinsfolkVO *kinsfolk);
typedef void(^DidDeleteAction)(KinsfolkVO *kinsfolk);
typedef void(^DidApplyAction)(KinsfolkVO *kinsfolk);
typedef void(^DidOptionAction)(KinsfolkVO *kinsfolk);


@interface YJYPersonListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *genderLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *unselectedImageView;

//option

@property (weak, nonatomic) IBOutlet UIButton *optionButton;

//apply
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UILabel *insureDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (copy, nonatomic) DidEditAction didEditAction;
@property (copy, nonatomic) DidDeleteAction didDeleteAction;
@property (copy, nonatomic) DidApplyAction didApplyAction;
@property (copy, nonatomic) DidOptionAction didOptionAction;


@property (strong, nonatomic) KinsfolkVO *kinsfolk;
@property (assign, nonatomic) BOOL isApply;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateDesMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyButtonWidthConstraint;

@end

@implementation YJYPersonListCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.applyButton.layer.cornerRadius = 5;
    self.applyButton.layer.borderColor = APPHEXCOLOR.CGColor;
    self.applyButton.layer.borderWidth = 1;
    
    
    if (IS_IPHONE_5) {
        self.applyButtonWidthConstraint.constant = 60;
        self.ageLeftConstraint.constant = 5;
    }else if (IS_IPHONE_6) {
        self.applyButtonWidthConstraint.constant = 60;
        self.ageLeftConstraint.constant = 50;
    }else if (IS_IPHONE_6Plus) {
        self.applyButtonWidthConstraint.constant = 60;
        self.ageLeftConstraint.constant = 55;
    }
    
}

- (IBAction)editAction:(id)sender {
    if (self.didEditAction) {
        self.didEditAction(self.kinsfolk);
    }
}
- (IBAction)deleteAction:(id)sender {
    
    if (self.didDeleteAction) {
        self.didDeleteAction(self.kinsfolk);
    }
}
- (IBAction)applyAction:(id)sender {
    
    if (self.didApplyAction) {
        self.didApplyAction(self.kinsfolk);
    }
}
- (IBAction)optionAction:(id)sender {
    
    if (self.didOptionAction) {
        self.didOptionAction(self.kinsfolk);
    }
}
- (void)setKinsfolk:(KinsfolkVO *)kinsfolk {
    
    _kinsfolk = kinsfolk;
    
    self.applyButton.hidden = !self.isApply;
    self.insureDescLabel.hidden = !self.isApply;
    self.unselectedImageView.hidden = !self.isApply;
    self.optionButton.hidden = self.isApply;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLab.text = kinsfolk.name;
    self.genderLab.text = (kinsfolk.sex == 1) ? @"性别:男" : @"性别:女";
    self.ageLab.text = [NSString stringWithFormat:@"年龄:%@岁",@(kinsfolk.age)];
    
    if (self.isApply) {
        
        if (kinsfolk.insureFlagType == 0) {
            [self.applyButton setTitle:@"申请" forState:0];
        }else if (kinsfolk.insureFlagType == 1) {
            self.applyButton.hidden = YES;
        }else {
            [self.applyButton setTitle:@"去补全" forState:0];
        }
        
        
        self.rateDesMarginConstraint.constant = (kinsfolk.score >= 0) ? 10 : 0;
        
        self.insureDescLabel.text = [NSString stringWithFormat:@"长护险资质：%@",kinsfolk.insureDesc];
        [self.insureDescLabel sizeToFit];
        
        self.unselectedImageView.hidden = (kinsfolk.insureFlag);
        self.rateLabel.text = (kinsfolk.score == -1) ? @"" : [NSString stringWithFormat:@"自评得分:%@",@(kinsfolk.score)];
        [self.rateLabel sizeToFit];
        
        
        for (UIView *subView in self.contentView.subviews[0].subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                
                UILabel *label = (UILabel *)subView;
                UIColor *HColor = APPMiddleGrayCOLOR;
                if (label == self.rateLabel || label == self.insureDescLabel) {
                    HColor = APPHEXCOLOR;
                }
                label.textColor = (kinsfolk.insureFlagType != 1) ?  HColor : APPGrayCOLOR;
            }
            
        }
        
        
        
    }else {
        
        if (kinsfolk.defaultUse) {
            [self.optionButton setImage:[UIImage imageNamed:@"app_select_icon"] forState:0];
        }else {
            [self.optionButton setImage:[UIImage imageNamed:@"app_unselect_icon"] forState:0];
            
        }
        
    }
    
    
}

@end


#pragma mark - YJYPersonListController

@interface YJYPersonListController ()
@property (weak, nonatomic) IBOutlet YJYTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) NSMutableArray<KinsfolkVO *> *kinsfolks;
@end

@implementation YJYPersonListController



+ (instancetype)instanceWithStoryBoard {
    
    return (YJYPersonListController *)[UIStoryboard storyboardWithName:@"YJYPerson" viewControllerIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.kinsType == 1) {
        self.title = @"选择参保人";
        [self.addButton setTitle:@"＋ 添加参保人" forState:0];
    }
    
    
    
    self.kinsfolks = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkingData];
    }];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.noDataTitle = @"添加家庭成员，关爱家庭健康";
    self.tableView.emptyImageView.center = CGPointMake(self.tableView.emptyView.center.x,  self.tableView.emptyImageView.center.y);
    
    [self loadNetworkingData];
    
    [SYProgressHUD show];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkingData];
    
}

- (void)loadNetworkingData {
    
    GetUserReq *req = [GetUserReq new];
    req.userId = [YJYSettingManager sharedInstance].userId;
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetUserKinsList message:req controller:self command:APP_COMMAND_SaasappgetUserKinsList success:^(id response) {
        
        
        ListKinsfolkRsp *rsp = [ListKinsfolkRsp parseFromData:response error:nil];
        self.kinsfolks = rsp.kinsfolkListArray;
        
        [self.tableView reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self.tableView reloadErrorData];
        
        
    }];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.kinsfolks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *identifier = self.kinsType == 1 ? @"YJYPersonListCellApply" : @"YJYPersonListCellMine";
    
    YJYPersonListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    KinsfolkVO *kinsfolk = self.kinsfolks[indexPath.row];
    cell.isApply = self.kinsType;
    cell.kinsfolk = kinsfolk;
    
    
    
    cell.didEditAction = ^ (KinsfolkVO *kinsfolk) {
        
        [self editKinsfolkWithKinsfolk:kinsfolk];
    };
    cell.didDeleteAction = ^ (KinsfolkVO *kinsfolk) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否删除" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [self delateKinsfolkWithKinsfolk:kinsfolk];
            }
            
        }];
    };
    
    cell.didApplyAction = ^(KinsfolkVO *kinsfolk) {
        if (kinsfolk.insureFlagType == 0) {
            self.kinsfolksDidSelectBlock(kinsfolk);
            [self.navigationController popViewControllerAnimated:YES];
        }else if (kinsfolk.insureFlagType == 2) {
            
            YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
            vc.kinsfolk = kinsfolk;
            vc.kinsType = self.kinsType;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    };
    
    cell.didOptionAction = ^(KinsfolkVO *kinsfolk) {
        [self updateKinsfolkWithKinsfolk:kinsfolk];
    };
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.kinsfolksDidSelectBlock) {
        
        
        KinsfolkVO *kins = self.kinsfolks[indexPath.row];
        if (self.kinsType && !kins.insureFlag) {
            return;
        }
        self.kinsfolksDidSelectBlock(kins);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

#pragma mark - action
- (IBAction)addKinsfolk:(id)sender {
    
    YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
    vc.kinsType = self.kinsType;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)delateKinsfolkWithKinsfolk:(KinsfolkVO *)kinsfolk {
    
    [SYProgressHUD show];
    
    DelKinsfolkReq *req = [DelKinsfolkReq new];
    req.kinsId = kinsfolk.kinsId;
    req.userId = self.kinsType == YJYPersonListKinsTypeApply ? [YJYSettingManager sharedInstance].userId : nil;
    
    [YJYNetworkManager requestWithUrlString:APPDelKinsfolk message:req controller:self command:APP_COMMAND_AppdelKinsfolk success:^(id response) {
        
        
        
        [self.kinsfolks removeObject:kinsfolk];
        [self.tableView reloadAllData];
        [SYProgressHUD showSuccessText:@"删除成功"];
        
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)editKinsfolkWithKinsfolk:(KinsfolkVO *)kinsfolk {
    
    
    YJYPersonEditController *vc = [YJYPersonEditController instanceWithStoryBoard];
    vc.kinsfolk = kinsfolk;
    vc.kinsType = self.kinsType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateKinsfolkWithKinsfolk:(KinsfolkVO *)kinsfolk {
    
    [SYProgressHUD show];
    
    SetDefaultKinsReq *req = [SetDefaultKinsReq new];
    req.kinsId = kinsfolk.kinsId;
    
    [YJYNetworkManager requestWithUrlString:APPSetDefaultKinsfolk message:req controller:self command:APP_COMMAND_AppsetDefaultKinsfolk success:^(id response) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SYProgressHUD showSuccessText:@"设置成功"];
            [self.tableView reloadAllData];
            [self loadNetworkingData];
        });
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}


@end
