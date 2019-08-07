//
//  YJYItemFlowLayout.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/20.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYItemFlowLayout.h"

@implementation YJYItemFlowLayout

- (void)prepareLayout {

    
    [super prepareLayout];
    
    CGFloat width = self.collectionView.frame.size.width/2-1;
    CGFloat height = 155;
    
    self.itemSize = CGSizeMake(width, height);
    
    
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
}

@end
