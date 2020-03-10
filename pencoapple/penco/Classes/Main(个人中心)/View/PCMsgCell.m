//
//  PCMsgCell.m
//  penco
//
//  Created by Jay on 28/9/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCMsgCell.h"

@interface PCMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *sysTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *messageLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageRightSpace;

@end

@implementation PCMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickAction:(UIButton *)sender {
    
    if(sender.tag==1){//more
        self.obj[@"more"] = @(2);
    }else self.obj[@"more"] = @(1);
    !(_reloadBlock)? : _reloadBlock();
}

- (void)setObj:(NSDictionary *)obj{
    _obj = obj;
    
    self.sysTitleLB.text = obj[@"title"];
    self.messageLB.text = obj[@"des"];
    
    NSInteger more = [obj[@"more"] integerValue];
    if (more == 1) {
        self.messageRightSpace.constant = 46;
        self.messageLB.numberOfLines = 1;
        self.moreBtn.hidden = NO;
        
        self.minBtnH.constant = 10;
        self.minBtn.hidden = YES;

    }else if (more == 2){
        self.messageRightSpace.constant = 16;
        self.messageLB.numberOfLines = 0;
        self.moreBtn.hidden = YES;
        self.minBtnH.constant = 45;
        self.minBtn.hidden = NO;

    }else{
        self.messageRightSpace.constant = 16;
        self.messageLB.numberOfLines = 1;
        self.moreBtn.hidden = YES;
        self.minBtnH.constant = 10;
        self.minBtn.hidden = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
