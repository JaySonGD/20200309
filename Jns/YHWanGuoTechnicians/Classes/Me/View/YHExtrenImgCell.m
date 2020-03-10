//
//  YHExtrenImgCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/11/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHExtrenImgCell.h"
#import "UIImageView+WebCache.h"
@interface YHExtrenImgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *buttonB;

@end
@implementation YHExtrenImgCell
- (void)loadData:(NSString*)urlStr image:(UIImage*)image isAdd:(BOOL)isadd index:(NSUInteger)index{
    _buttonB.hidden = isadd;
    _buttonB.tag = index;
    if (image) {
        _img.image = image;
    }else if(urlStr){
        [_img sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }else{
        _img.image = [UIImage imageNamed:@"wAddI"];
    }
}
@end
