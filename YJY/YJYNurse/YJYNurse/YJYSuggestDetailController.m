//
//  YJYSuggestDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/5/18.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYSuggestDetailController.h"

@interface YJYSuggestDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@end

@implementation YJYSuggestDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYSuggestDetailController *)[UIStoryboard storyboardWithName:@"YJYSuggestion" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = [NSString stringWithFormat:@"反馈内容：%@",self.feedBackVO.feedBack.suggest];
    self.updateLabel.text = [NSString stringWithFormat:@"%@",self.feedBackVO.feedBack.createTime];

    if (self.feedBackVO.feedBack.reply.length > 0) {
        self.replyLabel.text = [NSString stringWithFormat:@"%@",self.feedBackVO.feedBack.reply];
    }
    if (self.feedBackVO.feedBack.replyTime.length > 0) {
        self.replyTimeLabel.text = [NSString stringWithFormat:@"小易回复：%@",self.feedBackVO.feedBack.replyTime];

    }
    
    
}

@end
