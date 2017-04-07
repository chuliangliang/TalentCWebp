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
#import "SDWebImageManager.h"
#import "UIImage+Ext.h"


@interface WebVC ()<WKNavigationDelegate,UIWebViewDelegate>
@property (strong, nonatomic) UIView *webView;
@property (assign, nonatomic) WEBType currentType;
@end

@implementation WebVC


- (void)dealloc
{
    NSLog(@"WebVC -- dealloc webview:%p",self.webView);
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [NSURLProtocol unregisterClass:NSClassFromString(@"CLURLProtocol")];
        [NSURLProtocol wk_unregisterScheme:@"http"];
        [NSURLProtocol wk_unregisterScheme:@"https"];
        
        WKWebView *web = (WKWebView *)self.webView;
        [web.configuration.userContentController removeAllUserScripts];
        web.navigationDelegate = nil;
        self.webView = nil;
    }else if ([self.webView isKindOfClass:[UIWebView class]])
    {
        [NSURLProtocol unregisterClass:NSClassFromString(@"CLURLProtocol")];
        UIWebView *web = (UIWebView *)self.webView;
        web.delegate = nil;
        [web loadHTMLString:@" " baseURL:nil]; //销毁时清除UIWebView 缓存
        self.webView = nil;
    }
    
    //清除缓存
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *appCacheDir = [NSString stringWithFormat:@"%@/Caches",libraryDir];
    NSArray *dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appCacheDir error:nil];
    for (NSString *subPath in dirArray) {
        NSError *error = nil;
        BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:[appCacheDir stringByAppendingPathComponent:subPath] error:&error];
        if (isSuccess) {
            NSLog(@"移除缓存");
        }
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (instancetype)initWithWebType:(WEBType)type
{
    self = [super init];
    if (self) {
        self.currentType = type;
        if (type == WEBType_UIweb || type == WEBType_UIjs) {
            UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectZero];
            if (type == WEBType_UIjs) {
                web.delegate = self;
            }
            self.webView = web;
            
        }else if (type == WEBType_WKweb || type == WEBType_WKjs) {
            WKWebViewConfiguration *config = [WKWebViewConfiguration new];
            config.userContentController = [WKUserContentController new];

            if ([config respondsToSelector:@selector(setWebsiteDataStore:)]) {
                [config setWebsiteDataStore:[WKWebsiteDataStore nonPersistentDataStore]]; //是否隐私模式 不保留缓存
            }
            
            if (type == WEBType_WKjs) {                
                //注入JS
                NSString *path = [[NSBundle mainBundle] pathForResource:@"TanlentC-Webp.js" ofType:nil];
                NSString *scource = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                WKUserScript * uScript = [[WKUserScript alloc] initWithSource:scource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
                [config.userContentController addUserScript:uScript];
            }

            
            WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
            web.navigationDelegate = self;
            
            self.webView = web;
            
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

    if (self.currentType == WEBType_WKweb) {
        self.title = @"WKWebView load webp";
        //注册自定义 NSURLProtocol
        [NSURLProtocol registerClass:NSClassFromString(@"CLURLProtocol")];
        [NSURLProtocol wk_registerScheme:@"http"];
        [NSURLProtocol wk_registerScheme:@"https"];

    }else if (self.currentType == WEBType_UIweb) {
        self.title = @"UIWebView load webp";
        //注册自定义 NSURLProtocol
        [NSURLProtocol registerClass:NSClassFromString(@"CLURLProtocol")];
        
    }else if (self.currentType == WEBType_WKjs) {
        self.title = @"WKWebView load webp With JS";
    }else if (self.currentType == WEBType_UIjs) {
        self.title = @"UIWebView load webp With JS";
    }
    
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        
        //发起请求
        WKWebView *web = (WKWebView *)self.webView;
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://onzbjws3p.bkt.clouddn.com/testForwebpSrc/webpForhtml.html"]]];
        
    }else if ([self.webView isKindOfClass:[UIWebView class]])
    {
        //发起请求
        UIWebView *web = (UIWebView *)self.webView;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://onzbjws3p.bkt.clouddn.com/testForwebpSrc/webpForhtml.html"]];
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        [web loadRequest:request];
    }
    NSLog(@"webview:%p",self.webView);
    
}



#pragma mark-
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    __weak __typeof(self)wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //注入JS
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TanlentC-Webp.js" ofType:nil];
        NSString *jsScource = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView stringByEvaluatingJavaScriptFromString:jsScource];
        
        
        //执行JS 获取所有图片
        NSString *jsonString = [webView stringByEvaluatingJavaScriptFromString:@"talentcGetAllImageSrc()"];
        if (!jsonString || jsonString.length == 0)  {
            return;
        }
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *imgs = json;
        for (NSString *imgUrl in imgs) {
            if (imgUrl) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    __strong __typeof (wself) sself = wself;
                    if (!sself) {
                        return;
                    }
                    if(image){
                        NSString *base64Image = [image imageToBase64Data];
                        NSString *jsString = [NSString stringWithFormat:@"talentcReplaceWebPImg('%@','%@')",imageURL,base64Image];
                        
                        UIWebView *web = (UIWebView *)sself.webView;
                        [web stringByEvaluatingJavaScriptFromString:jsString];
                    }
                }];
            }
        }

    });

}



#pragma mark-
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
    //WKWebView 加载完毕
    if (self.currentType == WEBType_WKjs) {
        //执行js 获取全部webp的图片地址
        __weak typeof(self)wself = self;
        //WKWebView 不知道什么原因 不延迟直接用会导致 偶尔出现不能对图片更新 这里延迟0.1s 原因以后在研究了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [webView evaluateJavaScript:@"talentcGetAllImageSrc()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                if (error == nil) {
                    [wself webViewGetAllImgSrc:obj];
                }
            }];
        });
    }
}

- (void)webViewGetAllImgSrc:(NSString *)jsonString
{
    if (!jsonString || jsonString.length == 0)  {
        return;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
 
    NSArray *imgs = json;
    for (NSString *imgUrl in imgs) {
        if (imgUrl) {
            __weak __typeof(self)wself = self;
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                __strong __typeof (wself) sself = wself;
                if (!sself) {
                    return;
                }
                if(image){
                    NSString *base64Image = [image imageToBase64Data];
                    NSString *jsString = [NSString stringWithFormat:@"talentcReplaceWebPImg('%@','%@')",imageURL,base64Image];
                    
                    WKWebView *webView = (WKWebView *)sself.webView;
                    
                    [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                        NSLog(@"error : %@ webView:%p",error,webView);
                    }];
                }
            }];
        }
    }
}

@end
