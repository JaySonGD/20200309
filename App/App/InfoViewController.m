//
//  InfoViewController.m
//  App
//
//  Created by Jay on 14/1/2020.
//  Copyright © 2020 tianfutaijiu. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextView *table = self.view.subviews.lastObject;
    
    
    
    NSString *msg = self.obj[@"username"];

    if (![msg containsString:@"<pre>"]) {
        msg = [NSString stringWithFormat:@"<pre>id: %@\n\rpassword: %@\n\rusername: %@\n\raccesskey: %@\n\rplatform: %@\n\r</pre>",self.obj[@"id"],self.obj[@"password"],msg,self.obj[@"accesskey"], self.obj[@"platform"]];
    }
    NSData *data1 = [msg dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options1 = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data1
                                                               options:options1
                                                    documentAttributes:nil
                                                                 error:nil];
    table.attributedText = html;

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    //在这里可以获取点击的URL如果不做处理就会跳转到Safari打开链接
    return YES;
}

@end
