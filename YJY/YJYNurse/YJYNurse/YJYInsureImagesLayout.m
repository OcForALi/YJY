
//
//  YJYInsureImagesLayout.m
//  YJYNurse
//
//  Created by wusonghe on 2017/11/13.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "YJYInsureImagesLayout.h"

@implementation YJYInsureImagesLayout
- (void)prepareLayout {
    
    
    [super prepareLayout];
    
//    CGFloat numberOfRow = 3;
    
    CGFloat width = 97 - (IS_IPHONE_5 ? 25 : 0) - (IS_IPHONE_6 ? 10 : 0);//self.collectionView.frame.size.width/numberOfRow-(numberOfRow - 1)*margin;
    CGFloat height = 97 - (IS_IPHONE_5 ? 30 : 0)  - (IS_IPHONE_6 ? 10 : 0);
    
    CGFloat margin = 10 - (IS_IPHONE_5 ? 5 : 0); ;// (self.collectionView.frame.size.width-numberOfRow*width)/(numberOfRow+1);
    
    self.itemSize = CGSizeMake(width, height);
    
    self.minimumLineSpacing = margin;
    self.minimumInteritemSpacing = margin;
    
    self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
}

@end
