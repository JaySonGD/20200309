//
//  CJViewController.m
//  App
//
//  Created by Jay on 21/2/2020.
//  Copyright © 2020 tianfutaijiu. All rights reserved.
//

#import "CJViewController.h"
#import "FQQRequest.h"

@interface CJViewController ()
@property (weak, nonatomic) IBOutlet UILabel *linkLB;
@property (nonatomic, copy) NSString *base;
@end

@implementation CJViewController
- (IBAction)cjAction:(UIButton *)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SHViewController"];
    [self up];

      [vc setValue:self.linkLB.text forKey:@"url"];
      [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)testAction:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SHViewController"];
    
    UITextField *table = self.view.subviews[2];
    NSString *old = table.text;
    table.text = @"";
    [self up];
    [vc setValue:self.linkLB.text forKey:@"url"];
    table.text = old;
    [self up];

    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)up {

    
    self.base = @"http://129.204.117.172/task/cai?";
    
    UITextField *h = self.view.subviews[0];
    UITextField *page = self.view.subviews[1];
    UITextField *table = self.view.subviews[2];
    UITextField *api = self.view.subviews[3];
    UITextField *type = self.view.subviews[4];
    
    
    self.base = [NSString stringWithFormat:@"%@page=%d&",self.base,page.text.intValue];
    self.base = [NSString stringWithFormat:@"%@h=%@&",self.base,(h.hasText? h.text : @"day")];
    self.base = [NSString stringWithFormat:@"%@table=%@&",self.base,table.text];
    
    self.base = [NSString stringWithFormat:@"%@api=%@&",self.base,api.text];
    
    if (type.text.intValue) {
        self.base = [NSString stringWithFormat:@"%@type=%d",self.base,type.text.intValue];
    }


    self.linkLB.text = self.base;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"采集中心";

//    self.base = @"http://127.0.0.1/app/public/task/cai?";
//
//    UITextField *h = self.view.subviews[0];
//    UITextField *page = self.view.subviews[1];
//    UITextField *table = self.view.subviews[2];
//    UITextField *api = self.view.subviews[3];
//    UITextField *type = self.view.subviews[4];
//
//
//    self.base = [NSString stringWithFormat:@"%@page=%d&",self.base,page.text.intValue];
//    self.base = [NSString stringWithFormat:@"%@h=%@&",self.base,(h.hasText? h.text : @"day")];
//    self.base = [NSString stringWithFormat:@"%@table=%@&",self.base,table.text];
//    self.base = [NSString stringWithFormat:@"%@api=%@&",self.base,api.text];
//    self.base = [NSString stringWithFormat:@"%@type=%@",self.base,type.text.intValue?type.text : @""];
//
//
//    self.linkLB.text = self.base;
    [self up];

    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"list" style:UIBarButtonItemStylePlain target:self action:@selector(list)],[[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(save)]];

}
- (IBAction)clear:(UIButton *)sender {
    
    NSString *type = @[@"vod",@"cache",@"log",@"temp",@"unlinkCache"][sender.tag];
    NSString *url = [NSString stringWithFormat:@"http://129.204.117.172/api/clear?debug=99&c=tiyu&type=%@",type];
    
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:[NSString stringWithFormat:@"是否要删除(%@)?",type] preferredStyle:UIAlertControllerStyleAlert];
       
       [vc addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
           UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SHViewController"];

             [vc setValue:url forKey:@"url"];
             [self.navigationController pushViewController:vc animated:YES];

       }]];
       [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }]];

       [self presentViewController:vc animated:YES completion:nil];
    


}

- (void)list{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListViewController"];

      [self.navigationController pushViewController:vc animated:YES];

}

- (void)save{
   UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"书签" message:@"请输入采集书签的名称" preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        NSString *name = vc.textFields.firstObject.text;
        NSString *url = self.linkLB.text;
        
        
        NSMutableArray *list = [[[NSUserDefaults standardUserDefaults] objectForKey:@"list"] mutableCopy];
        if (!list) {
            list = [NSMutableArray array];
        }
        
        [list addObject:@{@"url":url,@"name":name}];
        
        [[NSUserDefaults standardUserDefaults] setValue:list forKey:@"list"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }]];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
