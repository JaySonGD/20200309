//
//  ZZAlertViewController.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 30/10/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZZAlertActionStyle) {
    ZZAlertActionStyleDefault = 0,
    ZZAlertActionStyleCancel,
    ZZAlertActionStyleDestructive
};

NS_ASSUME_NONNULL_BEGIN

@interface ZZTextView : UIView
// default is nil. string is drawn 70% gray
@property(nullable, nonatomic,copy)   NSString *placeholder;

@property(nullable, nonatomic,copy)   NSString *text;

/**default is 80.*/
@property (nonatomic, assign) NSInteger maxLength;

@property (nonatomic, copy) void(^didChangeCharactersBlock)(UITextView *textField);

- (BOOL)becomeFirstResponder;


@end

@interface ZZAlertViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                    icon:(nullable UIImage *)icon
                                 message:(nullable NSString *)message;

- (void)addActionWithTitle:(nullable NSString *)title style:(ZZAlertActionStyle)style handler:(void (^ __nullable)(UIButton *action))handler;

- (void)addActionWithTitle:(nullable NSString *)title
                     style:(ZZAlertActionStyle)style
                   handler:(void (^ __nullable)(UIButton *action))handler
      configurationHandler:(void (^ __nullable)(UIButton *action))configurationHandler;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler didChangeCharacters:(void (^ __nullable)(UITextField *textField))didChangeHandler;

- (void)addTextViewWithConfigurationHandler:(void (^ __nullable)(ZZTextView *textField))configurationHandler didChangeCharacters:(void (^ __nullable)(UITextView *textField))didChangeHandler;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, readonly) NSArray<UIButton *> *buttons;

@property (nullable, nonatomic, readonly) NSArray<ZZTextView *> *textViews;

@end

NS_ASSUME_NONNULL_END
