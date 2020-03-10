
#import <UIKit/UIKit.h>

typedef void(^VerCodeViewBlock)(NSString *text);

@interface VerCodeView : UIView

@property (nonatomic, assign) UIKeyboardType keyBoardType;
@property (nonatomic, copy) VerCodeViewBlock block;

/*验证码的最大长度*/
@property (nonatomic, assign) NSInteger maxLenght;

@property (nonatomic, strong) UIColor *pointColor;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *defaultColor;


- (void)verCodeViewWithMaxLenght;

- (void)resetCode;

@end



@interface UIView (code)

@property (nonatomic) IBInspectable CGFloat cornerRadius;

/** 边框 */
@property (nonatomic) IBInspectable CGFloat borderWidth;

/** 边框颜色*/
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
