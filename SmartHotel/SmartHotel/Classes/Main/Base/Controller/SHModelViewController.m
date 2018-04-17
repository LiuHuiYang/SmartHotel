//
//  SHModelViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHModelViewController.h"

#import "SHNavigationBarButton.h"

#import "SHSettingViewController.h"
#import "SHHomeViewController.h"

@interface SHModelViewController ()


@end

@implementation SHModelViewController


// MARK: - 导航栏的设置

/// 进入设置页面
- (void)setting:(UIGestureRecognizer *)recognizer {
    
    if ((recognizer.state != UIGestureRecognizerStateBegan) || ([self isKindOfClass:[SHSettingViewController class]])) {
        return;
    }
    
    SHSettingViewController *settingViewController = [[SHSettingViewController alloc] init];
    
    settingViewController.roomInfo = self.roomInfo;
    
    [self.navigationController pushViewController:settingViewController animated:YES];
}

/// 回到首页
- (void)gobackhome:(UIGestureRecognizer *)recognizer  {
    
    // 设置页面
    if ([self isKindOfClass:[SHSettingViewController class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        // 其它页面
    } else if (![self isKindOfClass:[SHHomeViewController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHControlGoBackHomeControllerNotification object:nil];
    }
}

/// 设置导航
- (void)setUpNavigationBar {
    
    // 创建左边的按钮
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setting:)];
    
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    
    SHNavigationBarButton *logoButton = [SHNavigationBarButton navigationBarButton:self.roomInfo.hotelName font:[UIFont boldSystemFontOfSize:26] image:[UIImage imageNamed:@"logo"] isDefault:YES addGestureRecognizer:longPressGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoButton];
    
    
    // 创建右边的按钮
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackhome:)];
    
    SHNavigationBarButton *homeButton =  [SHNavigationBarButton navigationBarButton:nil font:[UIFont boldSystemFontOfSize:26] image:(([self isKindOfClass:[SHHomeViewController class]]) ? nil : [UIImage imageNamed:@"home"]) isDefault:NO addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
}


// MARK: - 视图的加载

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(statusBarHeight, 0, navigationBarHeight * 4, navigationBarHeight);

    self.navigationItem.rightBarButtonItem.customView.frame = CGRectMake(self.view.frame_width - navigationBarHeight * 4, 0, navigationBarHeight * 4, navigationBarHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_BG_iPad"]]];
    
    [self setUpNavigationBar];
    
    
    // 增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyzeReceiveData:) name:SHUdpSocketBroadcastNotification object:nil];
}

/// 接收到了数据
- (void)analyzeReceiveData:(NSNotification *)notification {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: - 状态栏的管理
- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
