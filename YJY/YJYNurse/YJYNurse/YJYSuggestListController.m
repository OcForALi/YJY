//
//  YJYSuggestListController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/5/18.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYSuggestListController.h"
#import "YJYSuggestDetailController.h"

@interface YJYSuggestListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (strong, nonatomic) FeedBackVO *feedBackVO;

@end

@implementation YJYSuggestListCell

- (void)setFeedBackVO:(FeedBackVO *)feedBackVO {

    _feedBackVO = feedBackVO;
    self.titleLabel.text = [NSString stringWithFormat:@"反馈内容：%@",feedBackVO.feedBack.suggest];
    if (feedBackVO.feedBack.reply.length > 0) {
        self.desLabel.text = [NSString stringWithFormat:@"小易回复：%@",feedBackVO.feedBack.reply];

    }else {
        self.desLabel.text = @"";
    }
    self.replyLabel.text = [NSString stringWithFormat:@"最新更新：%@",feedBackVO.newTimeStr];
    
}
@end


@interface YJYSuggestListController ()


@property (strong, nonatomic) GetFeedBackListRsp *rsp;

@end

@implementation YJYSuggestListController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYSuggestListController *)[UIStoryboard storyboardWithName:@"YJYSuggestion" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNetworkData];
    }];
    self.noDataTitle = @"您还没有反馈过意见喔~";
    
    [self loadNetworkData];
}

- (void)loadNetworkData {
    
    
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetFeedBackList message:nil controller:nil command:APP_COMMAND_SaasappgetFeedBackList success:^(id response) {
        
        
        self.rsp = [GetFeedBackListRsp parseFromData:response error:nil];
        
        
        [self reloadAllData];
        
        
    } failure:^(NSError *error) {
        
        [self reloadErrorData];
        
        
    }];
    
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.rsp.voArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YJYSuggestListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJYSuggestListCell" forIndexPath:indexPath];
    cell.feedBackVO = self.rsp.voArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJYSuggestDetailController *vc = [YJYSuggestDetailController instanceWithStoryBoard];
    FeedBackVO *feedBackVO = self.rsp.voArray[indexPath.row];

    vc.feedBackVO  = feedBackVO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat addressWidth = self.tableView.frame.size.width - (17*2 + 17*2);
    
    FeedBackVO *feedBackVO = self.rsp.voArray[indexPath.row];
    
    CGFloat markExtraHeight = [feedBackVO.feedBack.reply boundingRectWithSize:CGSizeMake(addressWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    if (markExtraHeight > 34) {
        markExtraHeight = 34;
    }
    
    return (140 - 17) + markExtraHeight;
}

@end
