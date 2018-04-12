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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获得当前房间的信息
    self.currentRoom = [[[SHSQLManager shareSHSQLManager] getRoomBaseInformation] lastObject];

    // 查询这个房间的所有设备
    NSMutableArray *devices = [[SHSQLManager shareSHSQLManager] getRoomDevice:self.currentRoom];
    
    // 主要是获取每个设备模块的子网ID && 设备ID
    for (SHRoomDevice *device in devices) {
        
        switch (device.deviceType) {
            
            case SHDeviceTypeDoorBell: {
                
                self.currentRoom.subNetIDForDoorBell = device.subnetID;
                self.currentRoom.deviceIDForDoorBell = device.deviceID;
            }
                break;
                
            case SHDeviceTypeCardHolder: {
                
                self.currentRoom.subNetIDForCardHolder = device.subnetID;
                self.currentRoom.deviceIDForCardHolder = device.deviceID;
            }
                break;
                
            case SHDeviceTypeBedside: {
                
                self.currentRoom.subNetIDForBedSide = device.subnetID;
                self.currentRoom.deviceIDForBedSide = device.deviceID;
            }
                break;
                
            case SHDeviceTypeZoneBeast: {
             
                self.currentRoom.subNetIDForZoneBeast = device.subnetID;
                self.currentRoom.deviceIDForZoneBeast = device.deviceID;
            }
                break;
                
            case SHDeviceTypeDDP: {
                
                self.currentRoom.subNetIDForDDP = device.subnetID;
                self.currentRoom.deviceIDForDDP = device.deviceID;
            }
                break;
                
            case SHDeviceTypeIR: {
                
                self.currentRoom.subNetIDForIR = device.subnetID;
                self.currentRoom.deviceIDForIR = device.deviceID;
            }
                break;
                
            case SHDeviceTypeZAudio: {
             
                self.currentRoom.subNetIDForZAudio = device.subnetID;
                self.currentRoom.deviceIDForZAudio = device.deviceID;
            }
                break;
                
            default:
                break;
        }
    }
    
    [self addChildViewControllers];
    
    [self setUpTabBar];
    
    // 测试数据
    self.currentRoom.deviceIDForDDP = 212;
    self.currentRoom.deviceIDForCardHolder = 117;
    self.currentRoom.deviceIDForDoorBell= 118;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gobackhomeController) name:SHControlGoBackHomeControllerNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddTabBarScrollView:) name:SHNavigationBarControllerPushHidderTabBarNotification object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 隐藏tabBar
- (void)hiddTabBarScrollView:(NSNotification *)notification {
    
    self.tabBarScrollView.hidden = [notification.object boolValue];
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
    
//    [self.tabBar removeFromSuperview];
//    self.tabBar.hidden = YES;
    
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
    
//    [self.view addSubview:self.tabBarScrollView];
    [self.view insertSubview:self.tabBarScrollView aboveSubview:self.tabBar];
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
        _tabBarScrollView.scrollEnabled = YES;
        _tabBarScrollView.showsVerticalScrollIndicator = NO;
        _tabBarScrollView.showsHorizontalScrollIndicator = NO;
        _tabBarScrollView.pagingEnabled = NO;
    }
    
    return _tabBarScrollView;
}

@end
