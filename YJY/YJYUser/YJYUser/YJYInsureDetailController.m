//
//  YJYInsureDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/2.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureDetailController.h"
#import "YJYInsureListController.h"
#import "YJYInsurePaidController.h"
#import "YJYInsureQuestionController.h"
#import "YJYInsureReportController.h"
#import "YJYInsureSelfIntroController.h"


@interface YJYInsureDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MDHTMLLabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *stateCycleView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) InsureNODetailVO *detail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopConstraint;

@end

@implementation YJYInsureDetailCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.stateCycleView.layer.cornerRadius = 7.5/2;
    self.stateCycleView.layer.masksToBounds = YES;
    
}

- (void)setDetail:(InsureNODetailVO *)detail {

    _detail = detail;
    NSString *htmlText = [NSString stringWithFormat:@"%@  %@",detail.createTime,detail.content];
    
    self.desLabel.htmlText = htmlText;
    self.desLabel.font = [UIFont systemFontOfSize:15];
    self.desLabel.leading = 5;
    [self.desLabel sizeToFit];
    
}



@end



typedef void(^InsureDetailListDidRspBlock)(GetInsureRsp *rsp);
@interface YJYInsureDetailListController : YJYTableViewController<MDHTMLLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *insureNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

@property (copy, nonatomic) NSString *insureNo;
@property (strong, nonatomic) NSMutableArray<InsureNODetailVO*> *detailListArray;
@property (strong, nonatomic) NSArray<UIColor*> *detailListColor;
@property (strong, nonatomic) GetInsureRsp *rsp;

@property (copy, nonatomic) InsureDetailListDidRspBlock didRsp;


@end

@implementation YJYInsureDetailListController

- (void)viewDidLoad{

    self.detailListColor = @[APPORANGECOLOR,APPHEXCOLOR,APPBLUECOLOR,APPHEXCOLOR,APPREDCOLOR];
    self.detailListArray = [NSMutableArray array];
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    
    
    [SYProgressHUD show];
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self loadNetworkData];
}
- (void)loadNetworkData {
    
    GetInsureReq *req = [GetInsureReq new];
    req.insureNo = self.insureNo;
    
    [YJYNetworkManager requestWithUrlString:APPGetInsureDetail message:req controller:self command:APP_COMMAND_AppgetInsureDetail success:^(id response) {
        
        GetInsureRsp *rsp = [GetInsureRsp parseFromData:response error:nil];
        self.detailListArray = rsp.detailListArray;
        
        [self setupRsp:rsp];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    
}

- (void)setupRsp:(GetInsureRsp *)rsp {
    self.rsp = rsp;
    self.insureNumberLabel.text = self.rsp.insureNo;
    self.timeLabel.text = self.rsp.createTime;
    self.beServiceLabel.text = self.rsp.kinsName;
    self.idCardLabel.text = self.rsp.idcard;
    
    
    if (rsp.score == -1) {
        [self.rateButton setTitle:@"去自评" forState:0];
        [self.rateButton setTitleColor:APPHEXCOLOR forState:0];
    }else {
        
        [self.rateButton setTitle: (rsp.score == -2) ? @"无自评" : [NSString stringWithFormat:@"%@",@(rsp.score)] forState:0];
        [self.rateButton setTitleColor:APPMiddleGrayCOLOR forState:0];

    }
    
    if (self.didRsp) {
        self.didRsp(rsp);
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYInsureDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYInsureDetailCell"];
    
    cell.lineView.hidden = (indexPath.row == self.detailListArray.count - 1);

    NSInteger index = (indexPath.row >= 5) ? indexPath.row%5 : indexPath.row;
    cell.stateCycleView.backgroundColor = self.detailListColor[index];
    
    
    cell.desLabel.delegate = self;

    if (indexPath.row == 0) {
        cell.desLabel.textColor = APPHEXCOLOR;
    }else {
        cell.desLabel.textColor = APPDarkGrayCOLOR;
    }
    
    cell.detail = self.detailListArray[indexPath.row];

    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    YJYInsureDetailCell * cell = (YJYInsureDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger lines = [NSString numberOfLinesWithText:cell.desLabel.plainText font:[UIFont systemFontOfSize:15] width:cell.desLabel.frame.size.width];
    return 60 + (lines - 1) * 25;
}

- (IBAction)toRateAction:(id)sender {
    
    
    if (self.rsp.score == -1) {
        YJYInsureQuestionController *vc = [YJYInsureQuestionController new];
        vc.insureNo = self.rsp.insureNo;
        vc.isFromDetail  = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)toCopyInsureNumber:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.insureNumberLabel.text;
    [SYProgressHUD showSuccessText:@"复制成功"];
};
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if ([URL.absoluteString containsString:@"http"]) {
        
        YJYInsureReportController *vc = [YJYInsureReportController instanceWithStoryBoard];
        vc.urlString = URL.absoluteString;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end


@interface YJYInsureDetailController ()

@property (strong, nonatomic) YJYInsureDetailListController *detailVC;
@property (strong, nonatomic) GetInsureRsp *rsp;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation YJYInsureDetailController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"YJYInsureDetailListController"]) {
        
        self.detailVC = segue.destinationViewController;
        self.detailVC.insureNo = self.insreNO;
        
        if(self.orderId) {
            self.detailVC.insureNo = self.orderId;
        }
        
        __weak typeof(self) weakSelf = self;
        self.detailVC.didRsp = ^(GetInsureRsp *rsp) {
            
            [weakSelf setupRsp:rsp];
          
            
        };
        
    }
}

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureDetailController *)[UIStoryboard storyboardWithName:@"YJYInsure" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    if (self.isProcess) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:nil];
    }else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:nil];
        
    }
}

- (void)setupRsp:(GetInsureRsp *)rsp {
    self.rsp = rsp;
    
//     1-不可以 2-支付保证金 3-强制申请
    NSString *title;
    if (self.rsp.forceFlag == 1) {
        title = @"联系客服";
    }else if (self.rsp.forceFlag == 3) {
        title = @"继续提交";

    }
    
    if (rsp.status == 4) {
        title =  @"马上预约服务";

    }
    
    [self.actionButton setTitle:title forState:0];

}



- (IBAction)toAction:(id)sender {
    
    if (self.rsp.status == 4) {
        [self toReviewApply];
        return;
    }
    
    if (self.rsp.forceFlag == 1) {
        [self toCall];
    }else if (self.rsp.forceFlag == 3) {
        
        NSString *alert = [NSString stringWithFormat:@"继续提交,我们会派专业护士上门为您评估"];
        
        [UIAlertController showAlertInViewController:self withTitle:nil message:alert alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认"  otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [self toSubmit];
            }
            
        }];
    }
   
    
}


- (void)toReviewApply {
    
    YJYInsureSelfIntroController *vc = [YJYInsureSelfIntroController instanceWithStoryBoard];
    vc.insureNo = self.insreNO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)toSubmit {
    
    [SYProgressHUD show];

    GetInsureReq *req = [GetInsureReq new];
    req.insureNo = self.insreNO;
    
    [YJYNetworkManager requestWithUrlString:APPForceSubmitInsure message:req controller:self command:APP_COMMAND_AppforceSubmitInsure success:^(id response) {
        
        [SYProgressHUD showSuccessText:@"提交成功"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];

        });

        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)toCall {
  
    
    [SYProgressHUD show];
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.rsp.kfPhone]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [SYProgressHUD hide];
    [self.view addSubview:callWebView];
    
}
- (IBAction)toListAction {
    YJYInsureListController *vc = [YJYInsureListController instanceWithStoryBoard];
    vc.isProcess = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
