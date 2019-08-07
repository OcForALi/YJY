//
//  UIAlertController+Blocks.h
//  KateMcKay
//
//  Created by Bruce Li on 16/11/2.
//  No Comment © 2016年 XMind. All rights reserved.
//
// 

#import <UIKit/UIKit.h>

typedef void (^UIAlertControllerCompletionBlock) (UIAlertController * __nonnull controller, UIAlertAction * __nonnull action, NSInteger buttonIndex);

@interface UIAlertController (Blocks)

//+ (nonnull instancetype)showAlertInViewController:(nonnull UIViewController *)viewController
//                                        withTitle:(nullable NSString *)title
//                                          message:(nullable NSString *)message
//                                   preferredStyle:(UIAlertControllerStyle)preferredStyle
//                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
//                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
//                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
//                                    barButtonItem:(nullable UIBarButtonItem *)barButtonItem
//                                   isPopPresenter:(BOOL)isPopPresenter
//                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)showAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                             alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

+ (nonnull instancetype)text_showAlertInViewController:(nonnull UIViewController *)viewController
                                       withTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 doneButtonTitle:(nullable NSString *)doneButtonTitle
                                    textFieldText:(nullable NSString *)textFieldText                                     placeholder:(nullable NSString *)placeholder
                                  secureTextEntry:(BOOL)secureTextEntry
                                        tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;


@property (readonly, nonatomic) BOOL visible;
@property (readonly, nonatomic) NSInteger cancelButtonIndex;
@property (readonly, nonatomic) NSInteger firstOtherButtonIndex;
@property (readonly, nonatomic) NSInteger destructiveButtonIndex;

@end
