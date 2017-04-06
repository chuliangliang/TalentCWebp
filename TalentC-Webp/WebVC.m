//
//  WebVC.m
//  TalentC-Webp
//
//  Created by chuliangliang on 2017/4/6.
//  Copyright © 2017年 chuliangliang. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>
#import "NSURLProtocolWebkitExt.h"

@interface WebVC ()
@property (strong, nonatomic) UIView *webView;
@end

@implementation WebVC

- (void)dealloc
{
    NSLog(@"WebVC -- dealloc");
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [NSURLProtocol unregisterClass:NSClassFromString(@"CLURLProtocol")];
        [NSURLProtocol wk_unregisterScheme:@"http"];
        [NSURLProtocol wk_unregisterScheme:@"https"];
    }else if ([self.webView isKindOfClass:[UIWebView class]])
    {
        [NSURLProtocol unregisterClass:NSClassFromString(@"CLURLProtocol")];
        
    }
}

- (instancetype)initWithWebType:(WEBType)type
{
    self = [super init];
    if (self) {
        if (type == WEBType_UIweb) {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }else if (type == WEBType_WKweb) {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
        }
        [self.view addSubview:self.webView];
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat W = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat H = CGRectGetHeight([UIScreen mainScreen].bounds);
    self.webView.frame = CGRectMake(0, 64, W, H-64);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        self.title = @"WKWebView load webp";
        //注册自定义 NSURLProtocol
        [NSURLProtocol registerClass:NSClassFromString(@"CLURLProtocol")];
        [NSURLProtocol wk_registerScheme:@"http"];
        [NSURLProtocol wk_registerScheme:@"https"];
        
        //发起请求
        WKWebView *web = (WKWebView *)self.webView;
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://onzbjws3p.bkt.clouddn.com/testForwebpSrc/testWebpForHtml.html"]]];
        
    }else if ([self.webView isKindOfClass:[UIWebView class]])
    {
        self.title = @"UIWebView load webp";
        //注册自定义 NSURLProtocol
        [NSURLProtocol registerClass:NSClassFromString(@"CLURLProtocol")];
        
        //发起请求
        UIWebView *web = (UIWebView *)self.webView;
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://onzbjws3p.bkt.clouddn.com/testForwebpSrc/testWebpForHtml.html"]]];
    }
    
    
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
