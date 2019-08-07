//
//  YJYNotificationListController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/8/3.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNotificationListController.h"
#import "YJYProtocolManager.h"
#import "YJYNotificationDetailController.h"
@interface YJYNotificationListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *desLabel;

@property (strong, nonatomic) SystemMessage *systemMessage;

@end

@implementation YJYNotificationListCell

- (void)setSystemMessage:(SystemMessage *)systemMessage {

    _systemMessage = systemMessage;
    self.timeLabel.text = systemMessage.createTimeStr;    
    self.dotView.hidden = (systemMessage.state == 1);
    
    
    self.desLabel.textColor = (systemMessage.state == 1) ? [UIColor lightGrayColor] : [UIColor blackColor];

    self.desLabel.htmlText = systemMessage.content;
    self.desLabel.textColor = (systemMessage.state == 1) ? [UIColor lightGrayColor] : [UIColor blackColor];

}

@end

@interface YJYNotificationListController ()

@property (strong, nonatomic) NSMutableArray<SystemMessage*> *msgListArray;
@property (assign, nonatomic) u_int32_t pageNum;
@end

@implementation YJYNotificationListController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNotificationListController *)[UIStoryboard storyboardWithName:@"YJYNotification" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.msgListArray = [NSMutableArray array];
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    
    [SYProgressHUD show];

    [self loadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadNetworkData];

}

- (void)loadNetworkData {
    
    GetUserMsgByTypeReq*req = [GetUserMsgByTypeReq new];
    req.pageNo = self.pageNum;
    req.pageSize = 20;
    req.msgType = self.msgType;
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetMsgByType message:req controller:nil command:APP_COMMAND_SaasappgetMsgByType success:^(id response) {
        
        
        GetUserMsgByTypeRsp *rsp = [GetUserMsgByTypeRsp parseFromData:response error:nil];
        
        if (self.pageNum > 1) {
            
            if (self.msgListArray.count >= rsp.msgListArray_Count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                
                [self.msgListArray addObjectsFromArray:rsp.msgListArray];
                
            }
            
        }else {
            self.msgListArray = rsp.msgListArray;
            [self.tableView.mj_footer resetNoMoreData];
            
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.msgListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYNotificationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYNotificationListCell"];
    
    SystemMessage *systemMessage = self.msgListArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.systemMessage = systemMessage;
   
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SystemMessage *systemMessage = self.msgListArray[indexPath.row];
    
    if (systemMessage.state == 0) {

        [SYProgressHUD show];
        SystemMsgMarkAsReadReq *req = [SystemMsgMarkAsReadReq new];
        req.id_p = systemMessage.id_p;

        [YJYNetworkManager requestWithUrlString:SAASAPPUpdateMessageRead message:req controller:self command:APP_COMMAND_SaasappupdateMessageRead success:^(id response) {

            [SYProgressHUD hide];
            [self loadNetworkData];
            [self toOtherControllerWithMessage:systemMessage];
            


        } failure:^(NSError *error) {

        }];

    }else {

        [self toOtherControllerWithMessage:systemMessage];
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat addressWidth = self.tableView.frame.size.width - (35 + 17 + 17*2);
    SystemMessage *systemMessage = self.msgListArray[indexPath.row];

    CGFloat markExtraHeight = [systemMessage.content boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    return (100 - 17) + markExtraHeight;
}
- (void)toOtherControllerWithMessage:(SystemMessage *)systemMessage {
    
    
    if ([YJYProtocolManager viewControllerWithProtocol:systemMessage.nativeURL]) {
        
        id vc = [YJYProtocolManager viewControllerWithProtocol:systemMessage.nativeURL];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (systemMessage.URL && systemMessage.URL.length > 0) {
        
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = systemMessage.URL;
        vc.title = @"护理易";
        
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        YJYNotificationDetailController *vc = [YJYNotificationDetailController instanceWithStoryBoard];
        vc.systemMessage = systemMessage;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
}

@end
