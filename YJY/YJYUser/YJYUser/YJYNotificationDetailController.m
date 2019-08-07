//
//  YJYNotificationDetailController.m
//  YJYUser
//
//  Created by wusonghe on 2017/5/6.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYNotificationDetailController.h"
#import "YJYWebController.h"

@interface YJYNotficationdDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (strong, nonatomic) SystemMessage *systemMessage;

@end

@implementation YJYNotficationdDetailCell


- (void)setSystemMessage:(SystemMessage *)systemMessage {

    _systemMessage = systemMessage;
    
    self.titleLab.text = systemMessage.content;
    
    self.timeLab.text = systemMessage.createTimeStr;
    
    self.desLab.htmlText = systemMessage.content;
    
}



@end

@interface YJYNotificationDetailController ()<MDHTMLLabelDelegate>

@property(nonatomic, strong) NSMutableArray<SystemMessage*> *msgListArray;
@property (assign, nonatomic) uint32_t pageNum;

@end

@implementation YJYNotificationDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNotificationDetailController *)[UIStoryboard storyboardWithName:@"YJYNotification" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.msgListArray = [NSMutableArray array];
    
    //APPGetMsgList
    self.pageNum = 1;
    
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNum = 1;
        [weakSelf loadNetworkData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum ++;
        [weakSelf loadNetworkData];
    }];
    
    
    [self loadNetworkData];
    [SYProgressHUD show];
    
    
}

- (void)loadNetworkData {
    
    GetUserMsgByTypeReq *req =  [GetUserMsgByTypeReq new];
    req.msgType = self.msgType;
    req.pageNo = self.pageNum;
    
    [YJYNetworkManager requestWithUrlString:AppGetUserMsgByType message:req controller:self command:APP_COMMAND_AppGetUserMsgByType success:^(id response) {
        
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
        
        [SYProgressHUD hide];
        
    } failure:^(NSError *error) {
        [self reloadErrorData];

    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.msgListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YJYNotficationdDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYNotficationdDetailCell"];
    
    SystemMessage *systemMessage = self.msgListArray[indexPath.row];
    cell.systemMessage = systemMessage;
    cell.desLab.delegate = self;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SystemMessage *systemMessage = self.msgListArray[indexPath.row];

    if ([YJYProtocolManager viewControllerWithProtocol:systemMessage.nativeURL]) {
        
        id vc = [YJYProtocolManager viewControllerWithProtocol:systemMessage.nativeURL];
        [self.navigationController pushViewController:vc animated:YES];

    } else if (systemMessage.URL && systemMessage.URL.length > 0) {
        
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = systemMessage.URL;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        
      //  [SYProgressHUD showToCenterText:@"服务未开通"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SystemMessage *systemMessage = self.msgListArray[indexPath.row];
    
    CGFloat width = self.tableView.frame.size.width - 30;
    
    CGFloat height = [MDHTMLLabel sizeThatFitsHTMLString:systemMessage.content withFont:[UIFont systemFontOfSize:16] constraints:CGSizeMake(width, 0) limitedToNumberOfLines:0 autoDetectUrls:NO];
    
    
//    NSInteger lines = (NSInteger)(height / [UIFont systemFontOfSize:15].lineHeight);
    
    return 67 + height;// (lines - 1) * 18;
    
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

@end
