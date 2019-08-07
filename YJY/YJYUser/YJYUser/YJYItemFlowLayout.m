//
//  YJYItemFlowLayout.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYItemFlowLayout.h"

@implementation YJYItemFlowLayout

- (void)prepareLayout {

    
    [super prepareLayout];
    
    CGFloat width = IS_IPHONE_5 ? 50 : 60;
    CGFloat height = 60;
    
    self.itemSize = CGSizeMake(width, height);
    
    
    self.minimumLineSpacing = 26;
//    self.minimumInteritemSpacing = IS_IPHONE_5 ? 5: 5;
    self.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
}

@end
