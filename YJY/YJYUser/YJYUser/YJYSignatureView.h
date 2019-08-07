//
//  YJYSignatureView.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/25.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DrawingModeDefault, // Plain drawing view.
    SignatureMode       // Drawing view with a x and line for signatures.
} DrawingMode;

@interface YJYSignatureView : UIView

// Stroke Color
@property (nonatomic) UIColor *strokeColor;
// Stroke width
@property (nonatomic) CGFloat strokeWidth;
// If the drawing view can be drawn on. By default canEdit is true.
@property (nonatomic) BOOL canEdit;
// Debug value to add a box around the path when drawing a existing path.
@property (nonatomic) BOOL debugBox;
// Current mode for the drawing view. See DrawingMode enum for options.
@property (nonatomic) DrawingMode mode;
// Refresh the current drawing mode.
- (void)refreshCurrentMode;
// Draw a CGPath that already exists. canEdit is set to false if this is called.
- (void)drawPath:(CGPathRef)path;
// Draw a UIBezierPath that already exists. canEdit is set to false if this is called.
- (void)drawBezier:(UIBezierPath *)path;
// Animate the current path.
- (void)animatePath;
// Clear current drawing view.
- (void)clearDrawing;
// Current UIBezierPath
- (UIBezierPath *)bezierPathRepresentation;
// Current UIImage of drawing view
- (UIImage *)imageRepresentation;
//redo
- (IBAction)undoDrawing:(id)sender;


@end
