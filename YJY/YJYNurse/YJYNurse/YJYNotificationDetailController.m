//
//  YJYNotificationDetailController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/27.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYNotificationDetailController.h"

@interface YJYNotificationDetailController ()

@property (weak, nonatomic) IBOutlet MDHTMLLabel *notificationLabel;

@end

@implementation YJYNotificationDetailController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYNotificationDetailController *)[UIStoryboard storyboardWithName:@"YJYNotification" viewControllerIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.notificationLabel.delegate = self;
    self.notificationLabel.htmlText =  self.systemMessage.content;
    
}



@end
