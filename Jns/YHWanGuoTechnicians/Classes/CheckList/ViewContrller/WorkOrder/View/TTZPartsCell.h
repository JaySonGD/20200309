//
//  TTZPartsCell.h
//  YHWanGuoTechnicians
//
//  Created by Jay on 17/1/2019.
//  Copyright © 2019 Zhu Wensheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//"partsName": "冷冻油",
//"partNum": 0,
//"partsUnit": "ml",
@interface TTZPartsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *partsNameLB;
@property (weak, nonatomic) IBOutlet UILabel *partNumLB;
@property (weak, nonatomic) IBOutlet UILabel *partsUnit;

@end

NS_ASSUME_NONNULL_END
