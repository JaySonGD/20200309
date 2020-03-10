//
//  YHFromViewCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 2018/3/12.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import "YHFromViewCell.h"

#import "YHCheckProjectModel.h"

//#import "MBProgressHUD+MJ.h"


@interface YHFromViewCell ()

    @property (weak, nonatomic) IBOutlet UIButton *addAndColseButton;
    
@property (weak, nonatomic) IBOutlet UITextField *valueTF;
    
@end

@implementation YHFromViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)textFieldChange:(UITextField *)sender{
    
}

- (IBAction)textFieldChangeEnd:(UITextField *)sender {
    
    NSInteger  val = [sender.text integerValue];
    
    if (self.model.min != self.model.max && (val > self.model.max || val < self.model.min)) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请输入数值在范围%ld~%ld内",(long)self.model.min,(long)self.model.max]];
        sender.text = @"";
        return;
    }

    
    if(!self.model.isSelect) self.model.isSelect = YES;
    self.model.name = sender.text;
    !(_textChange)? : _textChange(sender.text);

}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
    - (void)setModel:(YHlistModel *)model
    {
        _model = model;
        self.addAndColseButton.selected = model.isDelete;
        self.valueTF.text = model.name;
        self.valueTF.placeholder = model.placeholder;
        [self.addAndColseButton setTitle:[NSString stringWithFormat:@"  %@  ",model.unit] forState:UIControlStateNormal];
        //[self.addAndColseButton setTitle:[NSString stringWithFormat:@" %@ ",model.unit] forState:UIControlStateSelected];

    }
    
- (IBAction)addAndCloseClick:(UIButton *)sender {
    
    
    if(sender.isSelected){
        !(_remove)? : _remove(self.model);

    }else{
        !(_add)? : _add();

    }
}
    
@end
