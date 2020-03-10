//
//  YHHomeFunctionCell.m
//  YHWanGuoTechnician
//
//  Created by Zhu Wensheng on 2017/3/13.
//  Copyright © 2017年 Zhu Wensheng. All rights reserved.
//

#import "YHHomeFunctionCell.h"
#import "YHFunctionsEditerController.h"
#import "YHHomeViewController.h"
#import <UIImageView+WebCache.h>

extern NSString *const notificationFunction;
@interface YHHomeFunctionCell ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *icons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *strs;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *boxs;

- (IBAction)functionAction:(id)sender;

@property (strong, nonatomic)NSArray *items;
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation YHHomeFunctionCell

- (void)loadDatasource:(NSArray*)source
{
    self.items = source;
    
    [_boxs enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (source.count > idx) {
            
            view.hidden = NO;
            YHHomeModel *model = self.items[idx];
            
            //图片
            UIImageView *imgView = _icons[idx];
//            [imgView setImage:[UIImage imageNamed:model.code]];

//        NSString *iconUrl = [NSString stringWithFormat:@"%@files/jnsMenuIcon/%@",SERVER_HOME_ICON_IMAGE_URL,model.iconName];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
            //标题
            UILabel *lable = _strs[idx];
            [lable setText:model.title];
        }else{
            view.hidden = YES;
        }
    }];
}

- (IBAction)functionAction:(UIButton*)sender
{    
    YHHomeModel *model = self.items[sender.tag];
//    NSDictionary *valus = [YHHomeViewController getHomePageKey];
//    if ([model.status isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationFunction object:[YHHomeViewController getHomePageNumberWithKey:model.code] userInfo:model];
//    } else {
//        [MBProgressHUD showSuccess:model.msg];
//    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    dispatch_async(dispatch_get_main_queue(), ^{
        // 第一行
        if (_indexPath.row == 2) {
            [self.containView setRounded:self.containView.bounds corners:UIRectCornerTopRight | UIRectCornerTopLeft radius:8.0];
        }
        
        // 最后一行
        if (_indexPath.row == self.rows - 1) {
            [self.containView setRounded:self.containView.bounds corners:UIRectCornerBottomRight | UIRectCornerBottomLeft radius:8.0];
        }
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
