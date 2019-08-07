//
//  YJYMineCertificateController.m
//  YJYNurse
//
//  Created by wusonghe on 2017/7/11.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYMineCertificateController.h"

@interface YJYMineCertificateController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation YJYMineCertificateController

+ (instancetype)instanceWithStoryBoard {
    
    return (YJYMineCertificateController *)[UIStoryboard storyboardWithName:@"YJYMine" viewControllerIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imgView xh_setImageWithURL:[NSURL URLWithString:self.nursingCertificateURL]];
   
}



@end
