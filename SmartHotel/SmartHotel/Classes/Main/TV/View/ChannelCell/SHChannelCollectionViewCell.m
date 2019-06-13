//
//  SHChannelCollectionViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHChannelCollectionViewCell.h"
#import "SHLightButton.h"

@interface SHChannelCollectionViewCell ()

@property (weak, nonatomic) IBOutlet SHLightButton *channelButton;



@end

@implementation SHChannelCollectionViewCell

/// 频道按钮点击
- (IBAction)channelButtonClick {
    
    // 拆开逐位发送
    NSString *channelIRNumberString = [NSString stringWithFormat:@"%@", @(self.channel.channelIRNumber)];
    
    for (NSUInteger i = 0; i < channelIRNumberString.length; i++) {
        
        NSUInteger iRNumber = [[channelIRNumberString substringWithRange:NSMakeRange(i, 1)] integerValue];
        
        Byte controlData[2] = {iRNumber, 0xFF};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE01C targetSubnetID:self.channel.subnetID targetDeviceID:self.channel.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
        
        [NSThread sleepForTimeInterval:self.channel.delayTimeBetweenTowIRMillisecend/1000.0];
    }
}


- (void)setChannel:(SHChannel *)channel {
    
    _channel = channel;
     
    [self.channelButton setTitle:channel.channelName forState:UIControlStateNormal];
    
    [self.channelButton setImage:[UIImage imageNamed:@"TV_ChannelDefault"] forState:UIControlStateNormal];
    
    UIImage *image = [UIImage getImaageFromDoucment:channel.channelType imageName:[NSString stringWithFormat:@"%@", @(channel.channelIconID)]];
    
    if (image) {
        
        [self.channelButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.backgroundColor = UIColor.clearColor;
}

 

@end
