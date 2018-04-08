//
//  SHHomeViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHomeViewController.h"

@interface SHHomeViewController ()

/// 语言按钮
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

/// 当前最后选中的语言名称
@property (copy, nonatomic) NSString *selectLanguageName;


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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
