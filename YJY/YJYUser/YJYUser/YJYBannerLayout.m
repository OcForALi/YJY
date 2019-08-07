//
//  YJYBannerLayout.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/25.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYBannerLayout.h"

@implementation YJYBannerLayout


- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = self.collectionView.frame.size;
    self.minimumInteritemSpacing = 0;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5;
    
    NSArray *layoutAttributesForElements = [self layoutAttributesForElementsInRect:self.collectionView.bounds];
    
    UICollectionViewLayoutAttributes *layoutAttributes = layoutAttributesForElements.firstObject;
    
    for (UICollectionViewLayoutAttributes *layoutAttributesForElement in layoutAttributesForElements) {
        if (layoutAttributesForElement.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        
        CGFloat distance1 = layoutAttributesForElement.center.x - proposedContentOffsetCenterX;
        CGFloat distance2 = layoutAttributes.center.x - proposedContentOffsetCenterX;
        
        if (fabs(distance1) < fabs(distance2)) {
            layoutAttributes = layoutAttributesForElement;
        }
    }
    
    if (layoutAttributes != nil) {
        return CGPointMake(layoutAttributes.center.x - CGRectGetWidth(self.collectionView.bounds) * 0.5, proposedContentOffset.y);
    }
    
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}
@end
