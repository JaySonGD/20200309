//
//  YHAppIntroduceController.m
//  YHCaptureCar
//
//  Created by mwf on 2018/6/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHAppIntroduceController.h"

@interface YHAppIntroduceController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation YHAppIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 12;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

