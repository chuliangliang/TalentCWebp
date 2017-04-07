//
//  NSURLProtocolWebkitExt.h
//  NewsHunter
//
//  Created by chuliangliang on 2017/4/5.
//  Copyright © 2017年 Talent•C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitExt)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
