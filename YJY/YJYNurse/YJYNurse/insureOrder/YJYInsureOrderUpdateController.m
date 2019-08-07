//
//  YJYInsureOrderUpdateController.m
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYInsureOrderUpdateController.h"
#import "YJYInsureOrderRelationController.h"
#import "YJYInsureOrderContactUpdateController.h"

@interface YJYInsureOrderUpdateController ()

@end

@implementation YJYInsureOrderUpdateController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYInsureOrderUpdateController *)[UIStoryboard storyboardWithName:@"YJYInsureOrderUpdate" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    

}
- (IBAction)toNormalService:(id)sender {
    
    YJYInsureOrderRelationController *vc = [YJYInsureOrderRelationController instanceWithStoryBoard];
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.didDoneBlock = ^{
        
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }

        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)toSelfService:(id)sender {
    
    YJYInsureOrderContactUpdateController *vc = [YJYInsureOrderContactUpdateController instanceWithStoryBoard];
    vc.orderDetailRsp = self.orderDetailRsp;
    vc.didDoneBlock = ^{
        
        if (self.didDoneBlock) {
            self.didDoneBlock();
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
}



@end
