//
//  SHTVViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHTVViewController.h"
#import "SHSwitchButton.h"
#import "SHChannelGroupViewCell.h"
#import "SHChannelCollectionViewCell.h"

@interface SHTVViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) SHTV *currentTV;

/// 左边控制的所有的基准键盘
@property (weak, nonatomic) IBOutlet UIView *leftControlBaseView;

/// 高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleIconViewHeightConstraint;

/// 宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleIconViewWidthConstraint;

/// 所有的通道类型
@property (strong, nonatomic) NSMutableArray *channelTypes;

/// 当前选择的通道类型
@property (strong, nonatomic) SHChannelGroup *selectChannelGroup;

/// 播放通道
@property (strong, nonatomic) SHChannel *currentChannel;

/// 开关机按钮图片
@property (weak, nonatomic) IBOutlet UIButton *powerIconButton;

/// 开关机切换按钮
@property (weak, nonatomic) IBOutlet SHSwitchButton *powerSwitchButton;

/// 静单开关
@property (weak, nonatomic) IBOutlet SHSwitchButton *muteButton;


/// 通道类型列表
@property (weak, nonatomic) IBOutlet UITableView *channelGroupListView;

/// 具体的频道列表
@property (weak, nonatomic) IBOutlet UICollectionView *channelListView;


@end

@implementation SHTVViewController


// MARK: - 控制指令

/// 数字1
- (IBAction)numberPadFor1Click {
    
    [self sendControlTVData:self.currentTV.number1];
}

/// 数字2
- (IBAction)numberPadFor2Click {
    [self sendControlTVData:self.currentTV.number2];
}

/// 数字3
- (IBAction)numberPadFor3Click {
    
    [self sendControlTVData:self.currentTV.number3];
}

/// 数字4
- (IBAction)numberPadFor4Click {
    
    [self sendControlTVData:self.currentTV.number4];
}

/// 数字5
- (IBAction)numberPadFor5Click {
    
    [self sendControlTVData:self.currentTV.number5];
}

/// 数字6
- (IBAction)numberPadFor6Click {
    
    [self sendControlTVData:self.currentTV.number6];
}

/// 数字7
- (IBAction)numberPadFor7Click {
    
    [self sendControlTVData:self.currentTV.number7];
}

/// 数字8
- (IBAction)numberPadFor8Click {
 
    [self sendControlTVData:self.currentTV.number8];
}

/// 数字9
- (IBAction)numberPadFor9Click {
    
    [self sendControlTVData:self.currentTV.number9];
}

/// 数字0
- (IBAction)numberPadFor0Click {
    
    [self sendControlTVData:self.currentTV.number0];
}


/// 频道 +
- (IBAction)channelUpButtonClick {
    
    [self sendControlTVData:self.currentTV.channelUp];
}

/// 频道 -
- (IBAction)channelDownButtonClick {
    
    [self sendControlTVData:self.currentTV.channelDown];
}

/// 声音 -
- (IBAction)volDownButtonClick {
    
    [self sendControlTVData:self.currentTV.volumeDown];
}

/// 声音 +
- (IBAction)volUpButtonClick {
    
    [self sendControlTVData:self.currentTV.volumeUp];
}

/// 确定键
- (IBAction)sureButtonClick {
    
    
    [self sendControlTVData:self.currentTV.sure];
}


/// 静单开关点击
- (IBAction)muteButtonClick {
    
    self.muteButton.on = !self.muteButton.on;
    
    [self sendControlTVData:(self.muteButton.isOn? self.currentTV.muteOn : self.currentTV.muteOff)];
}


/// 开关切换按钮点击
- (IBAction)powerSwitchButtonClick {
    
    self.powerSwitchButton.on = !self.powerSwitchButton.on;
    self.powerIconButton.selected = !self.powerIconButton.selected;
    
    [self sendControlTVData:(self.powerSwitchButton.isOn ? self.currentTV.turnOn : self.currentTV.turnOn)];
}

/// 发送电视的控制信号
- (void)sendControlTVData:(NSUInteger)switchNumber {
    
    Byte controlData[2] = {switchNumber, 0xFF};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE01C targetSubnetID:self.currentTV.subnetID targetDeviceID:self.currentTV.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

// MARK: - collectionView的数据源与代理

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.selectChannelGroup.channels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHChannelCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.channel = self.selectChannelGroup.channels[indexPath.item];
    
    return cell;
}

// MARK: - tableView的数据源与代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectChannelGroup = self.currentTV.channelGroups[indexPath.row];
    
    [self.channelListView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.currentTV.channelGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHChannelGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHChannelGroupViewCell class]) forIndexPath:indexPath];
    
    cell.channelGroup = self.currentTV.channelGroups[indexPath.row];
    
    return cell;
}

// MARK: - UI

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.middleIconViewWidthConstraint.constant = self.leftControlBaseView.frame_height * 0.55;
    self.middleIconViewHeightConstraint.constant = self.leftControlBaseView.frame_height * 0.55;
    
    // 右边的自定义按钮
    CGFloat itemMarign = statusBarHeight;
    NSUInteger totalCols = 3;
    
    CGFloat itemWidth = (self.channelListView.frame_width - (totalCols * itemMarign)) / totalCols;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.channelListView.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumLineSpacing = itemMarign;
    flowLayout.minimumInteritemSpacing = itemMarign;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.currentTV =
        [[[SHSQLManager shareSHSQLManager] getTV] lastObject];
    
    [self.channelGroupListView reloadData];
    
    // 默认选择第一组
    [self.channelGroupListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self tableView:self.channelGroupListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"TV"];
    
    [self.channelGroupListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHChannelGroupViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHChannelGroupViewCell class])];
    
    self.channelGroupListView.rowHeight = [SHChannelGroupViewCell rowHeight];
    
    [self.channelListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHChannelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHChannelCollectionViewCell class])];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 
@end
