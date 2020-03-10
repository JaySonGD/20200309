
//
//  YTDiagnoseCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 18/12/2018.
//  Copyright © 2018 Zhu Wensheng. All rights reserved.
//

#import "YTDiagnoseCell.h"

#include "YTPlanModel.h"

@interface  YTDiagnoseCell()
@property (weak, nonatomic) IBOutlet UILabel *tilteLB;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UITextField *diagnoseTF;

@end

@implementation YTDiagnoseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clearResultAction:(id)sender {
    !(_clearResultBlock)? : _clearResultBlock();

    
}

- (IBAction)diagnoseSearchAction:(UIButton *)sender {
    
    !(_searchBlock)? : _searchBlock();

}


- (void)setModel:(YTCResultModel *)model{
    _model = model;
    self.tilteLB.text = IsEmptyStr(model.makeResult)? @"暂没有匹配到诊断结果" : model.makeResult;
    if (!model.isTechOrg) {
        self.removeBtn.hidden = YES;
    }else{
        if ([model.nextStatusCode isEqualToString:@"initialSurveyCompletion"] && !IsEmptyStr(model.makeResult)) {
            self.removeBtn.hidden = NO;
        }else{
            self.removeBtn.hidden = YES;
        }
    }
}


- (CGFloat)rowHeight:(YTCResultModel *)model{
    self.model = model;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    UIView *lastView;
    if (!model.isTechOrg) {
        lastView = self.tilteLB;
    }else{
        if ([model.nextStatusCode isEqualToString:@"initialSurveyCompletion"]) {
            lastView = IsEmptyStr(model.makeResult)? self.diagnoseTF : self.tilteLB;
        }else{
            lastView = self.tilteLB;
        }
    }
    
//    UIView *lastView = IsEmptyStr(model.makeResult)? self.diagnoseTF : self.tilteLB;
    
    return CGRectGetMaxY(lastView.frame) + 5;
}



@end
