//
//  YHVideoCell.m
//  YHWanGuoTechnicians
//
//  Created by Zhu Wensheng on 2017/7/11.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHVideoCell.h"
#import "UIImageView+WebCache.h"
#import "YHCommon.h"
@interface YHVideoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *palyB;

@end
@implementation YHVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _videoImageView.layer.borderWidth  = 1;
    _videoImageView.layer.borderColor  = YHCellColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadDatasource:(NSDictionary*)info indexL:(NSUInteger)index{
    _palyB.tag = index;
    _nameL.text = info[@"name"];
    NSString *url = info[@"src"];
    NSString *ID = info[@"videoId"];
    _palyB.hidden = IsEmptyStr(ID);
    _videoImageView.userInteractionEnabled = !_palyB.hidden;
    url = IsEmptyStr(url)? info[@"img_src"] : url;
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"videoN"]];
    
}

@end
