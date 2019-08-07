//
//  YJYNotificationController.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/3.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYNotificationController.h"
#import "YJYNotificationDetailController.h"

@interface YJYNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (strong, nonatomic) SystemMessageVO *systemMessage;

@end

@implementation YJYNotificationCell

- (void)setSystemMessage:(SystemMessageVO *)systemMessage {
    
    _systemMessage = systemMessage;
    
    self.titleLab.text = systemMessage.title;
    self.timeLab.text = systemMessage.createTime;
    
    self.desLab.htmlText = systemMessage.content;
    
    self.numLab.layer.cornerRadius = 8;
    self.numLab.hidden = (systemMessage.num <= 0);
    self.numLab.text = [NSString stringWithFormat:@"%@",@( systemMessage.num)];
    
    
//    (1-50) 缴费
//    (51-100)提现
//    (101-200)服务
//    (201-300)长护险
    
    NSString *imgName = @"notification_server_icon";
    
    if (systemMessage.msgType >= 1 && systemMessage.msgType <= 50) {
        
        imgName = @"notification_money_icon";
        
    }else if (systemMessage.msgType >= 51 && systemMessage.msgType <= 100) {
        
        imgName = @"notification_outmoney_icon";

    }else if (systemMessage.msgType >= 101 && systemMessage.msgType <= 200) {
        imgName = @"notification_server_icon";

    }else if (systemMessage.msgType >= 201 && systemMessage.msgType <= 300) {
        imgName = @"notification_insure_icon";
        
    }
    
    self.imgButton.image = [UIImage imageNamed:imgName];
    
    
}

@end


@interface YJYNotificationController ()<MDHTMLLabelDelegate>

@property(nonatomic, strong) NSMutableArray<SystemMessageVO*> *msgListArray;

@end

@implementation YJYNotificationController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNotificationController *)[UIStoryboard storyboardWithName:@"YJYNotification" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    

    
    [super viewDidLoad];
    
    self.msgListArray = [NSMutableArray array];
    
    if (!self.isPushController) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(backAction:)];

    }

    
    //APPGetMsgList
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

    
    [YJYNetworkManager requestWithUrlString:APPGetMsgList message:nil controller:self command:APP_COMMAND_AppgetMsgList success:^(id response) {
        
        GetMsgListRsp *rsp = [GetMsgListRsp parseFromData:response error:nil];
        self.msgListArray = rsp.msgListArray;
        [SYProgressHUD hide];
        [self reloadAllData];
        
    } failure:^(NSError *error) {
        [self reloadErrorData];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.msgListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YJYNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYNotificationCell"];
    
    SystemMessageVO *systemMessage = self.msgListArray[indexPath.row];
    cell.systemMessage = systemMessage;
    cell.desLab.delegate = self;

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    SystemMessageVO *systemMessage = self.msgListArray[indexPath.row];

    CGFloat width = self.tableView.frame.size.width - 85;
    
    CGFloat height = [MDHTMLLabel sizeThatFitsHTMLString:systemMessage.content withFont:[UIFont systemFontOfSize:16] constraints:CGSizeMake(width, 0) limitedToNumberOfLines:0 autoDetectUrls:NO];
    
    
//    NSInteger lines = (NSInteger)(height / [UIFont systemFontOfSize:15].lineHeight);
    
    return 85 + height;// (lines - 1) * 18;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SystemMessageVO *systemMessage = self.msgListArray[indexPath.row];

    
    YJYNotificationDetailController *vc = [YJYNotificationDetailController instanceWithStoryBoard];
    vc.msgType = systemMessage.msgType;
    vc.title = systemMessage.title;
    [self.navigationController pushViewController:vc animated:YES];

    
//    SystemMsgMarkAsReadReq *req = [SystemMsgMarkAsReadReq new];
//    req.id_p = systemMessage.id_p;
//
//    [YJYNetworkManager requestWithUrlString:SAASAPPUpdateMessageRead message:req controller:self command:APP_COMMAND_SaasappupdateMessageRead success:^(id response) {
//
//        [SYProgressHUD hide];
//        [self.navigationController pushViewController:vc animated:YES];
//
//
//    } failure:^(NSError *error) {
//
//    }];
    
    
}
- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if ([URL.absoluteString containsString:@"http"]) {
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = URL.absoluteString;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
