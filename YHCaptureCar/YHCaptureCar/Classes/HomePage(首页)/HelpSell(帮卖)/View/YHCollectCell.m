//
//  YHCollectCell.m
//  YHCaptureCar
//
//  Created by Jay on 2018/3/21.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCollectCell.h"
#import <UIImageView+WebCache.h>

#import "TTZCarModel.h"
#import "NSDate+BRAdd.h"

//#import "YHNetworkManager.h"

@interface YHCollectCell()
@property (weak, nonatomic) IBOutlet UIImageView *flagIV;
@property (weak, nonatomic) IBOutlet UIImageView *carPictureIV;
@property (weak, nonatomic) IBOutlet UILabel *carNameLB;
@property (weak, nonatomic) IBOutlet UIButton *useTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIButton *mileageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carPictureLeft;

@end

@implementation YHCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TTZCarModel *)model
{
    _model = model;
    self.carPictureLeft.constant = model.flag ? 21 : 16;
    
    self.flagIV.hidden = !model.flag;
    
//    NSString *carPictureURL = model.flag? [NSString stringWithFormat:@"%@%@",SERVER_JAVA_IMAGE_URL,model.carPicture] :[NSString stringWithFormat:@"%@%@",SERVER_JAVA_NonAuthentication_IMAGE_URL,model.carPicture];
    
    [self.carPictureIV sd_setImageWithURL:[NSURL URLWithString:model.carPicture] placeholderImage:[UIImage imageNamed:@"carPicture"]];

    self.carNameLB.text = model.carName;
    
    self.priceLB.text = model.price;//model.price.length ? [NSString stringWithFormat:@"%@万",[self formatFloat:[model.price floatValue]]] : @"面议";
    [self.mileageBtn setTitle:[NSString stringWithFormat:@" %@万 km",[self formatFloat:[model.mileage floatValue]/10000]] forState:UIControlStateNormal];

    if (model.useTime.length) {
//        NSDateComponents *cmps = [self pleaseInsertStarTime:model.addTime andInsertEndTime:[NSDate currentDateString]];
//        NSString *useTime = @"";
//        if (cmps.month ==0) {
//            useTime = [NSString stringWithFormat:@" %ld年",cmps.year];
//        }else{
//            useTime = [NSString stringWithFormat:@" %ld年%ld个月",cmps.year, cmps.month];
//        }
        [self.useTimeBtn setTitle:[NSString stringWithFormat:@" %@",model.useTime] forState:UIControlStateNormal];
    }else{
        [self.useTimeBtn setTitle:@" 年限未设置" forState:UIControlStateNormal];
    }
}

- (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}


/**
 计算时间差
 */
- (NSDateComponents *)pleaseInsertStarTime:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    return cmps;
}

@end
