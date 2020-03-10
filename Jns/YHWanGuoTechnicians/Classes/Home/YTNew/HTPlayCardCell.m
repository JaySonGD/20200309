//
//  HTPlayCardCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 20/5/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "HTPlayCardCell.h"
#import "TTZDateTextField.h"

@interface HTPlayCardCell ()
@property (weak, nonatomic) IBOutlet TTZDateTextField *dateTF;
@end

@implementation HTPlayCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    

    
    
    self.dateTF.maxDate = maxDate;

    self.dateTF.minDate = minDate;

    self.dateTF.valueChange = ^(NSString *text) {
        self.assess_info[@"car_license_time"] = text;
        if(self.getValueBlock){
            self.getValueBlock(text);
        }
    };
    
    
    [self.contentView.subviews.firstObject addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
}


- (void)tapAction{
    [self.dateTF becomeFirstResponder];
}


- (void)setAssess_info:(NSMutableDictionary *)assess_info{
    _assess_info = assess_info;
    self.dateTF.text = assess_info[@"car_license_time"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
