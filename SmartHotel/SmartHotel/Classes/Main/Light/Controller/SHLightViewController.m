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
@property (strong, nonatomic) NSMutableArray *allDimmers;

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
        
        case 0X0034: {
            
            
        }
            
            break;
            
        default:
            break;
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
        
        SHLight *light = self.allDimmers[indexPath.item];
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
        
        return self.allDimmers.count;
    }
    
    return 0;
}

// MARK: - 视图加协显示

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    // 调光器的布局
    CGFloat dimmerItemMarign  = defaultHeight;
    NSUInteger dimmerTotalCols = 3;
    
    CGFloat dimmerItemWidth = (self.lightListView.frame_width - (dimmerTotalCols * dimmerItemMarign)) / dimmerTotalCols;
    
    UICollectionViewFlowLayout *dimmerFlowLayout = (UICollectionViewFlowLayout *)self.self.lightListView.collectionViewLayout;
    
    dimmerFlowLayout.itemSize = CGSizeMake(dimmerItemWidth, self.lightListView.frame_height);
    dimmerFlowLayout.minimumLineSpacing = dimmerItemMarign;
    dimmerFlowLayout.minimumInteritemSpacing = 0;
    
    // 场景的布局
    CGFloat sencesItemMarign  = defaultHeight;
    NSUInteger sencesTotalCols = 5;
    
    CGFloat sencesItemWidth = (self.senceListView.frame_width - (sencesTotalCols * sencesItemMarign)) / sencesTotalCols;
    
    UICollectionViewFlowLayout *sencesFlowLayout = (UICollectionViewFlowLayout *)self.self.senceListView.collectionViewLayout;
    
    sencesFlowLayout.itemSize = CGSizeMake(sencesItemWidth, self.senceListView.frame_height);
    sencesFlowLayout.minimumLineSpacing = sencesItemMarign;
    sencesFlowLayout.minimumInteritemSpacing = 0;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.allSences = [[SHSQLManager shareSHSQLManager] getAllSences];
    [self.senceListView reloadData];
    
    self.allDimmers = [[SHSQLManager shareSHSQLManager] getLight:YES];
    [self.lightListView reloadData];
    
    
    
    // 读取所有Light的状态
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X0033 targetSubnetID:self.roomInfo.subNetIDForZoneBeast targetDeviceID:self.roomInfo.deviceIDForZoneBeast additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Lights"];
    
    self.senceLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"LIGHTS" withSubTitle:@"Scenes"];
    
//    self.lightListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.lightListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDimmerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHDimmerCollectionViewCell class])];
    
    self.realayListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    self.senceListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Share_SmallBG"]];
    
    [self.senceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHMacroCollectionViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
