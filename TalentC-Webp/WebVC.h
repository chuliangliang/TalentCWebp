//
//  WebVC.h
//  TalentC-Webp
//
//  Created by chuliangliang on 2017/4/6.
//  Copyright © 2017年 chuliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WEBType) {
    WEBType_UIweb = 0,
    WEBType_WKweb,
};

@interface WebVC : UIViewController
- (instancetype)initWithWebType:(WEBType)type;
@end
