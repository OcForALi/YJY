//
//  YJYNotificationController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/2.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNotificationController.h"

#import "YJYNotificationListController.h"

@interface YJYNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *shadowBg;

@property (weak, nonatomic) IBOutlet UIView *vLine;
@property (strong, nonatomic) SystemMessageVO *systemMessage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *numButton;
@end

@implementation YJYNotificationCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.shadowBg yjy_setTopShadow];
    
}

- (void)setSystemMessage:(SystemMessageVO *)systemMessage {
    
    _systemMessage = systemMessage;
    
    self.titleLab.text = systemMessage.title;
    self.timeLab.text = systemMessage.createTime;
    self.desLab.htmlText = systemMessage.content;
    
    self.numButton.hidden = systemMessage.num == 0;
    [self.numButton setTitle:[NSString stringWithFormat:@"%@",@(systemMessage.num)] forState:0];
    
}

@end


@interface YJYNotificationController ()<MDHTMLLabelDelegate>

@property (assign, nonatomic) u_int32_t pageNum;
@property (strong, nonatomic) GetSystemMsgRsp *rsp;
@property (strong, nonatomic) NSMutableArray<SystemMessageVO*> *msgListArray;
@end

@implementation YJYNotificationController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNotificationController *)[UIStoryboard storyboardWithName:@"YJYNotification" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_X) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        
    }
    self.msgListArray = [NSMutableArray array];
    
    
    if (!self.isPushController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(close)];//[UIBarButtonItem itemWithImage:@"app_back_icon" highImage:@"app_back_icon" target:self action:@selector(backAction:)];
        
    }

    
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

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self navigationBarNotAlphaWithBlackTint];
   
    [self loadNetworkData];
    
//    self.isFromPush ? [self navigationBarNotAlphaWithBlackTint] : [self navigationBarAlphaWithWhiteTint];
    

    
}

- (void)loadNetworkData {
    
  
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetMsgList message:nil controller:nil command:APP_COMMAND_SaasappgetMsgList success:^(id response) {
        
        
        GetMsgListRsp *rsp = [GetMsgListRsp parseFromData:response error:nil];
        
        self.msgListArray = rsp.msgListArray;
        if (self.didLoaded) {
            self.didLoaded(rsp.msgListArray.count > 0);
        }
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

#pragma mark -  backAction

- (IBAction)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.msgListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YJYNotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YJYNotificationCell"];
    cell.systemMessage = self.msgListArray[indexPath.row];
    cell.desLab.delegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    SystemMessage *systemMessage = self.msgListArray[indexPath.row];
//    
//    CGFloat width = self.tableView.frame.size.width - 85;
//    
//    CGFloat height = [MDHTMLLabel sizeThatFitsHTMLString:systemMessage.content withFont:[UIFont systemFontOfSize:15] constraints:CGSizeMake(width, 0) limitedToNumberOfLines:0 autoDetectUrls:NO];
    
    
    return 66;// + height;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SystemMessageVO *systemMessage = self.msgListArray[indexPath.row];
    YJYNotificationListController *vc = [YJYNotificationListController instanceWithStoryBoard];
    vc.msgType = systemMessage.msgType;
    vc.title = systemMessage.title;
    
    
  
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL {
    
    if ([URL.absoluteString containsString:@"tel"]) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if ([URL.absoluteString containsString:@"http"]) {
        YJYWebController *vc = [YJYWebController new];
        vc.urlString = URL.absoluteString;
        vc.title = @"护理易";

        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
