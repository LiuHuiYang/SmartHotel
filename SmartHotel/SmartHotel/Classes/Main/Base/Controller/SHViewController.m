//
//  SHViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHViewController.h"

@interface SHViewController ()

@end

@implementation SHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置指示器
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor cololrWithHex:0X726B6E alpha:1.0]];
    
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"showSuccess"]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"showError"]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"showInfo"]];
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3]];
    
    [SVProgressHUD setCornerRadius:statusBarHeight];
    
    [SVProgressHUD setImageViewSize:CGSizeMake(defaultHeight, defaultHeight)];
    
    [SVProgressHUD setMinimumSize:CGSizeMake(self.view.frame_width * 0.25, self.view.frame_height * 0.25)];
    
    
    //    if ([UIDevice is_iPad]) {
    
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:25]];
    
    [SVProgressHUD setImageViewSize:CGSizeMake(navigationBarHeight + statusBarHeight, navigationBarHeight + statusBarHeight)];
    
    [SVProgressHUD setMinimumSize:CGSizeMake(self.view.frame_width * 0.45, self.view.frame_height * 0.45)];
    //    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
