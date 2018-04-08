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

#import "SHRoomBaseInfomation.h"

@interface SHRoomViewController ()

/// 当前的房间
@property (strong, nonatomic) SHRoomBaseInfomation *currentRoom;


@end

@implementation SHRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获得当前房间的信息
    self.currentRoom = [[[SHSQLManager shareSHSQLManager] getRoomBaseInformation] lastObject];
    
    [self addChildViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: - 添加子控制器


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
    
    viewController.tabBarItem.image = [[UIImage imageNamed:@"alarmTabBar_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"alarmTabBar_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SHNavigationController *nav = [[SHNavigationController  alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}
 

@end
