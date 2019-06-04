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
@property (strong, nonatomic) SHChannelType *selectChannelType;

/// 播放通道
@property (strong, nonatomic) SHChannel *currentChannel;

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

/// 长按手势
@property (weak, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

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
    
    return self.selectChannelType.channels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SHChannelCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.channel = self.selectChannelType.channels[indexPath.item];
    
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
    
    self.currentTV = [[[SHSQLManager shareSHSQLManager] getTV] lastObject];
    
    self.channelTypes = [[SHSQLManager shareSHSQLManager] getAllChannelTypes:self.currentTV];
    
    // 默认选择第一组
    [self.channelTypeListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self tableView:self.channelTypeListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"TV"];
    
    [self.channelTypeListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHChannelTypeViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHChannelTypeViewCell class])];
    
    self.channelTypeListView.rowHeight = [SHChannelTypeViewCell rowHeightForChannelTypeViewCell];
    
    [self.channelListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHChannelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SHChannelCollectionViewCell class])];
    
    // 增加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(settingChannelPicture:)];
    
    longPress.minimumPressDuration = 1.0;
    
    [self.channelListView addGestureRecognizer:longPress];
    
    self.longPressGestureRecognizer = longPress;
}

/// 设置频道的图片
- (void)settingChannelPicture:(UILongPressGestureRecognizer *) longPressGestureRecognizer {
    
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan) {
        
        return;
    }
    
    NSIndexPath *selectIndexPath = [self.channelListView indexPathForItemAtPoint:[self.longPressGestureRecognizer locationInView:self.channelListView]];
    
    self.currentChannel = self.selectChannelType.channels[selectIndexPath.item];
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:@"Change Picture?" message:nil isCustom:YES];
    
    // 相册中获取
    [alertView addAction:[TYAlertAction actionWithTitle:@"Photos" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    // 相机中获取
    [alertView addAction:[TYAlertAction actionWithTitle:@"Camera" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    // 取消
    [alertView addAction:[TYAlertAction actionWithTitle:@"Cancel" style:TYAlertActionStyleCancel handler:nil]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    
    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - 照片的代理

/// 取消操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil  ];
}

/// 获得照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *sourceImage = [UIImage darwNewImage:[UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]] width:navigationBarHeight * 2];
    
    // 如果是相机，保存到相册中去
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(sourceImage, self, nil, nil);
    }
    
   // 保存
    [UIImage writeImageToDocument:self.currentChannel.channelType imageName:[NSString stringWithFormat:@"%@", @(self.currentChannel.channelIconID)] image:sourceImage];
   
//    [self.channelListView reloadData];
}
 
@end
