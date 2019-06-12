//
//  SHLightViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHLightViewController.h"
#import "SHMacroCollectionViewCell.h"
#import "SHLightViewCell.h"

@interface SHLightViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

// MARK: - UI控件相关

/// 灯泡列表(底部)
@property (weak, nonatomic) IBOutlet UICollectionView *lightListView;
 
/// 场景列表(底部)
@property (weak, nonatomic) IBOutlet UICollectionView *senceListView;

/// 场景标签
@property (weak, nonatomic) IBOutlet UILabel *senceLabel;

// MARK: - 其它

/// 所有场景
@property (strong, nonatomic) NSMutableArray *allSences;
 
/// 所有灯光设备
@property (strong, nonatomic) NSMutableArray *allLights;

@end

@implementation SHLightViewController

// MARK: - 数据传输出

/// 收到广播数据
- (void)analyzeReceiveData:(NSNotification *)notification {

    NSData *data = notification.object;
    
    Byte *recivedData = ((Byte *) [data bytes]);
    
    UInt16 operatorCode = ((recivedData[5] << 8) | recivedData[6]);
    
    Byte subNetID = recivedData[1];
    Byte deviceID = recivedData[2];
    
    const Byte startIndex = 9;
    
    switch (operatorCode) {
            
        case 0XEFFF: {  // 继电器模块
            
            // 1.获得区域总数
            Byte zoneCount = recivedData[startIndex + 0];
            
            // 2.获得模块的总通道数量
            Byte channelCount = recivedData[startIndex + zoneCount + 1];
            
            // 字节数
            Byte bytes =
                (channelCount / 8) +
                ((channelCount / 8) ? 1 : 0);
            
            // 状态数组
            Byte statusChannel[channelCount];
            
            //  所有通道的状态索引
            Byte channelIndex = 0;
            
            
            // 3.获得每个通道的具体状态
            // 所有通道的状态，通道状态的字节数(每个通道的状态用一个bit来表示)
            
            for (Byte section = 0; section < bytes; section++) {
                
                // 获得具体的值 -- 代表一个字节
                Byte channelStatus =
                    recivedData[startIndex + zoneCount
                                + 2 + section];
                
                for (Byte bit = 0; bit < 8; bit++) {
                    
                    Byte lightBress =
                    (channelStatus & 0x01) ? lightMaxBrightness : 0;
                    
                    channelIndex = bit + 8 * section;
                    
                    if (channelIndex >= channelCount) {
                        break;
                    }
                    
                    statusChannel[channelIndex] =
                        lightBress;
                    
                    channelStatus >>= 1;
                }
            }
            
            // 4.设置具体的亮度
            for (SHLight *light in self.allLights) {
                
                if (!light.isNotNeedEFFF &&
                    light.subnetID == subNetID &&
                    light.deviceID == deviceID &&
                    light.channelNo <= channelCount) {
                    
                    Byte brightness =
                        statusChannel[light.channelNo - 1];
                    
                    
                    if (light.brightness != brightness &&
                        light.brightness == 0) {
                        
                        light.brightness = brightness;
                    }
                }
            }
            
        }
            break;
            
        case 0x0032: {
            
            if (recivedData[startIndex + 1] == 0xF8) {
                
                for (SHLight *light in self.allLights) {
                    
                    if (light.subnetID == subNetID && light.deviceID == deviceID && light.channelNo == recivedData[startIndex]) {
                        
                        light.brightness =
                            recivedData[startIndex + 2];
                        
                        light.isNotNeedEFFF = YES;
                    }
                }
            }
        }
            break;
        
        case 0x0034: {
            
            // 这是LED
            if ((data.length == startIndex + 4 + 2 + 1) &&
                recivedData[3] == 0x03 &&
                recivedData[4] == 0x82) {
                
//                Byte red = recivedData[startIndex + 1];
//                Byte green = recivedData[startIndex + 2];
//                Byte blue = recivedData[startIndex + 3];
//                Byte white = recivedData[startIndex + 4];
//
//                for (SHLight *light in self.allLights) {
//
//                    if (light.subnetID == subNetID &&
//                        light.deviceID == deviceID) {
//
//
//                    }
//                }
                
            } else {  // 普通灯泡
                
                Byte totalChannels = recivedData[startIndex];
                
                for (Byte i = 0; i < totalChannels; i++) {
                   
                    for (SHLight *light in self.allLights) {
                        
                        if (light.subnetID == subNetID && light.deviceID == deviceID && light.channelNo == (i + 1)) {
                            
                            light.brightness = recivedData[startIndex + i + 1];
                            
                            if (light.lightType == SHLightTypeNotDimmable) {
                                
                                light.brightness = (light.brightness == lightMaxBrightness) ? lightMaxBrightness : 0;
                            }
                        }
                    }
                }
            }
        }
            
            break;
            
        default:
            break;
    }
    
    if (operatorCode == 0x0032 || operatorCode == 0x0034) {
        
        [self.lightListView reloadData];
    }
}

 
// MARK: - 数据源

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.senceListView) {
        
        SHMacroCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class]) forIndexPath:indexPath];
        
        cell.macro = self.allSences[indexPath.item];
        
        return cell;
    
    } else if (collectionView == self.lightListView) {
        
        SHLightViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHLightViewCell class]) forIndexPath:indexPath];
        
        cell.light = self. allLights[indexPath.item];
        
        return cell;
    
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.senceListView) {
        
        return self.allSences.count;
    
    } else if (collectionView == self.lightListView) {
        
        return self.allLights.count;
    }
    
    return 0;
}

// MARK: - 视图加协显示

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    CGFloat itemMarign  = defaultHeight;
    
    // 调光器的布局
    
    NSUInteger dimmerTotalCols = 2;
    
    CGFloat dimmerItemWidth = (self.lightListView.frame_width -
        ((dimmerTotalCols - 1) * itemMarign)
                               ) / dimmerTotalCols;
    
    UICollectionViewFlowLayout *dimmerFlowLayout =
    (UICollectionViewFlowLayout*)
        self.self.lightListView.collectionViewLayout;
    
    dimmerFlowLayout.itemSize =
        CGSizeMake(dimmerItemWidth,
                   [SHLightViewCell rowHeight]
                );
    dimmerFlowLayout.minimumLineSpacing = itemMarign;
    dimmerFlowLayout.minimumInteritemSpacing = 0;
    
    // 场景的布局
    NSUInteger sencesTotalCols = 5;
    
    CGFloat sencesItemWidth = (self.senceListView.frame_width - (sencesTotalCols * itemMarign)) / sencesTotalCols;
    
    UICollectionViewFlowLayout *sencesFlowLayout = (UICollectionViewFlowLayout *)self.self.senceListView.collectionViewLayout;
    
    sencesFlowLayout.itemSize = CGSizeMake(sencesItemWidth, self.senceListView.frame_height * 0.98);
    sencesFlowLayout.minimumLineSpacing = itemMarign;
    sencesFlowLayout.minimumInteritemSpacing = 0;
}


/// 读取状态
- (void)readStatus {
    
    NSUInteger subNetID = 0;
    NSUInteger deviceID = 0;
    
    for (SHLight *light in self.allLights) {
        
        if (light.subnetID == subNetID &&
            light.deviceID == deviceID) {
            
            continue;
        }
        
        subNetID = light.subnetID;
        deviceID = light.deviceID;
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0033 targetSubnetID:subNetID targetDeviceID:deviceID additionalContentData:nil remoteMacAddress:SHUdpSocket.getRemoteControlMacAddress needReSend:YES
         ];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.allLights =
        [SHSQLManager.shareSHSQLManager getLights];
    
    [self.lightListView reloadData];
    
    self.allSences =
        [[SHSQLManager shareSHSQLManager] getMacros];
    
    [self.senceListView reloadData];
    
    [self readStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"];
    
    self.senceLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"LIGHTS" withSubTitle:@"Scenes"];
    
    UIColor *backgroundColor =
        [UIColor colorWithPatternImage:
            [UIImage imageNamed:@"Share_SmallBG"]
        ];
 
//    self.lightListView.backgroundColor = backgroundColor;
//    self.senceListView.backgroundColor = backgroundColor;
    
    [self.lightListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHLightViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHLightViewCell class])];
    
    
    [self.senceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
