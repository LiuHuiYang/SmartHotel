//
//  SHRoomViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHRoomViewController.h"

#import "SHNavigationController.h"
#import "SHHomeViewController.h"
#import "SHLightViewController.h"
#import "SHHVACViewController.h"
#import "SHTVViewController.h"
#import "SHCurtainViewController.h"
#import "SHAlarmViewController.h"
#import "SHHousekeepingViewController.h"
#import "SHVIPViewController.h"
#import "SHCameraViewController.h"
#import "SHWorldTimeViewController.h"

#import "SHModuleSwitchButton.h"

@interface SHRoomViewController ()

/// 当前的房间
@property (strong, nonatomic) SHRoomBaseInfomation *currentRoom;

/// 上一次选中的按钮
@property (weak, nonatomic) SHModuleSwitchButton *preivousButton;

///  tarBarScrollView （要设置tarBar的滚动范围）
@property (strong, nonatomic) UIScrollView *tabBarScrollView;


@end

@implementation SHRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gobackhomeController) name:SHControlGoBackHomeControllerNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddTabBarScrollView) name:SHNavigationBarControllerPushHidderTabBarNotification object:nil];
    
    // 获得当前房间的信息
    self.currentRoom = [[[SHSQLManager shareSHSQLManager] getRoomBaseInformation] lastObject];
    
    [self addChildViewControllers];
    
    [self setUpTabBar];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 隐藏tabBar
- (void)hiddTabBarScrollView {
    
    self.tabBarScrollView.hidden = YES;
}

- (void)gobackhomeController {
    
    self.preivousButton.selected = NO;
    self.preivousButton = nil;
    [self setSelectedIndex:0];
}


// MARK: - 添加子控制器

/// 修改状态
- (void)changeViewController:(SHModuleSwitchButton *)button {
    
    if (button == self.preivousButton ) {
        return;
    }
    
    button.selected = !button.selected;
    self.preivousButton.selected = !self.preivousButton.selected;
    
    self.preivousButton = button;
    
    if (button.selected) {
        
        [self setSelectedIndex:button.tag];
    }
}



/// 设置导航栏
- (void)setUpTabBar {
    
    [self.tabBar removeFromSuperview];
//    self.tabBar.hidden = YES;
    
    NSArray *tatBarImages = @[ @"hvac", @"light", @"media", @"curtain", @"alarm", @"housekeeping", @"vip", @"camera", @"worldtime" ];
    
    //    NSArray *tabBarNames = [NSArray arrayWithObjects:
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"AC"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"TV"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"Curtain"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"Alarm"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"HouseKeeping"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"VIP"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"Cameras"],
    //
    //                            [[SHLanguageTools shareSHLanguageTools]
    //                             getTextFromPlist:@"MAINVIEW" withSubTitle:@"WorldClock"],
    //
    //                            nil];
    
    // 首页没有 从1开始
    for (int i = 1; i < self.childViewControllers.count; i++) {
        
        SHModuleSwitchButton *moduleButton = [[SHModuleSwitchButton alloc] init];
        
        moduleButton.tag = i;
        
        NSString *imageName = tatBarImages[i - 1];
        
        [moduleButton setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"TabBar_normal"]] forState:UIControlStateNormal];
        
        [moduleButton setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"TabBar_highlighted"]] forState:UIControlStateSelected];
        
        //        [moduleButton setTitle:tabBarNames[i - 1] forState:UIControlStateNormal];
        
        [moduleButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBarScrollView addSubview:moduleButton];
    }
    
    [self.view addSubview:self.tabBarScrollView];
}


/// 添加所有的子控制器
- (void)addChildViewControllers {
    
    // home
    [self setUpChildController:[[SHHomeViewController alloc] init] roomInfomation:self.currentRoom];
    
    // hvac
    [self setUpChildController:[[SHHVACViewController alloc] init] roomInfomation:self.currentRoom];
    
    // light
    [self setUpChildController:[[SHLightViewController alloc] init] roomInfomation:self.currentRoom];
    
    // tv
    [self setUpChildController:[[SHTVViewController alloc] init] roomInfomation:self.currentRoom];
    
    // curtain
    [self setUpChildController:[[SHCurtainViewController alloc] init] roomInfomation:self.currentRoom];
    
    // alarm
    [self setUpChildController:[[SHAlarmViewController alloc] init] roomInfomation:self.currentRoom];
    
    // housekeeping
    [self setUpChildController:[[SHHousekeepingViewController alloc] init] roomInfomation:self.currentRoom];
    
    // vip
    [self setUpChildController:[[SHVIPViewController alloc] init] roomInfomation:self.currentRoom];
    
    // camear
    [self setUpChildController:[[SHCameraViewController alloc] init] roomInfomation:self.currentRoom];
    
    // worldtime
    [self setUpChildController:[[SHWorldTimeViewController alloc] init] roomInfomation:self.currentRoom];
}

/// 设置单个子控制器
- (void)setUpChildController:(SHModelViewController *)viewController roomInfomation:(SHRoomBaseInfomation *)roomInfomation {
    
    viewController.roomInfo = roomInfomation;
    
//    viewController.tabBarItem.image = [[UIImage imageNamed:@"alarmTabBar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"alarmTabBar_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SHNavigationController *nav = [[SHNavigationController  alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

// MARK: -  布局

/// 布局子控件
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.tabBarScrollView.frame = CGRectMake(0, self.view.bounds.size.height - customToolBarHeight, self.view.frame.size.width, customToolBarHeight);
//    self.tabBarScrollView.frame = self.tabBar.bounds;
    self.tabBarScrollView.backgroundColor = [UIColor orangeColor];
}

// MARK: - 通知的销毁


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// MARK: - getter && setter

/// tabBarScrollView
- (UIScrollView *)tabBarScrollView {
    
    if (!_tabBarScrollView) {
        
        _tabBarScrollView = [[UIScrollView alloc] init];
        _tabBarScrollView.scrollEnabled = YES;
        _tabBarScrollView.showsVerticalScrollIndicator = NO;
        _tabBarScrollView.showsHorizontalScrollIndicator = NO;
        _tabBarScrollView.pagingEnabled = NO;
    }
    
    return _tabBarScrollView;
}

@end
