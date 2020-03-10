//
//  YTRecordCell.m
//  YHWanGuoTechnicians
//
//  Created by Jay on 1/3/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import "YTRecordCell.h"

@interface YTRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *dealNameLB;
@property (weak, nonatomic) IBOutlet UILabel *createUserNameLB;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *dealPointsLB;

@end

@implementation YTRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YTPointsDealListModel *)model{
    _model = model;
    
    self.dealNameLB.text = model.deal_name;
    self.createTimeLB.text = model.create_time;
    self.createUserNameLB.text = model.create_user_name;
    
    if (model.deal_sort == 0) {
        self.dealPointsLB.text = model.deal_points;
    }else if (model.deal_sort == 1){
        self.dealPointsLB.text = [NSString stringWithFormat:@"+ %@",model.deal_points];

    }else{
          self.dealPointsLB.text = [NSString stringWithFormat:@"- %@",model.deal_points];
    }


}

@end
