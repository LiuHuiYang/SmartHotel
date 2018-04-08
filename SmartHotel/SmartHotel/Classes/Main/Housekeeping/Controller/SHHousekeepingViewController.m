//
//  SHHousekeepingViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHousekeepingViewController.h"
#import "SHServiceButton.h"

@interface SHHousekeepingViewController ()

/// 洗衣服
@property (weak, nonatomic) IBOutlet SHServiceButton *laudryButton;

/// 擦鞋
@property (weak, nonatomic) IBOutlet SHServiceButton *cleanShoesButton;

/// 收拾餐具
@property (weak, nonatomic) IBOutlet SHServiceButton *takePlatesButton;

/// 请勿打扰
@property (weak, nonatomic) IBOutlet SHServiceButton *dndButton;

/// 毛巾 浴巾
@property (weak, nonatomic) IBOutlet SHServiceButton *towelsRobeButton;

/// 红酒
@property (weak, nonatomic) IBOutlet SHServiceButton *refillMiniBarButton;

/// 枕头 毛毯
@property (weak, nonatomic) IBOutlet SHServiceButton *pillowBlanketButton;

/// 冰激凌
@property (weak, nonatomic) IBOutlet SHServiceButton *iceButton;

/// 打扫
@property (weak, nonatomic) IBOutlet SHServiceButton *cleanButton;

/// 铺床
@property (weak, nonatomic) IBOutlet SHServiceButton *readyBedButton;

/// 早餐
@property (weak, nonatomic) IBOutlet SHServiceButton *breakfastButton;

/// 当前模块设备
@property (strong, nonatomic) SHRoomDevice *currentDevice;

@end

@implementation SHHousekeepingViewController


/// 早餐
- (IBAction)breakfastButtonClick {
    printLog(@"%@", self.breakfastButton.currentTitle);
}

/// 铺床
- (IBAction)readyBedButtonClick {
    printLog(@"%@", self.readyBedButton.currentTitle);
}

/// 打扫
- (IBAction)cleanButtonClick {
    printLog(@"%@", self.cleanButton.currentTitle);
}

/// 冰激凌
- (IBAction)iceButtonClick {
    printLog(@"%@", self.iceButton.currentTitle);
}


/// 毛巾 浴巾
- (IBAction)towelsRobeButtonClick {
    printLog(@"%@", self.towelsRobeButton.currentTitle);
}

/// 红酒
- (IBAction)refillMiniBarButtonClick {
    printLog(@"%@", self.refillMiniBarButton.currentTitle);
}

/// 枕头 毛毯
- (IBAction)pillowBlanketButtonClick {
    printLog(@"%@", self.pillowBlanketButton.currentTitle);
}


/// 请勿打扰
- (IBAction)dndButtonClick {
    printLog(@"%@", self.dndButton.currentTitle);
}

/// 收拾餐具
- (IBAction)takePlatesButtonClick {
    printLog(@"%@", self.takePlatesButton.currentTitle);
}

/// 擦鞋
- (IBAction)cleanShoesButtonClick {
    printLog(@"%@", self.cleanShoesButton.currentTitle);
}


/// 洗衣服
- (IBAction)laudryButtonClick {
    printLog(@"%@", self.laudryButton.currentTitle);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获得服务的相关参数
    self.currentDevice = [[SHSQLManager shareSHSQLManager] getRoomDevice:self.roomInfo deviceType:SHDeviceTypeCardHolder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"HouseKeeping"];
    
    // 设置服务类型
    self.laudryButton.serverType = SHRoomServerTypeLaudry;
    self.cleanShoesButton.serverType = SHRoomServerTypeCleanShoes;
    self.takePlatesButton.serverType = SHRoomServerTypeTakePlates;
    self.dndButton.serverType = SHRoomServerTypeDND;
    self.towelsRobeButton.serverType = SHRoomServerTypeTowels;
    self.refillMiniBarButton.serverType = SHRoomServerTypeRefillMiniBar;
    self.pillowBlanketButton.serverType = SHRoomServerTypePillow;
    self.iceButton.serverType = SHRoomServerTypeICE;
    self.cleanButton.serverType = SHRoomServerTypeClean;
    self.readyBedButton.serverType = SHRoomServerTypeReadyBed;
    self.breakfastButton.serverType = SHRoomServerTypeBreakfast;
    
    // 文字适配
    [self.laudryButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Laudry"] forState:UIControlStateNormal];
    
    [self.cleanShoesButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"CleanShoes"] forState:UIControlStateNormal];
    
    [self.takePlatesButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"TakePlates"] forState:UIControlStateNormal];
    
    [self.dndButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"DND"] forState:UIControlStateNormal];
    
    [self.towelsRobeButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Towels&Robe"] forState:UIControlStateNormal];
    
    [self.refillMiniBarButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"RefillMiniBar"] forState:UIControlStateNormal];
    
    [self.pillowBlanketButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Pillow&Blanket"] forState:UIControlStateNormal];
    
    [self.iceButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"ICE"] forState:UIControlStateNormal];
    
    [self.cleanButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Clean"] forState:UIControlStateNormal];
    
    [self.readyBedButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"ReadyBed"] forState:UIControlStateNormal];
    
    [self.breakfastButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Breakfast"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
