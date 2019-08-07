//
//  YJYAddressesController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/6.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYAddressesController.h"
#import "YJYAddressPositionController.h"

@class UserAddressVO;

typedef void(^DidEditAction)(UserAddressVO *address);
typedef void(^DidDeleteAction)(UserAddressVO *address);
typedef void(^DidOptionAction)(UserAddressVO *address);

@interface YJYAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@property (copy, nonatomic) DidEditAction didEditAction;
@property (copy, nonatomic) DidDeleteAction didDeleteAction;
@property (copy, nonatomic) DidOptionAction didOptionAction;


@property (strong, nonatomic) UserAddressVO *address;

@end

@implementation YJYAddressCell

- (IBAction)editAction:(id)sender {
    if (self.didEditAction) {
        self.didEditAction(self.address);
    }
}
- (IBAction)deleteAction:(id)sender {

    if (self.didDeleteAction) {
        self.didDeleteAction(self.address);
    }
}
- (IBAction)optionAction:(id)sender {
    
    if (self.didOptionAction) {
        self.didOptionAction(self.address);
    }
}

- (void)setAddress:(UserAddressVO *)address {

    
    _address = address;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.addressLab.attributedText = [address.addressInfo attributedStringWithLineSpacing:8];
    [self.addressLab sizeToFit];
    
    
    self.nameLabel.text = (address.contacts.length > 0) ? address.contacts : @"无姓名" ;
    self.phoneLabel.text = (address.phone.length > 0) ? address.phone : @"无电话";
    if (address.defaultUse == 1) {
        
        [self.optionButton setImage:[UIImage imageNamed:@"app_select_icon"] forState:0];
        self.dotView.backgroundColor = APPORANGECOLOR;
    }else {
        
        [self.optionButton setImage:[UIImage imageNamed:@"app_unselect_icon"] forState:0];
       self.dotView.backgroundColor = APPDarkCOLOR;
        
        
    }
}


@end

#pragma mark - YJYAddressesController

@interface YJYAddressesController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<UserAddressVO *> *addresses;
@property (weak, nonatomic) IBOutlet YJYTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation YJYAddressesController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYAddressesController *)[UIStoryboard storyboardWithName:@"YJYAddress" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (self.isApply) {
        [self.addButton setTitle:@"＋ 新增联系信息" forState:0];
        self.title = @"选择联系信息";
    }
    
    self.addresses = [NSMutableArray array];
    self.tableView.backgroundColor = APPExtraGrayCOLOR;
    
    

    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkingData];
    }];
    
    self.tableView.noDataTitle = @"添加服务地址便捷下单";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetworkingData];

}

- (void)loadNetworkingData {
    
    
    [YJYNetworkManager requestWithUrlString:APPListUserAddress message:nil controller:self command:APP_COMMAND_ApplistUserAddress success:^(id response) {
        
        ListUserAddressRsp *rsp = [ListUserAddressRsp parseFromData:response error:nil];
        self.addresses = rsp.userAddressVoArray;
        [self.tableView reloadAllData];

        
    } failure:^(NSError *error) {
        
        [self.tableView reloadErrorData];
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YJYAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYAddressCell" forIndexPath:indexPath];
    UserAddressVO *address = self.addresses[indexPath.row];
    cell.address = address;
    
    cell.didEditAction = ^ (UserAddressVO *cellAddress) {
    
        [self toAddressSearchWithAddress:cellAddress isEdit:YES];
    };
    cell.didDeleteAction = ^ (UserAddressVO *cellAddress) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"是否删除" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
             
                [self delateAddressWithAddress:address];
            }
            
        }];
    };
    
    cell.didOptionAction = ^ (UserAddressVO *cellAddress) {
        
        [self updateDefaultUseWithAddress:cellAddress];
        
        
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserAddressVO *address = self.addresses[indexPath.row];
    if (self.didSelectBlock) {
        self.didSelectBlock(address);
        [self.navigationController popViewControllerAnimated:YES];
         
    }
    
}

#pragma mark - action

- (void)delateAddressWithAddress:(UserAddressVO *)address {

    [SYProgressHUD show];
    
    DelUserAddressReq *req = [DelUserAddressReq new];
    req.addrId = address.addrId;
    
    [YJYNetworkManager requestWithUrlString:APPDelUserAddress message:req controller:self command:APP_COMMAND_AppdelUserAddress success:^(id response) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
            [self.addresses removeObject:address];
            [self.tableView reloadAllData];
            [SYProgressHUD showSuccessText:@"删除成功"];
        });
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (IBAction)addAddressAction:(id)sender {
    
    [self toAddressSearchWithAddress:nil isEdit:NO];
}

- (void)toAddressSearchWithAddress:(UserAddressVO *)address isEdit:(BOOL)isEdit{

    
    YJYAddressPositionController *editVC = (YJYAddressPositionController *) [UIStoryboard storyboardWithName:@"YJYAddress" viewControllerIdentifier:@"YJYAddressPositionController"];
    editVC.addressDidSavedBlock = ^(UserAddressVO *address) {
        [self loadNetworkingData];
    };
    editVC.address = address;
    editVC.isEdit = isEdit;
    [self.navigationController pushViewController:editVC animated:YES];
    
}
- (void)updateDefaultUseWithAddress:(UserAddressVO *)address {

    [SYProgressHUD show];
    
    SetDefaultUserAddressReq *req = [SetDefaultUserAddressReq new];
    req.addrId = address.addrId;
    
    [YJYNetworkManager requestWithUrlString:APPSetDefaultAddress message:req controller:self command:APP_COMMAND_AppsetDefaultAddress success:^(id response) {
 
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SYProgressHUD showSuccessText:@"设置成功"];
            [self.tableView reloadAllData];
            [self loadNetworkingData];
        });
        
    } failure:^(NSError *error) {
        

        
    }];
    
}
@end
