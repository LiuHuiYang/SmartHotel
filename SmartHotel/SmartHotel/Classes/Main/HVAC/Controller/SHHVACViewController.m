//
//  SHHVACViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHVACViewController.h"

@interface SHHVACViewController ()

@property (weak, nonatomic) IBOutlet SHSwitchButton *testButton;

@end

@implementation SHHVACViewController

- (IBAction)testButtonClick {

    printLog(@"on: %d", self.testButton.isOn);
    self.testButton.on = !self.testButton.on;
    
    printLog(@"on: %d", self.testButton.isOn);
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
