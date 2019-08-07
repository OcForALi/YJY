//
//  YJYOrderServerCell.m
//  YJYNurse
//
//  Created by wusonghe on 2017/6/15.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYOrderServerCell.h"

@implementation YJYOrderServerCell

- (void)setService:(NSString *)service {
    
    _service = service;
    self.titleLabel.text = service;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
