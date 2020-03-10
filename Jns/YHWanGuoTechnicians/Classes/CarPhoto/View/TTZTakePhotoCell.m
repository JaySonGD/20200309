//
//  TTZPhotoCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 4/7/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "TTZTakePhotoCell.h"

#import "TTZSurveyModel.h"
#import "TTZDBModel.h"


@interface TTZTakePhotoCell ()
@property (weak, nonatomic) IBOutlet UIButton *imageProgressBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@end

@implementation TTZTakePhotoCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.nameBtn.titleLabel.numberOfLines = 2;
    self.nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setModel:(TTZSurveyModel *)model{
    _model = model;
    
    self.imageProgressBtn.selected = model.isSelect;
    self.nameBtn.selected = model.isSelect;
    
    UIColor *bColor = model.isSelect? [UIColor whiteColor] : YHColorWithHex(0x666666);
    YHLayerBorder(self.imageProgressBtn, bColor, 2);
    
    [self.nameBtn setTitle:model.projectName forState:UIControlStateNormal];
    [self.nameBtn setTitle:model.projectName forState:UIControlStateSelected];
    NSInteger count = model.dbImages.count;
//    if (model.dbImages.count && [model.dbImages.lastObject.image isEqual:[UIImage imageNamed:@"otherAdd"]]) {
//        count--;
//    }
    if (model.dbImages.count && IsEmptyStr(model.dbImages.lastObject.fileId)) {
        count--;
    }


    [self.imageProgressBtn setTitle:[NSString stringWithFormat:@"%lu/5",count] forState:UIControlStateNormal];
    [self.imageProgressBtn setTitle:[NSString stringWithFormat:@"%lu/5",count] forState:UIControlStateSelected];
}

@end
