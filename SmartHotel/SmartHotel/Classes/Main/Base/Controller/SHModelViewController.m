//
//  SHModelViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHModelViewController.h"
#import "SHHomeViewController.h"

#import "SHNavigationBarButton.h"

#import "SHHomeViewController.h"

#import "SHHVACViewController.h"
#import "SHDeviceParametersViewController.h"

#import "SHLightViewController.h"

#import "SHCurtainViewController.h"
#import "SHCurtainSettingViewController.h"

#import "SHLightSettingViewController.h"
#import "SHMacroSettingViewController.h"

#import "SHTVViewController.h"
#import "SHTVSettingViewController.h"

@interface SHModelViewController ()

@end

@implementation SHModelViewController


// MARK: - 导航栏的设置

/// 进入设置页面
- (void)setting:(UIGestureRecognizer *)recognizer {
    
    // HVAC
    if ([self isKindOfClass: [SHHVACViewController class]]) {
        
        // FIXME: - 由于只支持一个空调, 临时这样实现.
        // 若以后有变空, 参照窗帘和light实现.
    
        SHDeviceParametersViewController *acDetailController =
        [[SHDeviceParametersViewController alloc] init];
        
        acDetailController.ac = [SHSQLManager.shareSHSQLManager getAirConditioners].firstObject;
        
        [self.navigationController pushViewController:acDetailController animated:YES];
        
    }
    
    // light && macro
    else if ([self isKindOfClass:[SHLightViewController class]]) {
        
//        NSString *lightTitle = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"];
//
//        NSString *sceneTitle = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"LIGHTS" withSubTitle:@"Scenes"];
        
        TYCustomAlertView *aletView =
            [TYCustomAlertView alertViewWithTitle:nil
                                          message:nil
                                         isCustom:YES
             ];
        
        TYAlertAction *lightAction = [TYAlertAction actionWithTitle:@"Lights" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
            SHLightSettingViewController *lightSetting =
            [[SHLightSettingViewController alloc] init];
            
            [self.navigationController
             pushViewController:lightSetting animated:true];
            
        }];
        
        TYAlertAction *macroAction = [TYAlertAction actionWithTitle:@"Scenes" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
            SHMacroSettingViewController *macroSetting =
            [[SHMacroSettingViewController alloc] init];
            
            [self.navigationController
                pushViewController:macroSetting
                          animated:YES
            ];
            
        }];
        
        [aletView addAction:lightAction];
        [aletView addAction:macroAction];
        
        TYAlertController *alertController =
        [TYAlertController alertControllerWithAlertView:aletView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
        
        
        alertController.backgoundTapDismissEnable = YES;
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil
        ];
    }
    
    // 窗帘
    else if ([self isKindOfClass:[SHCurtainViewController class]]) {
        
        
        SHCurtainSettingViewController *curtainSetting =
            [[SHCurtainSettingViewController alloc] init];
        
        [self.navigationController
         pushViewController:curtainSetting animated:true];
    }
    
    // TV && channel
    else if ([self isKindOfClass:[SHTVViewController class]]) {
        
        
        TYCustomAlertView *aletView =
        [TYCustomAlertView alertViewWithTitle:nil
                                      message:nil
                                     isCustom:YES
         ];
        
        TYAlertAction *lightAction = [TYAlertAction actionWithTitle:@"TV" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
            
            // FIXME: - 由于只支持一个电视, 临时这样实现.
            // 若以后有变空, 参照窗帘和light实现.
            
            SHDeviceParametersViewController *acDetailController =
            [[SHDeviceParametersViewController alloc] init];
            
            acDetailController.tv = [SHSQLManager.shareSHSQLManager getTV].firstObject;
            
            [self.navigationController pushViewController:acDetailController animated:YES];
            
        }];
        
        TYAlertAction *macroAction = [TYAlertAction actionWithTitle:@"Channels" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            
                SHTVSettingViewController *tvSetting =
                [[SHTVSettingViewController alloc] init];
            
            tvSetting.tv = [[SHSQLManager.shareSHSQLManager getTV] lastObject];
        
                [self.navigationController
                 pushViewController:tvSetting animated:true];
            
        }];
        
        [aletView addAction:lightAction];
        [aletView addAction:macroAction];
        
        TYAlertController *alertController =
        [TYAlertController alertControllerWithAlertView:aletView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
        
        
        alertController.backgoundTapDismissEnable = YES;
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil
         ];
    }
    
    // 首页
    else if ([self isKindOfClass:[SHHomeViewController class]]) {
        
        // FIXME: - 由于只支持一个房间, 临时这样实现.
        // 若以后有变空, 参照窗帘和light实现.
        
        SHDeviceParametersViewController *detailController =
        [[SHDeviceParametersViewController alloc] init];
        
       
        detailController.roomInfo = self.roomInfo;
    
    [self.navigationController pushViewController:detailController animated:YES];
    }
}

/// 回到首页
- (void)gobackhome:(UIGestureRecognizer *)recognizer  {
    
    // 设置页面
    if (![self isKindOfClass:[SHHomeViewController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHControlGoBackHomeControllerNotification object:nil];
    }
}

/// 设置导航
- (void)setUpNavigationBar {
    
    // 创建左边的按钮
    UITapGestureRecognizer *tapGestureRecognizerSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setting:)];
    
    UIFont *font = [UIFont boldSystemFontOfSize:25];

    SHNavigationBarButton *logoButton = [SHNavigationBarButton navigationBarButton:self.roomInfo.hotelName font:font image:[UIImage imageNamed:@"logo"] isDefault:YES addGestureRecognizer:tapGestureRecognizerSetting];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoButton];

    // 创建右边的按钮
    UITapGestureRecognizer *tapGestureRecognizerBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackhome:)];

    SHNavigationBarButton *homeButton =  [SHNavigationBarButton navigationBarButton:nil font:font image:(([self isKindOfClass:[SHHomeViewController class]]) ? nil : [UIImage imageNamed:@"home"]) isDefault:NO addGestureRecognizer:tapGestureRecognizerBack];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    
    // 固定大小
    self.navigationItem.leftBarButtonItem.customView.frame = CGRectMake(statusBarHeight, 0, navigationBarHeight * 4, navigationBarHeight);
    
    self.navigationItem.rightBarButtonItem.customView.frame = CGRectMake(self.view.frame_width - navigationBarHeight * 4, 0, navigationBarHeight * 4, navigationBarHeight);
}




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.roomInfo = [[[SHSQLManager shareSHSQLManager] getRoomInfos] lastObject];
     
    [self setUpNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 由于在 10.5/12.9的屏幕上位伸变形，所以使用每个模块控制器都添加一张图片
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage resizeImage:@"Share_BG_iPad"]]];
    
//    self.view.backgroundColor = [UIColor cololrWithHex:0x1E1E1E alpha:0.8];
    
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


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
