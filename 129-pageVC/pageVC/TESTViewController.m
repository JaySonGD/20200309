//
//  TESTViewController.m
//  pageVC
//
//  Created by Jay on 16/5/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "TESTViewController.h"
#import "ViewController22.h"
#import "TableViewController.h"

@interface TESTViewController ()

@end

@implementation TESTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TableViewController *vc = [[TableViewController alloc] init];
    vc.title = @"固定高5度";
    
    ViewController22 *vc1 = [ViewController22 new];
    vc1.title = @"固定高1度";

    ViewController22 *vc2 = [ViewController22 new];
    vc2.title = @"固定高2度";

    ViewController22 *vc3 = [ViewController22 new];
    vc3.title = @"固定高3度";

    ViewController22 *vc4 = [ViewController22 new];
    vc4.title = @"固定高4度";

    [self addTitles:@[@"高度1",@"高度2",@"高度3",@"高度4",@"高度5"]
         controller:@[
                      
                      vc1,
                      vc2,
                      vc3,
                      vc4,
                      vc,

                      
                      ]];

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
