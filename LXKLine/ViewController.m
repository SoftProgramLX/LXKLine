//
//  ViewController.m
//  LXKLine
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 LX. All rights reserved.
//

#import "ViewController.h"
#import "LXKLinesView.h"
#import "UIColor+helper.h"
#import "LXTopButtonScrollView.h"

@interface ViewController () <LXTopViewSelectDelegate>
{
    LXKLinesView *lineview;
    LXSingleton *singleton;
    
    UIScrollView *scrollV;
}
@end

@implementation ViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    singleton = [LXSingleton sharedLXSingleton];
    NSArray *btnTitles = @[@"日K", @"周K", @"月K"];
    LXTopButtonScrollView *topBtnView = [[LXTopButtonScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 34) andTitleArray:btnTitles andDelegate:self];
    [self.view addSubview:topBtnView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#111111" withAlpha:1];
    
    
    CGFloat liveY = topBtnView.y + topBtnView.height;
    
    // 添加k线图
    lineview = [[LXKLinesView alloc] initWithFrame:CGRectMake(0, liveY, kMainScreenWidth, kMainScreenHeight - (topBtnView.y + topBtnView.height) - 70)];
    //lineview.backgroundColor = [UIColor blueColor];
    lineview.req_type = @"d";
    lineview.req_freq = @"601888.SS";
    lineview.kLineWidth = 5;
    lineview.kLinePadding = 0.5;
    [self.view addSubview:lineview];
    [lineview start]; // k线图运行
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"%f %f", [touch locationInView:self.view].x,  [touch previousLocationInView:self.view].x);
    if ([touch locationInView:self.view].x - [touch previousLocationInView:self.view].x < -2) {
        //向左
        [lineview touchesKLineMoved:1];
    } else if ([touch locationInView:self.view].x - [touch previousLocationInView:self.view].x > 2) {
        //向右
        [lineview touchesKLineMoved:2];
    }
}

- (void)buttonDidSelected:(NSInteger)selectedIndex
{
    singleton.kCount = 0;
    singleton.lastPointIndex = 0;
    lineview.kLineWidth = 5;
    switch (selectedIndex) {
        case 1:{
            lineview.req_type = @"d";
            [self kUpdate];
        } break;
            
        case 2:{
            lineview.req_type = @"w";
            [self kUpdate];
        } break;
            
        case 3:{
            lineview.req_type = @"m";
            [self kUpdate];
        } break;
            
        default: break;
    }
}

-(void)kUpdate{
    [lineview update];
}

@end



