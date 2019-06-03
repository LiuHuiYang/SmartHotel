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
    
    // 获得通道
    Byte channelNumber = recivedData[startIndex];
    
    switch (operatorCode) {
            
        case 0XEFFF: {  // 继电器模块 // 调光器 
            
            if (subNetID == self.roomInfo.subNetIDForZoneBeast && deviceID == self.roomInfo.deviceIDForZoneBeast) {
                
                // 再读一下状态
                [self readStatus];
            }
           
        }
            break;
            
            
        case 0x0032: {
            
            Byte brightness = recivedData[11];
            
            if (recivedData[10] == 0XF8) {
                
                for (SHLight *light in self.allLights) {
                    
                    if (light.subnetID == subNetID && light.deviceID == deviceID && light.channelNo == channelNumber) {
                        
                        light.brightness = brightness;
                    }
                }
            }
        }
            break;
        
        case 0x0034: {
            
            // 这是LED
            if ((data.length == startIndex + 4 + 2 + 1) &&
                recivedData[3] == 0X03 &&
                recivedData[4] == 0X82) {
                
                
            } else {  // 普通灯泡
                
                Byte totalChannels = recivedData[startIndex];
                
                for (Byte i = 0; i < totalChannels; i++) {
                   
                    for (SHLight *light in self.allLights) {
                        
                        if (light.subnetID == subNetID && light.deviceID == deviceID && light.channelNo == (i + 1)) {
                            
                            light.brightness = recivedData[startIndex + i + 1];
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
    
    NSUInteger dimmerTotalCols = 3;
    
    CGFloat dimmerItemWidth = (self.lightListView.frame_width - (dimmerTotalCols * itemMarign)) / dimmerTotalCols;
    
    UICollectionViewFlowLayout *dimmerFlowLayout = (UICollectionViewFlowLayout *)self.self.lightListView.collectionViewLayout;
    
    dimmerFlowLayout.itemSize = CGSizeMake(dimmerItemWidth, self.lightListView.frame_height);
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
        [[SHSQLManager shareSHSQLManager] getAllSences];
    
    [self.senceListView reloadData];
    
    [self readStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"];
    
    self.senceLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"LIGHTS" withSubTitle:@"Scenes"];
 
    
    [self.lightListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHLightViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHLightViewCell class])];
    
    
    self.senceListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.senceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
