//
//  YJYTextField.m
//  YJYUser
//
//  Created by wusonghe on 2017/4/27.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYTextField.h"

@implementation YJYTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 2, 1);
    
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
    
}

@end
