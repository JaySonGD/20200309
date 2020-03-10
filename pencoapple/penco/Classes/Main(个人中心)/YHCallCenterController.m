//
//  YHCallCenterController.m
//  penco
//
//  Created by Jay on 21/6/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "YHCallCenterController.h"

@interface YHCallCenterController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YHCallCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
