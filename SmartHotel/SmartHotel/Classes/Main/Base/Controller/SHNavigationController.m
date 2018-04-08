//
//  SHNavigationController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHNavigationController.h"

@interface SHNavigationController ()

@end

@implementation SHNavigationController

+ (void)load {
    
    // 设置navigationBar为透明
    [[UINavigationBar appearance] setBackgroundImage:
     [[UIImage alloc] init] forBarPosition:UIBarPositionAny
    barMetrics:UIBarMetricsDefault];

    // 去掉navigationBar底部的线条
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:28], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count) {
        
//        viewController.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:SHNavigationBarControllerPushHidderTabBarNotification object:nil];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHNavigationBarControllerPushHidderTabBarNotification object:nil];
    
    return [super popViewControllerAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - 状态栏的管理
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
