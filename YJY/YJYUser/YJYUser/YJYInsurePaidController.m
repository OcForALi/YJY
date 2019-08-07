//
//  YJYInsurePaidController.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/22.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsurePaidController.h"

@interface YJYPayItem : NSObject

@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *balance;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic)  BOOL usePurse;

@end

@implementation YJYPayItem


@end


@interface YJYPayItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel * yueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) YJYPayItem *item;


@end

@implementation YJYPayItemCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.yueLabel.layer.borderColor = APPORANGECOLOR.CGColor;
    self.yueLabel.layer.borderWidth = 1;
    
}

- (void)setItem:(YJYPayItem *)item {

    
    _item = item;
    self.itemImageView.image = [UIImage imageNamed:item.img];
    self.itemLabel.text = item.title;
    
    
    //钱包支付
    if ([item.title isEqualToString:@"钱包支付"]) {
        
        self.yueLabel.hidden = NO;
        if (item.usePurse) {
            self.yueLabel.text = [NSString stringWithFormat:@" 余额 : %@  ",item.balance];
            [self.yueLabel sizeToFit];
            self.itemImageView.image = [UIImage imageNamed:@"pay_purse_able_icon"];
            self.itemLabel.textColor = APPDarkCOLOR;
            self.userInteractionEnabled = YES;
            
        }else {
            self.yueLabel.text = @" 钱包余额不足 ";
            [self.selectButton setImage:[UIImage imageNamed:@"pay_unselect_icon"] forState:0];
            self.itemImageView.image = [UIImage imageNamed:@"pay_purse_unable_icon"];
            self.itemLabel.textColor = APPGrayCOLOR;
            self.userInteractionEnabled = NO;
        }
    }else {
    
        self.yueLabel.hidden = YES;
    
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    if (selected) {
        
        [self.selectButton setImage:[UIImage imageNamed:@"pay_select_icon"] forState:0];

        
    }else {
    
        [self.selectButton setImage:[UIImage imageNamed:@"pay_unselect_icon"] forState:0];

    }
    
}



@end


@interface YJYInsurePaidController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) YJYPayItem *currentItem;


@end

@implementation YJYInsurePaidController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsurePaidController *)[UIStoryboard storyboardWithName:@"YJYInsureDone" viewControllerIdentifier:NSStringFromClass(self)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //item
    
    YJYPayItem *pocket = [YJYPayItem new];
    pocket.img = @"pay_purse_able_icon";
    pocket.title = @"钱包支付";
    pocket.type = 6;
    pocket.balance = self.purse;
    pocket.usePurse = self.usePurse;
    
    
    //
    
    YJYPayItem *alipay = [YJYPayItem new];
    alipay.img = @"pay_alipay_icon";
    alipay.title = @"支付宝支付";
    alipay.type = 1;

    
    YJYPayItem *wechat = [YJYPayItem new];
    wechat.img = @"pay_wechat_icon";
    wechat.title = @"微信支付";
    wechat.type = 3;

    self.items = [NSMutableArray arrayWithArray:@[pocket,alipay,wechat]];
    self.currentItem = pocket;
    
    [self.tableView reloadData];


  
    self.chargeLabel.text = self.depositFee;
    [self.chargeLabel sizeToFit];
    [self.moneyButton setTitle:[NSString stringWithFormat:@"确定支付 %@ 元",self.depositFee] forState:0];
    
    
    [self loadNetworkData];
    
}

- (void)loadNetworkData {
    
    [YJYNetworkManager requestWithUrlString:APPGetUserAccount message:nil controller:self command:APP_COMMAND_AppgetUserAccount success:^(id response) {
        
        GetUserAccountRsp *rsp = [GetUserAccountRsp parseFromData:response error:nil];
        YJYPayItem *pocket = self.items[0];
        pocket.balance = rsp.accountStr;
        self.items[0] = pocket;
        
        [self.tableView reloadData];
        
        NSInteger index = self.usePurse ? 0 : 1;
        self.currentItem = self.items[index];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

        
        
    } failure:^(NSError *error) {
        
    }];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYPayItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYPayItemCell"];
    cell.item = self.items[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentItem = self.items[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 62;
}

- (IBAction)pay:(UIButton *)sender {

    
    [SYProgressHUD show];
    
    if (self.currentItem.type == 0) {
        [SYProgressHUD showFailureText:@"钱包功能尚未可以"];
        return;
    }
    
    DoPayReq *req = [DoPayReq new];
    req.operation = @"PAY_INSURE";
    req.insureNo = self.insureNo;
    req.payType = (uint32_t)self.currentItem.type;
    
  //  self.isPaying = NO;
    
    [YJYNetworkManager requestWithUrlString:APPDoPay message:req controller:self command:APP_COMMAND_DoPay success:^(id response) {
        
       // self.isPaying = YES;
        [YJYPaymentManager sharedInstance].payResult = [NSString stringWithFormat:@"%@",self.depositFee] ;
        
        [SYProgressHUD hide];
        DoPayRsp *rsp = [DoPayRsp parseFromData:response error:nil];
        
        if (req.payType == 6) {
            
            [[YJYPaymentManager sharedInstance] handleStateCode:CDMStateCodeSuccess vc:self isOrder:NO isRoot:NO complete:^{
                [self loadNetworkData];
            }];
            [SYProgressHUD showSuccessText:@"支付成功"];
            
            
            
        }else if (req.payType == 3 || req.payType == 1) {
            
            id orderMessage = (req.payType == 3) ? [[YJYPaymentManager sharedInstance]wechatPayReqWithOrderString:rsp.prePayId] : rsp.prePayId;
            
            [[YJYPaymentManager sharedInstance] cdm_payOrderMessage:orderMessage callBack:^(CDMPayStateCode stateCode, NSString *stateMsg) {
                
                [[YJYPaymentManager sharedInstance] handleStateCode:stateCode vc:self isOrder:NO isRoot:NO complete:^{
                    [self loadNetworkData];
                }];
            }];
            
            [SYProgressHUD hide];
            
        }else {
            
            
            [SYProgressHUD hide];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)dismiss{
    
    
    [UIAlertController showAlertInViewController:self withTitle:@"是否取消支付" message:nil alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [self.navigationController popToRootViewControllerAnimated:NO];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:kYJYTabBarIndexSelectNotification object:nil];

            });
          
        
        }
        
    }];
    
   
}



@end
