//
//  PCPostureCell.m
//  penco
//
//  Created by Zhu Wensheng on 2019/7/11.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCPostureCell.h"
#import "YHCommon.h"
@interface PCPostureCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIPageControl *pCT;
@property (weak, nonatomic) IBOutlet UILabel *angeleShoulderL;
@property (weak, nonatomic) IBOutlet UILabel *angleHipL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouderLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hipLC;

@end
@implementation PCPostureCell

- (void)loadImg:(UIImage*)image
          index:(NSInteger)index
            hip:(float)hip
       hipV:(float)hipV
       shoulder:(float)shoulder
shoulderV:(float)shoulderV{
    if (IsEmptyStr(image)) {
        return;
    }
    self.imgV.image = image;
    if (index == 0) {
        
        self.shouderLC.constant = shoulder * self.frame.size.height / image.size.height;
        self.angeleShoulderL.text = [NSString stringWithFormat:@"%.2f°", shoulderV];
        self.hipLC.constant = hip * self.frame.size.height / image.size.height;
        self.angleHipL.text = [NSString stringWithFormat:@"%.2f°", hipV];
    }
    self.angleHipL.hidden = (index != 0);
    self.angeleShoulderL.hidden = (index != 0);
    self.pCT.currentPage = index;
    
}
@end
