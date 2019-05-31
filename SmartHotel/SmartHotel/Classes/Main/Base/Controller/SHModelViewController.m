//
//  SHModelViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHModelViewController.h"

#import "SHNavigationBarButton.h"

#import "SHSettingRoomInfoViewController.h"
#import "SHHomeViewController.h"

#import "SHCurtainViewController.h"
#import "SHCurtainSettingViewController.h"


@interface SHModelViewController ()

@end

@implementation SHModelViewController


// MARK: - 导航栏的设置

/// 进入设置页面
- (void)setting:(UIGestureRecognizer *)recognizer {
    
    
    
    // 窗帘
    if ([self isKindOfClass:[SHCurtainViewController class]]) {
        
        // 这是窗帘
        printLog(@"这是窗帘");
        SHCurtainSettingViewController *curtainSetting =
            [[SHCurtainSettingViewController alloc] init];
        
        
        
        [self.navigationController
         pushViewController:curtainSetting animated:true];
        
        return;
    }
    
    if ([self isKindOfClass:[SHSettingRoomInfoViewController class]]) {
        return;
    }
    
    SHSettingRoomInfoViewController *settingViewController = [[SHSettingRoomInfoViewController alloc] init];
    
    settingViewController.roomInfo = self.roomInfo;
    
    [self.navigationController pushViewController:settingViewController animated:YES];
}

/// 回到首页
- (void)gobackhome:(UIGestureRecognizer *)recognizer  {
    
    // 设置页面
    if ([self isKindOfClass:[SHSettingRoomInfoViewController class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        // 其它页面
    } else if (![self isKindOfClass:[SHHomeViewController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHControlGoBackHomeControllerNotification object:nil];
    }
}

/// 设置导航
- (void)setUpNavigationBar {
    
    // 创建左边的按钮
    UITapGestureRecognizer *tapGestureRecognizerSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setting:)];
 

    SHNavigationBarButton *logoButton = [SHNavigationBarButton navigationBarButton:self.roomInfo.hotelName font:[UIFont boldSystemFontOfSize:26] image:[UIImage imageNamed:@"logo"] isDefault:YES addGestureRecognizer:tapGestureRecognizerSetting];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoButton];

    // 创建右边的按钮
    UITapGestureRecognizer *tapGestureRecognizerBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackhome:)];

    SHNavigationBarButton *homeButton =  [SHNavigationBarButton navigationBarButton:nil font:[UIFont boldSystemFontOfSize:26] image:(([self isKindOfClass:[SHHomeViewController class]]) ? nil : [UIImage imageNamed:@"home"]) isDefault:NO addGestureRecognizer:tapGestureRecognizerBack];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
}


// MARK: - 视图的加载

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(statusBarHeight, 0, navigationBarHeight * 4, navigationBarHeight);

    self.navigationItem.rightBarButtonItem.customView.frame = CGRectMake(self.view.frame_width - navigationBarHeight * 4, 0, navigationBarHeight * 4, navigationBarHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.roomInfo = [[[SHSQLManager shareSHSQLManager] getRoomBaseInformation] lastObject];
    
    // 房间信息
    printLog(@"房间信息: hotelName - %@, SHBuildID - %zd, floorID - %zd, \
             roomNumber - %zd", self.roomInfo.hotelName,
             self.roomInfo.buildID, self.roomInfo.floorID,
             self.roomInfo.roomNumber);
    
    [self setUpNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 由于在 10.5/12.9的屏幕上位伸变形，所以使用每个模块控制器都添加一张图片
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage resizeImage:@"Share_BG_iPad"]]];
    
    self.view.backgroundColor = [UIColor clearColor];
    
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
