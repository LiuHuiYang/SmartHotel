//
//  SHCurtainViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCurtainViewController.h"

@interface SHCurtainViewController ()

/// 所有的窗帘
@property (strong, nonatomic) NSMutableArray *allCurtains;

@end

@implementation SHCurtainViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 查询所有的窗帘
    self.allCurtains = [[SHSQLManager shareSHSQLManager] getRoomCurtains];
    
    printLog(@"所有的窗帘: %@", self.allCurtains);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Curtain"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
