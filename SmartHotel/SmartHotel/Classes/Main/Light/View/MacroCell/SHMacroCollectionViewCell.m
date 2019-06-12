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




@end

@implementation SHMacroCollectionViewCell

- (void)touchMacro:(UITapGestureRecognizer *)sender {
    
    NSMutableArray *commands = [SHSQLManager.shareSHSQLManager getMacroCommands: self.macro];
    
    if (!commands.count) {
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@ %@", self.macro.macroName, [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"No Data!"]]];
        
        return;
    }
    
    [SVProgressHUD showSuccessWithStatus:
        [NSString stringWithFormat:@"Execute %@",
            self.macro.macroName
        ]
    ];
    
    [self
     performSelectorInBackground:@selector(executeMacroCommands:)
     withObject:commands
     ];
    
}

/// 执行Macro command
- (void)executeMacroCommands:(NSMutableArray *)commands {
    
    for (SHMacroCommand *command in commands) {
        
        UInt16 operatorCode = [SHOperatorCode getOperatorCode:command.commandType];
        
        if (operatorCode == 0X0218) {
            
            NSMutableData *sendData = nil;
            
            switch (command.parameter1) {
                    
                    // 注意：旧版本协议的可变参数为2 ~ 4 个，新版本统一为4个，可以给不同的值，为了兼容，采用旧代码的协议方式
                case 1: { // 音源控制
                    
                    Byte audioData[2] = { command.parameter1, command.parameter2};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    break;
                    
                case 2: { // 播放模式
                    
                    Byte audioData[2] = { command.parameter1, command.parameter2};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    break;
                    
                case 3: {  // 列表/频道
                    
                    Byte audioData[3] = { command.parameter1, command.parameter2, command.parameter3};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    break;
                    
                case 4: {  //  播放控制
                    
                    Byte audioData[2] = { command.parameter1, command.parameter2};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    
                    break;
                    
                case 5: {  // 音量调节
                    
                    Byte volValus = (1 - command.parameter2 * 0.01) * 80;
                    Byte audioData[4] = { command.parameter1, 1, 3, volValus};
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    
                    break;
                    
                case 6: {  // 歌曲播放
                    
                    Byte audioData[4] = { command.parameter1, command.parameter2, command.parameter3 / 256, command.parameter3 % 256 };
                    sendData = [NSMutableData dataWithBytes:audioData length:sizeof(audioData)];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:operatorCode targetSubnetID:command.subnetID targetDeviceID:command.deviceID additionalContentData:sendData remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
            
            [NSThread sleepForTimeInterval:command.delayTime / 1000.0];
            
        }  else if (operatorCode == 0XF080){  // LED
            
            Byte ledData[6] = {command.parameter1, command.parameter2, command.parameter3/256, command.parameter3%256, 0, 0};
            
            NSMutableData *sendData = [NSMutableData dataWithBytes:ledData length:sizeof(ledData)];
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:operatorCode targetSubnetID:command.subnetID targetDeviceID:command.deviceID additionalContentData:sendData remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
            
            [NSThread sleepForTimeInterval:command.delayTime / 1000.0];
            
        } else {  // 其它情况
            
            NSMutableData *sendData=  nil;
            
            if (operatorCode == 0x0031 || operatorCode == 0X010C) {
                
                Byte controlData[4] = {command.parameter1, command.parameter2, (command.parameter3 >> 8) & 0xFF, command.parameter3 & 0xFF};
                
                sendData = [NSMutableData dataWithBytes:controlData length:sizeof(controlData)];
                
            } else {
                
                Byte controlData[2] = { command.parameter1,  command.parameter2};
                
                sendData = [NSMutableData dataWithBytes:controlData length:sizeof(controlData)];
            }
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:operatorCode targetSubnetID:command.subnetID targetDeviceID:command.deviceID additionalContentData:sendData remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
            
            [NSThread sleepForTimeInterval:command.delayTime / 1000.0];
        }
    }
}

- (void)setMacro:(SHMacro *)macro {
    
    _macro = macro;
    
    self.iconView.image = [UIImage imageNamed: macro.macroIconName];
    
    self.nameLabel.text = macro.macroName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMacro:)];
    
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end
