//
//  CLURLProtocol.m
//  NewsHunter
//
//  Created by chuliangliang on 2017/4/5.
//  Copyright © 2017年 apus. All rights reserved.
//

#import "CLURLProtocol.h"
#import <UIKit/UIKit.h>

#ifdef SD_WEBP
#import "UIImage+WebP.h"
#endif

static NSString* const CLProtocolKey = @"CLLURLProtocol-already-handled";


@interface CLURLProtocol ()<NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *recData;
@end

@implementation CLURLProtocol
-(void)dealloc
{
    self.recData = nil;
    
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    
#ifdef DEBUG
    NSLog(@"######NHWEBURLProtocol canInitRequest \nurl:%@ \n\n\n\n",request.URL.absoluteString);
#endif
    BOOL useCustomUrlProtocol = NO;
    NSString *urlString = request.URL.absoluteString;
    if (!SD_WEBP || ([urlString.pathExtension compare:@"webp"] != NSOrderedSame)) {
        useCustomUrlProtocol = NO;
    }else {
        if ([NSURLProtocol propertyForKey:CLProtocolKey inRequest:request] == nil) {
            useCustomUrlProtocol = YES;
        }else {
            useCustomUrlProtocol = NO;
        }
    }
    return useCustomUrlProtocol;
    
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)stopLoading
{
#ifdef DEBUG
    NSLog(@"######NHWEBURLProtocol stopLoading");
#endif
    
    if (self.connection) {
        [self.connection cancel];
    }
    self.connection = nil;
}

- (void)startLoading {
    NSMutableURLRequest *newRequest = [self cloneRequest:self.request];
    NSString *urlString = newRequest.URL.absoluteString;
#ifdef DEBUG
    NSLog(@"######NHWEBURLProtocol startLoading url:%@",urlString);
#endif
    [NSURLProtocol setProperty:@YES forKey:CLProtocolKey inRequest:newRequest];
    
    
    
    [self sendRequest:newRequest];
}


//复制Request对象
- (NSMutableURLRequest *)cloneRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
    
    newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    [newRequest setValue:@"image/webp,image/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    if (request.HTTPMethod) {
        newRequest.HTTPMethod = request.HTTPMethod;
    }
    
    if (request.HTTPBodyStream) {
        newRequest.HTTPBodyStream = request.HTTPBodyStream;
    }
    
    if (request.HTTPBody) {
        newRequest.HTTPBody = request.HTTPBody;
    }
    
    newRequest.HTTPShouldUsePipelining = request.HTTPShouldUsePipelining;
    newRequest.mainDocumentURL = request.mainDocumentURL;
    newRequest.networkServiceType = request.networkServiceType;
    
    return newRequest;
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------------------------------网络请求--------------------------------------------------------//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendRequest:(NSURLRequest *)request
{
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /**
     * 收到服务器响应
     */
    NSURLResponse *returnResponse = response;
    [self.client URLProtocol:self didReceiveResponse:returnResponse cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /**
     * 接收数据
     */
    if (!self.recData) {
        self.recData = [NSMutableData new];
    }
    if (data) {
        [self.recData appendData:data];
    }
}

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response
{
    /**
     * 重定向
     */
#ifdef DEBUG
    NSLog(@"^^^^^^^^重定向CLURLProtocol \nrequest:%@ \n\nresponse:%@\n\n",request, response);
#endif
    if (response) {
        [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    /**
     * 加载完毕
     */
    //处理图片
    
    NSData *imageData = self.recData;
#ifdef SD_WEBP
    UIImage *image = [UIImage sd_imageWithWebPData:self.recData];
    imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(image, 1);
    }
#endif

    
    [self.client URLProtocol:self didLoadData:imageData];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    /**
     * 加载失败
     */
    [self.client URLProtocol:self didFailWithError:error];
}

@end
