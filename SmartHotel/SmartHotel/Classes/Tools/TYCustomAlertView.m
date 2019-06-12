//
//  SHAlertView.m
//  Smart-Bus
//
//  Created by Mac on 2018/3/1.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "TYCustomAlertView.h"

@implementation TYCustomAlertView

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message isCustom:(BOOL) isCustom
{
    
    if (!isCustom) {
        
        return [super alertViewWithTitle:title message:message];
    }
    
    TYCustomAlertView *alertView = [super alertViewWithTitle:nil message:nil];
    
    // =============  整体显示背景 ======================
    
    alertView.layer.cornerRadius = [UIDevice is_iPad] ? statusBarHeight : statusBarHeight * 0.5;
    alertView.clipsToBounds = YES;
    
    alertView.backgroundColor = [UIColor darkGrayColor]; //[UIColor cololrWithHex:0xddFbFb alpha:0.9];
    
    CGFloat alertWidth =
        MIN([UIView frame_screenWidth],
            [UIView frame_screenHeight]
        ) * 0.65;
    
    // 框架本身默认是 280
    alertView.alertViewWidth = alertWidth > 280 ? alertWidth : 280;
    
    alertView.contentViewSpace = statusBarHeight;
    
    // =============  提示文字 ======================
    
    if (title.length) {
        
        alertView.textLabelSpace = statusBarHeight;
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title attributes: @{NSFontAttributeName:([UIDevice is_iPad] ? [UIFont fontWithName:@"HelveticaNeue-Bold" size:28] : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20]), NSForegroundColorAttributeName: [UIColor whiteColor]} ];
        
        alertView.titleLable.attributedText = attributedText;
        alertView.titleLable.numberOfLines = 0;
        
    }
    
    if (message.length) {
        
        alertView.textLabelContentViewEdge = statusBarHeight;
        
        NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName: ([UIDevice is_iPad] ? [UIFont fontWithName:@"HelveticaNeue" size:22] : [UIFont fontWithName:@"HelveticaNeue" size:16]), NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        
        alertView.messageLabel.attributedText = attributedMessage;
        alertView.messageLabel.numberOfLines = 0;
    }
    
    // =============  中间的按钮 ======================
    
    alertView.buttonSpace = statusBarHeight;
    
    alertView.buttonHeight = [UIDevice is_iPad] ? navigationBarHeight : tabBarHeight;
    
    alertView.buttonCornerRadius = statusBarHeight * 0.5;
    
    alertView.buttonFont = [UIDevice is_iPad] ? [UIFont boldSystemFontOfSize:22] : [UIFont boldSystemFontOfSize:16];
    
    // =============  textField ======================
    
    alertView.textFieldFont = [UIDevice is_iPad] ? [UIFont boldSystemFontOfSize:22] : [UIFont boldSystemFontOfSize:16];
    
    alertView.textFieldHeight = [UIDevice is_iPad] ? navigationBarHeight : defaultHeight;
    
    return alertView;
}



@end
