//
//  SHVIPViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHVIPViewController.h"
#import "SHServiceButton.h"

@interface SHVIPViewController ()

/// 出租车
@property (weak, nonatomic) IBOutlet SHServiceButton *taxiButton;

/// 我的车
@property (weak, nonatomic) IBOutlet SHServiceButton *myCarButton;

/// 需要修理
@property (weak, nonatomic) IBOutlet SHServiceButton *maintNeededButton;

/// 医生
@property (weak, nonatomic) IBOutlet SHServiceButton *doctorButton;

/// 服务生
@property (weak, nonatomic) IBOutlet SHServiceButton *buttlerButton;

/// 按摩
@property (weak, nonatomic) IBOutlet SHServiceButton *massageButton;

/// 电梯
@property (weak, nonatomic) IBOutlet SHServiceButton *elevtorButton;

/// 稍等
@property (weak, nonatomic) IBOutlet SHServiceButton *pleaseWaitButton;

/// 退房
@property (weak, nonatomic) IBOutlet SHServiceButton *checkoutButton;

/// 行李箱
@property (weak, nonatomic) IBOutlet SHServiceButton *bagesButton;

/// 急救
@property (weak, nonatomic) IBOutlet SHServiceButton *panicButton;

@end

@implementation SHVIPViewController


/// 急救
- (IBAction)panicButtonButtonClick {
    printLog(@"%@", self.panicButton.currentTitle);
}

/// 行李箱
- (IBAction)bagesButtonClick {
    printLog(@"%@", self.bagesButton.currentTitle);
}

/// 退房
- (IBAction)checkoutButtonClick {
    printLog(@"%@", self.checkoutButton.currentTitle);
}

/// 稍等
- (IBAction)pleaseWaitButtonClick {
    printLog(@"%@", self.pleaseWaitButton.currentTitle);
}


/// 电梯
- (IBAction)elevtorButtonClick {
    printLog(@"%@", self.elevtorButton.currentTitle);
}

/// 按摩
- (IBAction)massageButtonButtonClick {
    printLog(@"%@", self.massageButton.currentTitle);
}

/// 服务生
- (IBAction)buttlerButtonClick {
    printLog(@"%@", self.buttlerButton.currentTitle);
}


/// 医生
- (IBAction)doctorButtonClick {
    printLog(@"%@", self.doctorButton.currentTitle);
}

/// 需要修理
- (IBAction)maintNeededButtonClick {
    printLog(@"%@", self.maintNeededButton.currentTitle);
}

/// 我的车
- (IBAction)myCarButtonClick {
    printLog(@"%@", self.myCarButton.currentTitle);
}


/// 出租车
- (IBAction)taxiButtonClick {
    printLog(@"%@", self.taxiButton.currentTitle);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"VIP"];
    
    // 设置服务类型
    self.taxiButton.serverType = SHRoomServerTypeTaxi;
    self.myCarButton.serverType = SHRoomServerTypeMyCar;
    self.maintNeededButton.serverType = SHRoomServerTypeMaintenance;
    self.doctorButton.serverType = SHRoomServerTypeDoctor;
    self.buttlerButton.serverType = SHRoomServerTypeButtler;
    self.massageButton.serverType = SHRoomServerTypeMassage;
    self.elevtorButton.serverType = SHRoomServerTypeElevrtor;
    self.pleaseWaitButton.serverType = SHRoomServerTypePleaseWait;
    self.checkoutButton.serverType = SHRoomServerTypeCheckOut;
    self.bagesButton.serverType = SHRoomServerTypeBags;
    self.panicButton.serverType = SHRoomServerTypePanic;
    
    // 文字适配
    [self.taxiButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Taxi"] forState:UIControlStateNormal];
    
    [self.myCarButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"My Car"] forState:UIControlStateNormal];
    
    [self.maintNeededButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Maint. Needed"] forState:UIControlStateNormal];
    
    [self.doctorButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Doctor"] forState:UIControlStateNormal];
    
    [self.buttlerButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Buttler"] forState:UIControlStateNormal];
    
    [self.massageButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Massage"] forState:UIControlStateNormal];
    
    [self.elevtorButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Elevetor"] forState:UIControlStateNormal];
    
    [self.pleaseWaitButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"PleaseWait"] forState:UIControlStateNormal];
    
    [self.checkoutButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Check Out"] forState:UIControlStateNormal];
    
    [self.bagesButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Bages"] forState:UIControlStateNormal];
    
    [self.panicButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Panic"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
