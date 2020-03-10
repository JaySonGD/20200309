//
//  YHDepthEditCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/5/3.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHDepthEditCell.h"

NSString *const notificationProjectDel = @"YHNotificationProjectDel";
@interface YHDepthEditCell ()
@property (weak, nonatomic) IBOutlet UILabel *modelL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
- (IBAction)delAction:(id)sender;
@property (nonatomic)NSInteger index;
@property (weak, nonatomic)NSMutableDictionary *dataSource;
@property (weak, nonatomic) IBOutlet UITextField *detailFT;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UITextField *numFT;
@property (weak, nonatomic) IBOutlet UIImageView *aroowIG;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UIButton *delB;
@property (weak, nonatomic) IBOutlet UIButton *actionB;
@property (weak, nonatomic) IBOutlet UITextField *unitFT;
@property (weak, nonatomic) IBOutlet UITextField *remarksFT;
@property (weak, nonatomic) IBOutlet UILabel *remarkL;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceL;
@property (weak, nonatomic) IBOutlet UIButton *partSelB;
@end

@implementation YHDepthEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadDatasource:(NSMutableDictionary*)info index:(NSInteger)index isRepair:(BOOL)isRepair isRepairModel:(BOOL)isRepairModel isCloud:(BOOL)isCloud isRepairPrice:(BOOL)isRepairPrice{
    
    NSNumber *type = info[@"type"];
    if (type.integerValue == 1) {
        _numFT.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _numFT.keyboardType = UIKeyboardTypeDecimalPad;
    }
    _actionB.tag = index;
    _partSelB.tag = index;
    self.dataSource = info;
    _delB.hidden = isCloud;
    _detailFT.enabled = !isCloud;
    _unitFT.enabled = !isCloud;
    _remarksFT.enabled = !isCloud;
    _partSelB.hidden = !isRepairPrice || isRepairModel ;
    if (isRepair) {
        if (!isRepairModel) {
            _titleL.text = @"材料名";
            _modelL.text = info[@"partsName"];
            _descL.text = @"数量";
            _typeL.text = @"型号";
            _detailFT.hidden = NO;
            _actionB.hidden = YES;
            _aroowIG.hidden = YES;
            _numFT.hidden = NO;
            NSNumber *scalar = info[@"scalar"];
            if (scalar && scalar.floatValue > 0) {
                _numFT.text = scalar.description;
            }else{
                _numFT.text = @"";
            }
            _detailFT.placeholder = @"请输入型号";
            if (isRepairPrice) {
                if (info[@"modelNumberList"]) {
                    _detailFT.hidden = YES;
                    _partSelB.hidden = NO;
                    _numFT.enabled = YES;
                    _numFT.placeholder = @"请输入数量";
                }else{
                    _detailFT.hidden = NO;
                    _partSelB.hidden = YES;
                    _detailFT.placeholder = @"";
                    _numFT.enabled = NO;
                    _numFT.placeholder = @"";
                }
                _detailFT.enabled = NO;
                _sellPriceL.text =@"成本";
                _remarkL.text =@"单价";
                _unitFT.placeholder = @"请输入";
                _remarksFT.placeholder = @"请输入";
                _unitFT.enabled = NO;
                _unitFT.text = ((NSString*)info[@"sellPrice"]).description;
                _remarksFT.text = info[@"shopPrice"];
                if (info[@"modelNumber"] && ![info[@"modelNumber"] isEqualToString:@""]) {
                    [_partSelB setTitle:info[@"modelNumber"] forState:UIControlStateNormal];
                }else{
                    [_partSelB setTitle:@"请选择" forState:UIControlStateNormal];
                }
            }else{
                
                _unitFT.text = info[@"partsUnit"];
                _remarksFT.text = info[@"partsDesc"];
            }
            _detailFT.text = info[@"modelNumber"];
        }else{
            _titleL.text = info[@"className"];
            _modelL.text = info[@"repairProjectName"];
            NSNumber *sel = info[@"sel"];
            _typeL.text = @"报价";
            _aroowIG.hidden = YES;
            _actionB.hidden = NO;
            _detailFT.hidden = NO;
            _detailFT.text = ((NSString*)info[@"quote"]).description;
            _detailFT.placeholder = @"请输入报价";
            _numFT.hidden = YES;
        }
    }else{
        _titleL.text = @"项目名称";
        _modelL.text = info[@"projectName"];
        _detailFT.text = info[@"desc"];
    }
    
    
    _index = index;
}

- (void)loadDatasource:(NSString*)title desc:(NSString*)desc index:(NSInteger)index{
    _modelL.text = title;
    _descL.text = desc;
    _index = index;
    
}
- (IBAction)delAction:(id)sender {
    
    [[NSNotificationCenter
      defaultCenter]postNotificationName:notificationProjectDel
     object:Nil
     userInfo:@{@"index" : @(_index)}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_detailFT == textField) {
        [_dataSource setObject:textField.text forKey:@"desc"];
        [_dataSource setObject:textField.text forKey:@"modelNumber"];
        [_dataSource setObject:textField.text forKey:@"quote"];
    }else if (_numFT == textField) {
        
        NSString *scalar = textField.text;
        [_dataSource setObject:[NSNumber numberWithFloat:scalar.floatValue] forKey:@"scalar"];
    }else if (_unitFT == textField) {
        [_dataSource setObject:textField.text forKey:@"partsUnit"];
    }else if (_remarksFT == textField) {
        [_dataSource setObject:textField.text forKey:@"partsDesc"];
        [_dataSource setObject:textField.text forKey:@"shopPrice"];
    }
}
@end
