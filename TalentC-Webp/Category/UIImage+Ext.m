//
//  UIImage+Ext.m
//  WebServerTest
//
//  Created by chuliangliang on 16/8/30.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "UIImage+Ext.h"

@implementation UIImage (Ext)


- (BOOL) imageHasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *) imageToBase64Data
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

@end
