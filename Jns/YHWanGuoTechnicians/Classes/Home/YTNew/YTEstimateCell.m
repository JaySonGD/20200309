//
//  YTEstimateCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTEstimateCell.h"

@interface YTEstimateCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *title;

@end

@implementation YTEstimateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self.price addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.contentView.subviews.firstObject addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
}


- (void)tapAction{
    [self.price becomeFirstResponder];
}


- (void)setAssess_info:(NSMutableDictionary *)assess_info{
    _assess_info = assess_info;
    self.price.text = assess_info[@"car_inspection_evaluation_price"];
    self.price.enabled = [assess_info[@"edit_status"] boolValue];
    
//    [self.title setTitle:@"技师评估价" forState:UIControlStateNormal];
    
}
//- (void)textChange{
//    self.assess_info[@"car_inspection_evaluation_price"] = self.price.text;
//    NSLog(@"%s", __func__);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isHaveDian = YES;
    
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    [MBProgressHUD showError:@"第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            
            if (single == '0' && [textField.text hasPrefix:@"0"] && range.location == 1) {
                [MBProgressHUD showError:@"请输入非0数字"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
                
            }
            
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [MBProgressHUD showError:@"已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    NSString *tt = [textField.text substringFromIndex:ran.location + 1];
                    if (range.location <= ran.location || tt.length < 2){
                        return YES;
                    }else{
                        [MBProgressHUD showError:@"最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [MBProgressHUD showError:@"输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
  }

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if([textField.text hasSuffix:@"."]){
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
    
    if([textField.text hasPrefix:@"0"] && ![textField.text  hasPrefix:@"0."]){
        textField.text = [textField.text substringFromIndex:1];
    }
}


@end
