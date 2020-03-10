//
//  YHSetPartCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/5/30.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHSetPartCell.h"
#import "YHSetPartNameView.h"
#import "YHCustomLeftAndRightButton.h"

#import <Masonry.h>

@interface YHSetPartCell ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *numberL;

@property (nonatomic, assign) CGFloat initNumber;

@property (nonatomic, weak) YHSetPartNameView *view;

@property (nonatomic, weak) UIView *spaceView;
/** 数量textField对应的文本内容 */
@property (nonatomic, copy) NSString *numText;
/** 单位textField对应的文本 */
@property (nonatomic, copy) NSString *unitText;
@property (nonatomic, weak) UITextField *unitL;

@property (nonatomic, weak) UILabel *typeLB;
@property (nonatomic, weak) UIButton *typeBtn;
@property (nonatomic, weak) UITextField *brandTF;
@end

@implementation YHSetPartCell

-  (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self initSetPartCellUI];
        [self initBaseCell];
        
    }
    return self;
}
- (void)initBaseCell{
    
     self.initNumber = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRemoveBtn) name:@"YHSetPartCellHideRemoveBtn" object:nil];
   
    [self addObserver:self forKeyPath:@"numText" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"unitText" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.numberL];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChange:) name:@"UITextFieldTextDidChangeNotification" object:self.unitL];
}

- (void)textFieldContentChange:(NSNotification *)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
       
        if (textField == self.numberL) {
            self.numText = toBeString;
        }
        
        if (textField == self.unitL) {
            self.unitText = toBeString;
        }
        
    }else{  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (textField == self.numberL) {
            self.numText = toBeString;
        }
        
        if (textField == self.unitL) {
            self.unitText = toBeString;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSString *newText = change[NSKeyValueChangeNewKey];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setValue:self.indexPath forKey:@"indexPath"];
    
    if ([keyPath isEqualToString:@"numText"]) {
    
        [dict setValue:newText forKey:@"scalar"];
        [dict setValue:@"number" forKey:@"class"]; // 标识类型
    }
   
    if ([keyPath isEqualToString:@"unitText"]) {
    
        [dict setValue:newText forKey:@"partsUnit"];
        [dict setValue:@"unit" forKey:@"class"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldChangeNotification" object:nil userInfo:dict];
    
}
- (void)hideRemoveBtn{
    
    self.view.removeBtn.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.deleBtn.hidden = NO;
    }];
    
}

- (void)btnClick{
    !(_selectClassClickEvent)? : _selectClassClickEvent(self.indexPath);

}

- (void)initSetPartCellUI{
    
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    YHSetPartNameView *view = [[YHSetPartNameView alloc] init];
    self.view = view;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@62);
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
    }];
    __weak typeof(self)weakSelf = self;
    view.deleBtnPartNameClickBlock = ^{
        [weakSelf deleMethod];
    };
    view.removeBtnPartNameClickBlock = ^{
        [weakSelf removeMethod];
    };
    // 减号按钮
    UIButton *minusBtn = [[UIButton alloc] init];
    [minusBtn setImage:[UIImage imageNamed:@"setPartMinus"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_bottom).offset(31);
        make.left.equalTo(@20);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    // 数量
    UITextField *numberL = [[UITextField alloc] init];
    numberL.delegate = self;
    self.numberL =numberL;
    numberL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numberL];
    [numberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minusBtn.mas_right);
        make.width.equalTo(@53);
        make.height.equalTo(minusBtn);
        make.top.equalTo(minusBtn);
    }];
    // 加号➕按钮
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage imageNamed:@"setPartAdd"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minusBtn);
        make.left.equalTo(numberL.mas_right);
        make.height.equalTo(minusBtn);
        make.width.equalTo(minusBtn);
    }];
    // 单位
    UITextField *unitL = [[UITextField alloc] init];
    unitL.font = [UIFont systemFontOfSize:16.0];
    self.unitL = unitL;
    unitL.delegate = self;
    unitL.placeholder = @"请输入单位";
    [self.contentView addSubview:unitL];
    [unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minusBtn);
        make.left.equalTo(addBtn.mas_right).offset(5);
        make.height.equalTo(minusBtn);
        make.width.equalTo(@100);
    }];
    
    //
    UILabel *typeLB = [[UILabel alloc] init];
    [self.contentView addSubview:typeLB];
    _typeLB = typeLB;
    typeLB.text = @"类别";
    
    [typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minusBtn.mas_bottom).offset(5);
        make.left.equalTo(@20);
        //make.width.equalTo(@34);
        make.height.equalTo(@35);
    }];
    
    UIButton *typeBtn = [YHCustomLeftAndRightButton buttonWithType:UIButtonTypeCustom];
    [typeBtn setTitle:@"5555" forState:UIControlStateNormal];
    [typeBtn setImage:[UIImage imageNamed:@"me_7"] forState:UIControlStateNormal];
    [typeBtn setTitleColor:YHColorWithHex(0x575757) forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:typeBtn];
    _typeBtn = typeBtn;
    [typeBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(typeLB.mas_centerY);
        make.right.equalTo(@(-20));
        make.height.equalTo(typeLB.mas_height);
    }];
    
    
    
    UILabel *brandLB = [[UILabel alloc] init];
    [self.contentView addSubview:brandLB];
    brandLB.text = @"品牌";
    [brandLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLB.mas_bottom);
        make.left.equalTo(@20);
        //make.width.equalTo(@34);
        make.height.equalTo(@35);
    }];

    
    UITextField *brandTF = [[UITextField alloc] init];
    [self.contentView addSubview:brandTF];
    brandTF.textColor = YHColorWithHex(0x575757);
    brandTF.backgroundColor = YHColorWithHex(0xF2F2F2);
    brandTF.textAlignment = NSTextAlignmentRight;
    brandTF.borderStyle = UITextBorderStyleRoundedRect;
    self.brandTF = brandTF;
    [brandTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    [brandTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(brandLB.mas_centerY);
        make.right.equalTo(@(-20));
        make.width.equalTo(@130);
        make.height.equalTo(@30);
    }];

    
    ///
    
    UIView *spaceView = [[UIView alloc] init];
    self.spaceView = spaceView;
    spaceView.backgroundColor = YHColorWithHex(0xF2F2F2);
    [self.contentView addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(@124);
        make.bottom.mas_equalTo(spaceView.superview.mas_bottom);
        make.left.equalTo(@0);
        make.height.equalTo(@10);
        make.width.equalTo(spaceView.superview);
    }];
}
- (void)textChange:(UITextField *)sender{
    self.infoDict[@"brand"] = sender.text;
}
- (void)setSpaceViewHide:(BOOL)isHide{
    self.spaceView.hidden = isHide;
}

- (void)setInfoDict:(NSMutableDictionary *)infoDict{
    _infoDict = infoDict;
    
    self.initNumber = [infoDict[@"scalar"] floatValue];
    self.brandTF.text = infoDict[@"brand"];
    self.brandTF.userInteractionEnabled = YES;

    NSLog(@"info_____%@",infoDict);//
    // 配件
    if (self.type == YHSetPartCellParts) {
        self.numberL.text = [NSString stringWithFormat:@"%.1f",self.initNumber];
        NSString *partsTypeName = infoDict[@"partsTypeName"];
        [self.typeBtn setTitle:IsEmptyStr(partsTypeName)? @"   ":partsTypeName forState:UIControlStateNormal];
        [self.typeLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
        }];
        self.typeBtn.hidden = NO;
        
        if ([partsTypeName isEqualToString:@"原厂件"]) {
            self.brandTF.userInteractionEnabled = NO;
            self.infoDict[@"brand"] = @"原厂";
            self.brandTF.text = infoDict[@"brand"];
        }else{
            //self.brandTF.userInteractionEnabled = YES;
        }
    }
    // 耗材
    if (self.type == YHSetPartCellExpend) {
        self.numberL.text = [NSString stringWithFormat:@"%.2f",self.initNumber];
        [self.typeLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.typeBtn.hidden = YES;


    }
    
    self.view.textL.text = infoDict[@"partsName"];
    self.unitL.text = infoDict[@"partsUnit"];
}
#pragma mark - UIButton_Event ---
- (void)removeMethod{
    if (_removeBtnClickBlock) {
        _removeBtnClickBlock(self, self.indexPath);
    }
}
- (void)deleMethod{
    
    if (_deleBtnClickBlock) {
        _deleBtnClickBlock(self,self.indexPath);
    }
}
- (void)minusMethod{
    
    self.initNumber = [self.numberL.text floatValue];
    _initNumber--;
    if (_initNumber < 0) {
        _initNumber = 0;
    }
    // 配件
    if (self.type == YHSetPartCellParts) {
        self.numberL.text = [NSString stringWithFormat:@"%.1f",_initNumber];
    }
    // 耗材
    if (self.type == YHSetPartCellExpend) {
        self.numberL.text = [NSString stringWithFormat:@"%.2f",_initNumber];
    }
    self.numText = self.numberL.text;
}
- (void)addMethod{
    
     self.initNumber = [self.numberL.text floatValue];
    _initNumber++;
    // 配件
    if (self.type == YHSetPartCellParts) {
         self.numberL.text = [NSString stringWithFormat:@"%.1f",_initNumber];
    }
    // 耗材
    if (self.type == YHSetPartCellExpend) {
        self.numberL.text = [NSString stringWithFormat:@"%.2f",_initNumber];
    }
    self.numText = self.numberL.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.numberL) {
        if (![self isNumberForString:string] && string.length) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isNumberForString:(NSString *)str{
    
    NSString *expressStr = @"^[0-9.]{1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expressStr];
    BOOL isNumber = [predicate evaluateWithObject:str];
    return isNumber;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.numberL) {
        if (self.type == YHSetPartCellParts) {
            textField.text = [NSString stringWithFormat:@"%.1f",[textField.text floatValue]];
        }
        
        if (self.type == YHSetPartCellExpend) {
            textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
        }
        
        self.numText = textField.text;
    }
    
    if (textField == self.unitL) {
        self.unitText = textField.text;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
