//
//  SHMacroCollectionViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHMacroCollectionViewCell.h"
#import "SHOperatorCode.h"

@interface SHMacroCollectionViewCell ()

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 指令集
@property (nonatomic, strong) NSMutableArray *commands;

@end

@implementation SHMacroCollectionViewCell

- (void)touchMacro:(UITapGestureRecognizer *)sender {
    
    self.commands = [[SHSQLManager shareSHSQLManager] getSenceCommands: self.macro];
    
    if (!self.commands.count) {
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@ %@", self.macro.macroName, [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"No Data!"]]];
        
        return;
    }
    
    for (SHMacroCommand *command in self.commands) {
        
        UInt16 operatorCode = [SHOperatorCode getOperatorCode:command.commandTypeID];
        
        if (operatorCode == 0X0218) {
            
            NSMutableData *sendData = nil;
            
            switch (command.firstParameter) {
                    
                    // 注意：旧版本协议的可变参数为2 ~ 4 个，新版本统一为4个，可以给不同的值，为了兼容，采用旧代码的协议方式
                case 1: { // 音源控制
                    
                    Byte audioData[2] = { command.firstParameter, command.secondParameter};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    break;
                    
                case 2: { // 播放模式
                    
                    Byte audioData[2] = { command.firstParameter, command.secondParameter};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    break;
                    
                case 3: {  // 列表/频道
                    
                    Byte audioData[3] = { command.firstParameter, command.secondParameter, command.thirdParameter};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    break;
                    
                case 4: {  //  播放控制
                    
                    Byte audioData[2] = { command.firstParameter, command.secondParameter};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    
                    break;
                    
                case 5: {  // 音量调节
                    
                    Byte volValus = (1 - command.secondParameter * 0.01) * 80;
                    Byte audioData[4] = { command.firstParameter, 1, 3, volValus};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    
                    break;
                    
                case 6: {  // 歌曲播放
                    
                    Byte audioData[4] = { command.firstParameter, command.secondParameter, command.thirdParameter / 256, command.thirdParameter % 256 };
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:operatorCode targetSubnetID:command.subnetID targetDeviceID:command.deviceID additionalContentData:sendData remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
            
            [NSThread sleepForTimeInterval:command.delayMillisecondAfterSend / 1000.0];
            
        }  else if (operatorCode == 0XF080){  // LED
            
            Byte ledData[6] = {command.firstParameter, command.secondParameter, command.thirdParameter/256, command.thirdParameter%256, 0, 0};
            
            NSMutableData *sendData = [NSMutableData dataWithBytes:ledData length:sizeof(ledData)];
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:operatorCode targetSubnetID:command.subnetID targetDeviceID:command.deviceID additionalContentData:sendData remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
            
            [NSThread sleepForTimeInterval:command.delayMillisecondAfterSend / 1000.0];
            
        } else {  // 其它情况
            
            NSMutableData *sendData=  nil;
            
            if (operatorCode == 0X0031 || operatorCode == 0X010C) {
                
                Byte controlData[4] = {command.firstParameter, command.secondParameter, (command.thirdParameter >> 8) & 0XFF, command.thirdParameter & 0XFF};
                
                sendData = [NSMutableData dataWithBytes:controlData length:sizeof(controlData)];
                
            } else {
                
                Byte controlData[2] = { command.firstParameter,  command.secondParameter};
                
                sendData = [NSMutableData dataWithBytes:controlData length:sizeof(controlData)];
            }
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:operatorCode targetSubnetID:command.subnetID targetDeviceID:command.deviceID additionalContentData:sendData remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
            
            [NSThread sleepForTimeInterval:command.delayMillisecondAfterSend / 1000.0];
        }
    }
}

- (void)setMacro:(SHMacro *)macro {
    
    _macro = macro;
    
    self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Light_Sencen_Icon_%zd", macro.macroIconID]];
    
    self.nameLabel.text = macro.macroName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMacro:)];
    
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
