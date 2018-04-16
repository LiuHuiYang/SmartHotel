//
//  SHLightViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHLightViewController.h"
#import "SHMacroCollectionViewCell.h"
#import "SHDimmerCollectionViewCell.h"
#import "SHRelayCollectionViewCell.h"

@interface SHLightViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

// MARK: - UI控件相关

/// 灯泡列表(底部)
@property (weak, nonatomic) IBOutlet UICollectionView *lightListView;

/// 继电器模块列表(中间)
@property (weak, nonatomic) IBOutlet UICollectionView *realayListView;

/// 场景列表(底部)
@property (weak, nonatomic) IBOutlet UICollectionView *senceListView;

/// 场景标签
@property (weak, nonatomic) IBOutlet UILabel *senceLabel;

// MARK: - 其它

/// 所有场景
@property (strong, nonatomic) NSMutableArray *allSences;

/// 可以调光的灯泡
@property (strong, nonatomic) NSMutableArray * allLightsCanDim;

/// 不可以调光的灯泡
@property (strong, nonatomic) NSMutableArray * allLightsForRelay;

/// 所有灯泡 (包含调光和不调光)
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
            
        case 0XEFFF: {  // 继电器模块 // 调光器 每五秒广播一次，或者用户触发广播按钮指令
            
//            // 1.获得区域总数
//            Byte zoneCount = recivedData[startIndex];
//
//            // 2.获得模块的总通道数量
//            Byte channelCount = recivedData[startIndex + zoneCount + 1];
//
//            // 3.获得每个通道的具体状态
//            // 所有通道的状态，通道状态的字节数(每个通道的状态用一个bit来表示)
//            Byte statusForChannel[channelCount];
//            Byte channelIndex = 0; // 所有通道的状态索引
//            for (Byte i = 0; i < channelCount/8 + 1; i++) {
//
//                // 获得具体的值 -- 代表一个字节
//                Byte channelStatus = recivedData[startIndex + zoneCount + 2 + i];
//
//                for (Byte bit = 0; bit < 8; bit++) {
//
//                    Byte lightBress = ((channelStatus & 0x01) == 1) ? lightMaxBrightness : 0;
//                    statusForChannel[channelIndex] = lightBress;
//                    ++channelIndex;
//
//                    channelStatus >>= 1;
//                }
//            }
//
//            for (Byte i = 0; i < channelCount; i++) {
//
//                for (SHLight *light in self.allLights) {
//
//                    if (light.subnetID == subNetID && light.deviceID == deviceID && light.channelNo == (i + 1)) {
//
//                        light.brightness = statusForChannel[i];
//                    }
//                }
//            }
            
            if (subNetID == self.roomInfo.subNetIDForZoneBeast && deviceID == self.roomInfo.deviceIDForZoneBeast) {
                
                // 再读一下状态
                [self readStatus];
            }
           
        }
            break;
            
            
        case 0X0032: {
            
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
        
        case 0X0034: {
            
            // 这是LED
            if ((data.length == startIndex + 4 + 2 + 1) && recivedData[3] == 0X03 && recivedData[4] == 0X82) {
                
                
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
    
    if (operatorCode == 0X0032 || operatorCode == 0x0034) {
        
        [self.lightListView reloadData];
        [self.realayListView reloadData];
    }
}

 
// MARK: - 数据源

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.senceListView) {
        
        SHMacroCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class]) forIndexPath:indexPath];
        
        cell.macro = self.allSences[indexPath.item];
        
        return cell;
    
    } else if (collectionView == self.lightListView) {
        
        SHDimmerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHDimmerCollectionViewCell class]) forIndexPath:indexPath];
        
        SHLight *light = self. allLightsCanDim[indexPath.item];
        light.subnetID = self.roomInfo.subNetIDForZoneBeast;
        light.deviceID = self.roomInfo.deviceIDForZoneBeast;
        cell.light = light;
        
        return cell;
    
    } else if (collectionView == self.realayListView) {
        
        SHRelayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHRelayCollectionViewCell class]) forIndexPath:indexPath];
        
        SHLight *light = self. allLightsForRelay[indexPath.item];
        light.subnetID = self.roomInfo.subNetIDForZoneBeast;
        light.deviceID = self.roomInfo.deviceIDForZoneBeast;
        cell.light = light;
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.senceListView) {
        
        return self.allSences.count;
    
    } else if (collectionView == self.lightListView) {
        
        return self. allLightsCanDim.count;
    
    } else if (collectionView == self.realayListView) {
    
        return self.allLightsForRelay.count;
        
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
    
    // 继电器布局
    NSUInteger relayTotalCols = 3;
    
    CGFloat relayItemWidth = (self.realayListView.frame_width - (relayTotalCols * itemMarign)) / relayTotalCols;
    
    UICollectionViewFlowLayout *realyFlowLayout = (UICollectionViewFlowLayout *)self.self.realayListView.collectionViewLayout;
    
    realyFlowLayout.itemSize = CGSizeMake(relayItemWidth, self.realayListView.frame_height * 0.4);
    realyFlowLayout.minimumLineSpacing = itemMarign;
    realyFlowLayout.minimumInteritemSpacing = statusBarHeight;
    
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
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X0033 targetSubnetID:self.roomInfo.subNetIDForZoneBeast targetDeviceID:self.roomInfo.deviceIDForZoneBeast additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.allLightsCanDim = [[SHSQLManager shareSHSQLManager] getLight:YES];
    [self.lightListView reloadData];
    
    self.allLightsForRelay = [[SHSQLManager shareSHSQLManager] getLight:NO];
    [self.realayListView reloadData];
    
    self.allSences = [[SHSQLManager shareSHSQLManager] getAllSences];
    [self.senceListView reloadData];
    
    [self readStatus];
    
    NSMutableArray *lights = [NSMutableArray arrayWithArray:self.allLightsCanDim];
    [lights addObjectsFromArray:self.allLightsForRelay];
    
    self.allLights = lights;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"];
    
    self.senceLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"LIGHTS" withSubTitle:@"Scenes"];
    
//    self.lightListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.lightListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDimmerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHDimmerCollectionViewCell class])];
    
    self.realayListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.realayListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHRelayCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHRelayCollectionViewCell class])];
    
    self.senceListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.senceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
