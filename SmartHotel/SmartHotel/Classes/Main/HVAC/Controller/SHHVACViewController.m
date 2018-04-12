//
//  SHHVACViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHVACViewController.h"

@interface SHHVACViewController ()

@property (weak, nonatomic) IBOutlet SHSwitchButton *powerButton;

@end

@implementation SHHVACViewController

- (IBAction)powerButtonClick {

    self.powerButton.on = !self.powerButton.on;
    
    Byte controlData[2] = {SHAirConditioningControlTypeOnAndOFF, self.powerButton.isOn};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"AC"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
