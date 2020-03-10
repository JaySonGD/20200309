//
//  YHRichesCell.m
//  YHCaptureCar
//
//  Created by liusong on 2018/9/13.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHRichesCell.h"

@interface YHRichesCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *premptL;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end

@implementation YHRichesCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setInfo:(NSDictionary *)info{
    
    _info = info;
    self.titleL.text = info[@"title"];
    self.premptL.text = info[@"subtitle"];
    
    [self.titleL sizeToFit];
    [self.premptL sizeToFit];
}
- (void)setPremptText:(NSString *)text{
    _premptL.text = text;
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}
@end
