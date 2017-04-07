//
//  RootVC.m
//  TalentC-Webp
//
//  Created by chuliangliang on 2017/4/6.
//  Copyright © 2017年 chuliangliang. All rights reserved.
//

#import "RootVC.h"
#import "ImageVC.h"
#import "WebVC.h"


@interface RootVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idf = @"cell-idf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *text_cell = @"";
    switch (indexPath.row) {
        case 0:
        {
            text_cell = @"UIImageView load webp";
        }
            break;
        case 1:
        {
            text_cell = @"UIWebView load webp";
        }
            break;
        case 2:
        {
            text_cell = @"WKWebView load webp";
        }
            break;
        case 3:
        {
            text_cell = @"WKWebView load webp With JS";
        }
            break;
        case 4:
        {
            text_cell = @"UIWebView load webp With JS";
        }
            break;

        default:
            break;
    }
    cell.textLabel.text = text_cell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ImageVC *imgVC = [[ImageVC alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:imgVC animated:YES];
        }
            break;
        case 1:
        {
            WebVC *web = [[WebVC alloc] initWithWebType:WEBType_UIweb];
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 2:
        {
            WebVC *web = [[WebVC alloc] initWithWebType:WEBType_WKweb];
            [self.navigationController pushViewController:web animated:YES];
        }
            break;

        case 3:
        {
            WebVC *web = [[WebVC alloc] initWithWebType:WEBType_WKjs];
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 4:
        {
            WebVC *web = [[WebVC alloc] initWithWebType:WEBType_UIjs];
            [self.navigationController pushViewController:web animated:YES];
        }
            break;

        default:
            break;
    }
}
@end
