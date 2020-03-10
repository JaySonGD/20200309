//
//  YHSetPartSearchView.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/31.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPartSearchView.h"
#import <Masonry.h>
#import "YHCommon.h"

@interface YHSetPartSearchView ()

@property (nonatomic, weak) UIButton *searchBtn;

@end

@implementation YHSetPartSearchView

- (instancetype)init{
    if (self = [super init]) {
        
        [self initSearchViewUI];
        
         [self initSetPartSearchViewBase];
    }
    return self;
}
- (void)initSetPartSearchViewBase{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.inputTf];
    
}

- (void)textFieldContentChange:(NSNotification *)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        NSLog(@"-------- chinese -----%@",toBeString);
        if ([self.delegate respondsToSelector:@selector(setPartSearchViewTextFieldStartEdit:)]) {
            [self.delegate setPartSearchViewTextFieldStartEdit:toBeString];
        }

    }else{  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        NSLog(@"--------English ---------%@",toBeString);
        if ([self.delegate respondsToSelector:@selector(setPartSearchViewTextFieldStartEdit:)]) {
            [self.delegate setPartSearchViewTextFieldStartEdit:toBeString];
        }
    }
}
- (void)initSearchViewUI{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(contentView.superview).offset(-10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@0);
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    self.searchBtn = searchBtn;
    [searchBtn setImage:[UIImage imageNamed:@"order_10"] forState:UIControlStateNormal];
    [contentView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.top.equalTo(@0);
        make.height.equalTo(contentView);
        make.width.equalTo(contentView.mas_height);
    }];
    
    UITextField *inputTf = [[UITextField alloc] init];
    self.inputTf = inputTf;
    [contentView addSubview:inputTf];
    [inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(searchBtn.mas_right).offset(5);
//        make.left.equalTo(@10);
        make.top.equalTo(@0);
        make.height.equalTo(contentView);
        make.right.equalTo(contentView).offset(-60);
    }];
    
//    UIButton *searchTitleBtn =  [[UIButton alloc] init];
//    searchTitleBtn.layer.cornerRadius = 4.0;
//    searchTitleBtn.layer.masksToBounds = YES;
//    [searchTitleBtn addTarget:self action:@selector(searchBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
//    searchTitleBtn.backgroundColor = YHNaviColor;
//    [searchTitleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    searchTitleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [searchTitleBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [contentView addSubview:searchTitleBtn];
//    [searchTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputTf);
//        make.right.equalTo(contentView).offset(2);
//        make.height.equalTo(inputTf);
//        make.width.equalTo(@60);
//    }];
    
}
- (void)setSearchBtnIsHides:(BOOL)isHide{
    self.searchBtn.hidden = isHide;
}
- (void)setTextFieldText:(NSString *)text{
    _inputTf.text = text;
}
- (void)setTextFieldPlaceHolder:(NSString *)placeHolder{
    _inputTf.placeholder = placeHolder;
}
#pragma mark - 搜索按钮点击 ---
- (void)searchBtnClickEvent{
    
    if (self.inputTf.text.length == 0) {
        return;
    }
    
    if (_searchBtnClickBlock) {
        _searchBtnClickBlock(self.inputTf.text);
    }
}

@end
