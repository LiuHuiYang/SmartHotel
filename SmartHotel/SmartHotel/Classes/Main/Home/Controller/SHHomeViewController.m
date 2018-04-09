//
//  SHHomeViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHomeViewController.h"

//每一秒旋转的度数
#define perSecA (6)

//每一分旋转的度数
#define perMinA (6)

//每一小时旋转的度数
#define perHourA (30)

//每一分,时针旋转的度数
#define perMinHour (0.5)

#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface SHHomeViewController ()

/// 语言按钮
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

/// 当前最后选中的语言名称
@property (copy, nonatomic) NSString *selectLanguageName;

/// 时钟
@property (weak, nonatomic) IBOutlet UIImageView *clockView;

//// 当前的秒针
@property (nonatomic, weak)   CALayer *secLayer;

/// 当前的分针
@property (nonatomic, weak)   CALayer *minLayer;

/// 当前的时针
@property (nonatomic, weak)   CALayer *hourLayer;

/// 当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@end

@implementation SHHomeViewController

/// 保存语言设置
- (void)saveLanguageSetting:(NSString *)languageName {
    
    if (languageName.length <= 0 || [self.selectLanguageName isEqualToString:languageName]) {
        return;
    }
    
    self.selectLanguageName = languageName;
    
    [self.languageButton setTitle:self.selectLanguageName forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.selectLanguageName forKey:@"LAGUAGEZ_NAME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[SHLanguageTools shareSHLanguageTools] setLanguage];
    
    [SVProgressHUD showSuccessWithStatus:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Saved Successed!You should to restart app"]];
}


/// 设置语言
- (IBAction)setLanguage {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:nil isCustom:YES];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"中文" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self saveLanguageSetting:@"中文"];
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"English" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self saveLanguageSetting:@"English"];
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %zd", [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Room NO"], self.roomInfo.roomNumberDisplay];
    
    // 当前选择的语言
    self.selectLanguageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAGUAGEZ_NAME"];
    
    [self.languageButton setTitle:self.selectLanguageName forState:UIControlStateNormal];
    
    // 添加时钟动画
    [self addClockLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    [self timeChange];
}

- (void)timeChange {
    
    // 获得当前时间
    NSDateComponents *currentTime = [NSDate getCurrentDateComponents];
    
    // 获得要移动的秒数
    NSUInteger second = currentTime.second + 1; // 下一秒
    self.secLayer.transform = CATransform3DMakeRotation(angle2Rad(second * perSecA), 0, 0, 1);
    
    // 分钟
    NSUInteger minute = currentTime.minute;
    self.minLayer.transform = CATransform3DMakeRotation(angle2Rad(minute * perMinA), 0, 0, 1);
    
    //angle  = 当前多少小时 * 每一小时旋转多少度.
    NSUInteger hour = currentTime.hour;
    self.hourLayer.transform = CATransform3DMakeRotation(angle2Rad(hour * perHourA + minute * perMinHour), 0, 0, 1);
    
    // 更新当前时间
    self.currentTimeLabel.text =  [NSString stringWithFormat:@"%02zd:%02zd", currentTime.hour, currentTime.minute]; 
}

/// 添加时钟动画
- (void)addClockLayer {
    
    CALayer *hourLayer = [CALayer layer];
    hourLayer.bounds = CGRectMake(0, 0, 15, navigationBarHeight + navigationBarHeight + statusBarHeight);
    hourLayer.contents = (id)[UIImage imageNamed:@"main_ClockH_iPad"].CGImage;
    hourLayer.anchorPoint = CGPointMake(0.5, 0.64);
    hourLayer.position = CGPointMake(self.clockView.bounds.size.width * 0.5, self.clockView.bounds.size.height * 0.5);
    [self.clockView.layer addSublayer:hourLayer];
    self.hourLayer = hourLayer;
    
    CALayer *minLayer = [CALayer layer];
    minLayer.bounds = CGRectMake(0, 0, 15, navigationBarHeight + navigationBarHeight + statusBarHeight);
    minLayer.contents = (id)[UIImage imageNamed:@"main_ClockM_iPad"].CGImage;
    minLayer.anchorPoint =CGPointMake(0.5, 0.64);
    minLayer.position = CGPointMake(self.clockView.bounds.size.width * 0.5, self.clockView.bounds.size.height * 0.5);
    [self.clockView.layer addSublayer:minLayer];
    self.minLayer = minLayer;
    
    CALayer *secLayer = [CALayer layer];
    secLayer.bounds = CGRectMake(0, 0, 15, navigationBarHeight + navigationBarHeight + tabBarHeight);
    secLayer.contents = (id)[UIImage imageNamed:@"main_ClockS_iPad"].CGImage;
    secLayer.anchorPoint = CGPointMake(0.5, 0.64);
    secLayer.position = CGPointMake(self.clockView.bounds.size.width * 0.5, self.clockView.bounds.size.height * 0.5);
    [self.clockView.layer addSublayer:secLayer];
    self.secLayer = secLayer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
