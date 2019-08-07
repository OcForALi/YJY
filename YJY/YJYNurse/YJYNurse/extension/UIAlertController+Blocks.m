//
//  UIAlertController+Blocks.m
//  KateMcKay
//
//  Created by Bruce Li on 16/11/2.
//  No Comment © 2016年 XMind. All rights reserved.
//
// 

#import "UIAlertController+Blocks.h"

static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;

@interface UIViewController (UACB_Topmost)

- (UIViewController *)uacb_topmost;

@end

@implementation UIAlertController (Blocks)

+ (nonnull instancetype)showAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                   preferredStyle:(UIAlertControllerStyle)preferredStyle
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                    barButtonItem:(nullable UIBarButtonItem *)barButtonItem
                                   isPopPresenter:(BOOL)isPopPresenter
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:preferredStyle];
    
   
    __weak UIAlertController *controller = strongController;
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock) {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        [controller addAction:cancelAction];
    }
    
    if (destructiveButtonTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action){
                                                                      if (tapBlock) {
                                                                          tapBlock(controller, action, UIAlertControllerBlocksDestructiveButtonIndex);
                                                                      }
                                                                  }];
        [controller addAction:destructiveAction];
    }
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                if (tapBlock) {
                                                                    tapBlock(controller, action, UIAlertControllerBlocksFirstOtherButtonIndex + i);
                                                                }
                                                            }];
        [controller addAction:otherAction];
    }
    
    if (isPopPresenter) {
        [controller setModalPresentationStyle:UIModalPresentationPopover];
        controller.popoverPresentationController.barButtonItem = barButtonItem;
        controller.popoverPresentationController.sourceView = viewController.uacb_topmost.view;
        
    }
    
    [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil]; 
    return controller;
}

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                     alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [self showAlertInViewController:viewController
                                 withTitle:title
                                   message:message
                            preferredStyle:alertControllerStyle
                         cancelButtonTitle:cancelButtonTitle
                    destructiveButtonTitle:destructiveButtonTitle
                         otherButtonTitles:otherButtonTitles
                             barButtonItem:nil
                            isPopPresenter:NO
                                  tapBlock:tapBlock];
}


+ (nonnull instancetype)text_showAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                  doneButtonTitle:(nullable NSString *)doneButtonTitle
                                    textFieldText:(nullable NSString *)textFieldText
                                      placeholder:(nullable NSString *)placeholder
                                  secureTextEntry:(BOOL)secureTextEntry
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    __weak UIAlertController *controller = strongController;
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock) {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        [controller addAction:cancelAction];
    }
    
    if (doneButtonTitle) {
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneButtonTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){
                                                              if (tapBlock) {
                                                                  tapBlock(controller, action, UIAlertControllerBlocksDestructiveButtonIndex);
                                                              }
                                                          }];
        [controller addAction:doneAction];
    }
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder     = placeholder;
        textField.text            = textFieldText;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.secureTextEntry = secureTextEntry;
    }];
    
    [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil];
    return controller;
}

#pragma mark -

- (BOOL)visible
{
    return self.view.superview != nil;
}

- (NSInteger)cancelButtonIndex
{
    return UIAlertControllerBlocksCancelButtonIndex;
}

- (NSInteger)firstOtherButtonIndex
{
    return UIAlertControllerBlocksFirstOtherButtonIndex;
}

- (NSInteger)destructiveButtonIndex
{
    return UIAlertControllerBlocksDestructiveButtonIndex;
}

@end

@implementation UIViewController (UACB_Topmost)

- (UIViewController *)uacb_topmost
{
    UIViewController *topmost = self;
    
    UIViewController *above;
    while ((above = topmost.presentedViewController)) {
        topmost = above;
    }
    
    return topmost;
}

@end
