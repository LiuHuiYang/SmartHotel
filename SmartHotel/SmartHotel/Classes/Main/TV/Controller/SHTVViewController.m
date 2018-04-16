//
//  SHTVViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHTVViewController.h"
#import "SHSwitchButton.h"
#import "SHChannelTypeViewCell.h"
#import "SHChannelCollectionViewCell.h"

@interface SHTVViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) SHTV *currentTV;

/// 所有的通道类型
@property (strong, nonatomic) NSMutableArray *channelTypes;

/// 当前选择的通道类型
@property (strong, nonatomic) SHChannelType *selectChannelType;

/// 开关机按钮图片
@property (weak, nonatomic) IBOutlet UIButton *powerIconButton;

/// 开关机切换按钮
@property (weak, nonatomic) IBOutlet SHSwitchButton *powerSwitchButton;

/// 静单开关
@property (weak, nonatomic) IBOutlet SHSwitchButton *muteButton;


/// 通道类型列表
@property (weak, nonatomic) IBOutlet UITableView *channelTypeListView;

/// 具体的频道列表
@property (weak, nonatomic) IBOutlet UICollectionView *channelListView;

@end

@implementation SHTVViewController


// MARK: - 控制指令

/// 数字1
- (IBAction)numberPadFor1Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor1];
}

/// 数字2
- (IBAction)numberPadFor2Click {
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor2];
}

/// 数字3
- (IBAction)numberPadFor3Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor3];
}

/// 数字4
- (IBAction)numberPadFor4Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor4];
}

/// 数字5
- (IBAction)numberPadFor5Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor5];
}

/// 数字6
- (IBAction)numberPadFor6Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor6];
}

/// 数字7
- (IBAction)numberPadFor7Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor7];
}

/// 数字8
- (IBAction)numberPadFor8Click {
 
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor8];
}

/// 数字9
- (IBAction)numberPadFor9Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor9];
}

/// 数字0
- (IBAction)numberPadFor0Click {
    
    [self sendControlTVData:self.currentTV.UniversalSwitchIDFor0];
}


/// 频道 +
- (IBAction)channelUpButtonClick {
    
    [self sendControlTVData:self.currentTV.ChannelUpUniversalSwitchID];
}

/// 频道 -
- (IBAction)channelDownButtonClick {
    
    [self sendControlTVData:self.currentTV.ChannelDownUniversalSwitchID];
}

/// 声音 -
- (IBAction)volDownButtonClick {
    
    [self sendControlTVData:self.currentTV.volDownUniversalSwitchID];
}

/// 声音 +
- (IBAction)volUpButtonClick {
    
    [self sendControlTVData:self.currentTV.volUpUniversalSwitchID];
}

/// 确定键
- (IBAction)sureButtonClick {
    
    
    [self sendControlTVData:self.currentTV.OKUniversalSwitchID];
}


/// 静单开关点击
- (IBAction)muteButtonClick {
    
    self.muteButton.on = !self.muteButton.on;
    
    [self sendControlTVData:(self.muteButton.isOn? self.currentTV.muteOnUniversalSwitchID : self.currentTV.muteOffUniversalSwitchID)];
}


/// 开关切换按钮点击
- (IBAction)powerSwitchButtonClick {
    
    self.powerSwitchButton.on = !self.powerSwitchButton.on;
    self.powerIconButton.selected = !self.powerIconButton.selected;
    
    [self sendControlTVData:(self.powerSwitchButton.isOn ? self.currentTV.openUniversalSwitchID : self.currentTV.closeUniversalSwitchID)];
}

/// 发送电视的控制信号
- (void)sendControlTVData:(NSUInteger)switchNumber {
    
    
    Byte controlData[2] = {switchNumber, 0XFF};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE01C targetSubnetID:self.currentTV.subnetID targetDeviceID:self.currentTV.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

// MARK: - collectionView的数据源与代理

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.selectChannelType.channels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHChannelCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.channel = self.selectChannelType.channels[indexPath.item];
    printLog(@"%@ == ", self.selectChannelType.channels);
    
    return cell;
}

// MARK: - tableView的数据源与代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectChannelType = self.channelTypes[indexPath.row];
    
    [self.channelListView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.channelTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHChannelTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHChannelTypeViewCell class]) forIndexPath:indexPath];
    
    cell.channelType = self.channelTypes[indexPath.row];
    
    return cell;
}

// MARK: - UI

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.currentTV = [[[SHSQLManager shareSHSQLManager] getTV] lastObject];
    
    self.channelTypes = [[SHSQLManager shareSHSQLManager] getAllChannelTypes:self.currentTV];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"TV"];
    
    [self.channelTypeListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHChannelTypeViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHChannelTypeViewCell class])];
    
    self.channelTypeListView.rowHeight = [SHChannelTypeViewCell rowHeightForChannelTypeViewCell];
    
    [self.channelListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHChannelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHChannelCollectionViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
