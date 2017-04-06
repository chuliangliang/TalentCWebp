//
//  ImageVC.m
//  TalentC-Webp
//
//  Created by chuliangliang on 2017/4/6.
//  Copyright © 2017年 chuliangliang. All rights reserved.
//

#import "ImageVC.h"
#import "UIImageView+WebCache.h"
@interface ImageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIImageView load webp";
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://onzbjws3p.bkt.clouddn.com/testForwebpSrc/test-webp.webp"] placeholderImage:nil];
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
