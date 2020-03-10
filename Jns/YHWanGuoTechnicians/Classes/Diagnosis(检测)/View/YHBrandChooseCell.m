//
//  YHBrandChooseCell.m
//  YHWanGuoTechnicians
//
//  Created by liusong on 2018/3/10.
//  Copyright © 2018年 Zhu Wensheng. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "YHBrandChooseCell.h"

@interface YHBrandChooseCell ()

@property(nonatomic,strong)UILabel *labelName; //标题
@property(nonatomic,strong)UIImageView *imageHead;  //头像

@end

@implementation YHBrandChooseCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        self.imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, 30, 50)];
//        self.layer.cornerRadius = 20;
//        self.imageHead.layer.masksToBounds = YES;
        self.imageHead.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageHead];
        //列表中的名称
        self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageHead.frame)+10, 20, 300, 30)];

        self.labelName.textColor = [UIColor blackColor];
        self.labelName.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.labelName];
    }
    return self;
}

-(void)setBrandModel:(YHBrandModel *)brandModel{
    _brandModel = brandModel;
    NSString *url = [NSString stringWithFormat:@"https://www.wanguoqiche.com/files/logo/%@.jpg", brandModel.icoName];
    [self.imageHead sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"车辆背面"]];
    self.labelName.text = brandModel.brandName;
}

@end
