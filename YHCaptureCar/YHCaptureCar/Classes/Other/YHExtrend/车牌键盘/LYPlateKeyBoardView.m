//
//  LYPlateKeyBoardView.m
//  LYPlateKeyboard
//
//  Created by 乐浩 on 2017/11/9.
//  Copyright © 2017年 RBJR. All rights reserved.
//

#define kWidth  self.frame.size.width
#define kHeight self.frame.size.height
#define HEXCOLOR(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alp]

#import "LYPlateKeyBoardView.h"

@interface LYPlateKeyBoardView()
{
    UIView *_backView1;
    UIView *_backView2;
    UIView *_bottomView;
    UIButton *_btn;
}

@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;

@end

@implementation LYPlateKeyBoardView

- (NSArray *)array1 {
    if (!_array1) {
        _array1 = @[@"京",@"津",@"渝",@"沪",@"冀",@"晋",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"琼",@"川",@"贵",@"云",@"陕",@"甘",@"青",@"蒙",@"桂",@"宁",@"新",@"",@"藏",@"使",@"领",@"警",@"学",@"港",@"澳",@""];
    }
    return _array1;
}

- (NSArray *)array2 {
    if (!_array2) {
        _array2 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@""];
    }
    return _array2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = HEXCOLOR(0x000000, 0.1);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFAction:) name:@"abc" object:nil];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:recognizer];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, size.height * 0.33)];
    _backView1.backgroundColor = HEXCOLOR(0xd2d5da, 1);
    _backView1.hidden = NO;
    
    _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, size.height * 0.33)];
    _backView2.hidden = YES;
    _backView2.backgroundColor = HEXCOLOR(0xd2d5da, 1);
    
    [self addSubview:_backView1];
    [self addSubview:_backView2];
    
    int row = 4;
    int column = 10;
    CGFloat btnY = 4;
    CGFloat btnX = 2;
    CGFloat maginR = 5;
    CGFloat maginC = 10;
    CGFloat btnW = (size.width - maginR * (column -1) - 2 * btnX)/column;
    CGFloat btnH = (_backView1.frame.size.height - maginC * (row - 1) - 6) / row;
    CGFloat m = 12;
    CGFloat w = (size.width - 24 - 7 * btnW - 6 * maginR - 2 * btnX)/2;
    CGFloat mw = (size.width - 8 * maginR - 9 * btnW - 2 * btnX) / 2;
    NSLog(@"LY >> count - %zd", self.array1.count);
    for (int i = 0; i < self.array1.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i / column == 3) {
            if (i == 30) {
                 btn.frame = CGRectMake(btnX, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_abc"] forState:UIControlStateNormal];
                btn.enabled = NO;
                _btn = btn;
            }else if (i == 38) {
                btn.frame = CGRectMake(6 * (btnW + maginR) + btnW + w + m + m, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_over"] forState:UIControlStateNormal];
            }else {
                btn.frame = CGRectMake((i % column - 1)*(btnW + maginR) + w + m + btnX, btnY + 3 * (btnH + maginC), btnW, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            }
        }else {
            btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), btnW, btnH);
            [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:HEXCOLOR(0x23262F, 1) forState:UIControlStateNormal];
        [btn setTitle:self.array1[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
        [_backView1 addSubview:btn];
    }
    
    for (int i = 0; i < self.array2.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i >= 20 && i < 29) {
            
            btn.frame = CGRectMake(btnX + mw + (btnW + maginR) * (i % column), btnY + 2 * (btnH + maginC), btnW, btnH);
            [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            
        }else if (i >= 29) {
            if (i == 29) {
                btn.frame = CGRectMake(btnX, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_back"] forState:UIControlStateNormal];
            }else if (i == 37) {
                btn.frame = CGRectMake(6 * (btnW + maginR) + btnW + w + m + m + btnX, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_over"] forState:UIControlStateNormal];
            }else {
                btn.frame = CGRectMake((i % column)*(btnW + maginR) + w + m + btnX, btnY + 3 * (btnH + maginC), btnW, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            }
        }else {
            btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), btnW, btnH);
            [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:HEXCOLOR(0x23262F, 1) forState:UIControlStateNormal];
        [btn setTitle:self.array2[i] forState:UIControlStateNormal];
        
//        [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
        [_backView2 addSubview:btn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView1.frame;
        frame.origin.y = size.height - size.height * 0.33;
        _backView1.frame = frame;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView2.frame;
        frame.origin.y = size.height - size.height * 0.33;
        _backView2.frame = frame;
    }];
}

- (void)btn1Click:(UIButton *)sender {
    
    NSLog(@"LY >>> array1: - %@ -- tag - %zd", self.array1[sender.tag],sender.tag);
    _btn.enabled = YES;
    if (sender.tag == 30) {
        NSLog(@"点击了abc键");
        if (_backView2.hidden) {
            NSLog(@"_backView2 隐藏了");
            _backView1.hidden = YES;
            _backView2.hidden = NO;
        }else {
           sender.enabled = NO;
        }
        
    }else if (sender.tag == 38){
        NSLog(@"点击了删除键");
        if (_backView2.hidden) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick)]) {
                [self.delegate deleteBtnClick];
            }
        }
    }else {
        _backView1.hidden = YES;
        _backView2.hidden = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithString:)]) {
            [self.delegate clickWithString:self.array1[sender.tag]];
        }
    }
}

- (void)btn2Click:(UIButton *)sender {
    
    NSLog(@"LY >>> array2: - %@ -- tag - %zd", self.array2[sender.tag], sender.tag);
    if (sender.tag == 29) {
        NSLog(@"点击了abc键");
        _backView1.hidden = NO;
        _backView2.hidden = YES;
        
    }else if (sender.tag == 37) {
        NSLog(@"点击了删除键");
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick)]) {
            [self.delegate deleteBtnClick];
        }
        
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithString:)]) {
            [self.delegate clickWithString:self.array2[sender.tag]];
        }
    }
}

- (void)deleteEnd {
    _backView1.hidden = NO;
    _backView2.hidden = YES;
}

- (void)textFAction:(NSNotification *)notification {
    
    NSLog(@"LY >> info -- %@", notification.userInfo);
    NSString *str = notification.userInfo[@"text"];
    if (str.length == 0) {
        _btn.enabled = NO;
    }else if (str.length == 7) {
        [self hiddenView];
    }else {
       _btn.enabled = YES;
    }
}

- (void)hiddenView {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView1.frame;
        frame.origin.y = size.height;
        _backView1.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView2.frame;
        frame.origin.y = size.height;
        _backView2.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//销毁通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
