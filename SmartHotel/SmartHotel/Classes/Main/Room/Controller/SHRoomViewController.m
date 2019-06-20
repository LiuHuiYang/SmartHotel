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
@property (strong, nonatomic) SHRoomInfo *roomInfo;

/// 上一次选中的按钮
@property (weak, nonatomic) SHModuleSwitchButton *preivousButton;

///  tarBarScrollView （要设置tarBar的滚动范围）
@property (strong, nonatomic) UIScrollView *tabBarScrollView;


@end

@implementation SHRoomViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self resetRoomAndDeviceInfo];
}

/// 初始化信息
- (void)resetRoomAndDeviceInfo {
    
    // 获得当前房间的信息
    self.roomInfo = [[[SHSQLManager shareSHSQLManager] getRoomInfos] lastObject];
    
    // 首页要进行传值
    SHModelViewController *childController = (SHModelViewController *)[(SHNavigationController *)(self.childViewControllers[0]) topViewController];
    
    childController.roomInfo = self.roomInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllers];
    
    [self setUpTabBar];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gobackhomeController) name:SHControlGoBackHomeControllerNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gobackhomeController {
    
    self.preivousButton.selected = NO;
    self.preivousButton = nil;
    [self setSelectedIndex:0];
    
    [self resetRoomAndDeviceInfo];
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
    
    
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
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
    
    [self.tabBar addSubview:self.tabBarScrollView];
}


/// 添加所有的子控制器
- (void)addChildViewControllers {
    
    // home
    [self setUpChildController:[[SHHomeViewController alloc] init] roomInfomation:self.roomInfo];
    
    // hvac
    [self setUpChildController:[[SHHVACViewController alloc] init] roomInfomation:self.roomInfo];
    
    // light
    [self setUpChildController:[[SHLightViewController alloc] init] roomInfomation:self.roomInfo];
    
    // tv
    [self setUpChildController:[[SHTVViewController alloc] init] roomInfomation:self.roomInfo];
    
    // curtain
    [self setUpChildController:[[SHCurtainViewController alloc] init] roomInfomation:self.roomInfo];
    
    // alarm
    [self setUpChildController:[[SHAlarmViewController alloc] init] roomInfomation:self.roomInfo];
    
    // housekeeping
    [self setUpChildController:[[SHHousekeepingViewController alloc] init] roomInfomation:self.roomInfo];
    
    // vip
    [self setUpChildController:[[SHVIPViewController alloc] init] roomInfomation:self.roomInfo];
    
    // camera
    [self setUpChildController:[[SHCameraViewController alloc] init] roomInfomation:self.roomInfo];
    
    // worldtime
    [self setUpChildController:[[SHWorldTimeViewController alloc] init] roomInfomation:self.roomInfo];
}

/// 设置单个子控制器
- (void)setUpChildController:(SHModelViewController *)viewController roomInfomation:(SHRoomInfo *)roomInfomation {
    
//    viewController.roomInfo = roomInfomation;
    
//    viewController.tabBarItem.image = [[UIImage imageNamed:@"alarmTabBar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"alarmTabBar_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SHNavigationController *nav = [[SHNavigationController  alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

// MARK: -  布局

 
/// 布局子控件
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    // 删除系统默认创建的按钮
    for (UIControl *tabBarButton in self.tabBar.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [tabBarButton removeFromSuperview];
        }
    }
    
    self.tabBar.frame = CGRectMake(0, self.view.bounds.size.height - customToolBarHeight, self.view.frame.size.width, customToolBarHeight);
    
    self.tabBarScrollView.frame = self.tabBar.bounds;
    
    CGFloat buttonHeight = customToolBarHeight;
    CGFloat buttonWidth = customToolBarHeight;
    
    // 首页控制器不需要按钮是默认状态
    NSUInteger count = self.tabBarScrollView.subviews.count;

    CGFloat marign = (self.view.frame_width - (count * buttonWidth)) / (count + 1);
    
    for (NSUInteger i = 0; i < count; i++) {
        
        SHModuleSwitchButton *button = self.tabBarScrollView.subviews[i];
        
        button.frame = CGRectMake(i * (buttonWidth + marign) + marign, 0, buttonWidth, buttonHeight);
    }
    
    self.tabBarScrollView.contentSize = CGSizeMake(self.view.frame_width, 0);
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
        _tabBarScrollView.scrollEnabled = NO;
        _tabBarScrollView.showsVerticalScrollIndicator = NO;
        _tabBarScrollView.showsHorizontalScrollIndicator = NO;
        _tabBarScrollView.pagingEnabled = NO;
    }
    
    return _tabBarScrollView;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft |
    UIInterfaceOrientationMaskLandscapeRight;
}

@end
