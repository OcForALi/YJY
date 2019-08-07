//
//  UIButton+Activity.m
//  Scriptive
//
//  Created by Josh Justice on 7/21/14.
//  Copyright (c) 2014 Scriptive. All rights reserved.
//

#import "UIButton+Activity.h"
#import <objc/runtime.h>

#define USE_SPINNER_KEY @"useSpinner"
#define SPINNER_KEY @"spinner"

@interface UIButton (ActivityPrivate)

@property (copy, nonatomic) NSString *lastTitle;

@end

@implementation UIButton (Activity)

static char lastTitleKey;
@dynamic spinner;

- (NSString *)lastTitle {

    return objc_getAssociatedObject(self, &lastTitleKey);

}
- (void)setLastTitle:(NSString *)lastTitle {
    
    objc_setAssociatedObject(self, &lastTitleKey, lastTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);

    
}


-(BOOL)getUseActivityIndicator {
    BOOL result = NO;
    id useObject = objc_getAssociatedObject(self, USE_SPINNER_KEY);
    if ( [useObject isKindOfClass:[NSNumber class] ] )
    {
        NSNumber *useNumber = useObject;
        result = [useNumber boolValue];
    }
    return result;
}


-(UIActivityIndicatorView *)spinner {
    UIActivityIndicatorView *result;
    
    id spinnerObject = (UIActivityIndicatorView*)objc_getAssociatedObject(self, SPINNER_KEY);
    if ( [spinnerObject isKindOfClass:[UIActivityIndicatorView class] ] )
    {
        result = spinnerObject;
    } else
    {
        // lazy load
        result = [ [UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [result setCenter:CGPointMake(self.bounds.size.width/2 + ((self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) ? self.bounds.size.width/2 : 0),
                                    self.bounds.size.height/2)];
        objc_setAssociatedObject(self, SPINNER_KEY, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

-(void)updateActivityIndicatorVisibility {
//    if(!self.useActivityIndicator) {
//        return;
//    }
    
    self.lastTitle = self.currentTitle;
    [self setTitle:@"" forState:0];
    self.enabled = NO;
    
    
    UIActivityIndicatorView *spinner = self.spinner;

    if( !self.enabled ) { // show spinner
        [spinner startAnimating];
        [self addSubview:spinner];
    } else { // self.enabled == true; hide spinner
        if( spinner ) {
            [spinner removeFromSuperview];
            [spinner stopAnimating];
        }
    }
}

- (void)stopActivityIndicatorVisibilityWithIsClear:(BOOL)isClear {


    self.enabled = YES;
    (isClear) ?  nil : [self setTitle:self.lastTitle forState:0];
    
    UIActivityIndicatorView *spinner = self.spinner;
    
    if( spinner ) {
        [spinner removeFromSuperview];
        [spinner stopAnimating];
    }
    
}

- (void)stopActivityIndicatorVisibility {
    
    [self stopActivityIndicatorVisibilityWithIsClear:YES];
    
}

@end
