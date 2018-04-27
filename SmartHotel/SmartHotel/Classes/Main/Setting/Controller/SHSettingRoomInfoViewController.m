//
//  SHSettingRoomInfoViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSettingRoomInfoViewController.h"
#import "SHSettingDeiviceTypeViewCell.h"
#import "SHSettingDeviceArgsViewCell.h"


@interface SHSettingRoomInfoViewController () <UITableViewDelegate, UITableViewDataSource>

/// 设备列表
@property (weak, nonatomic) IBOutlet UITableView *deviceListView;

/// 参数列表
@property (weak, nonatomic) IBOutlet UITableView *argsListView;

/// 设置种类名称
@property (strong, nonatomic) NSMutableArray *typeNames;

/// 房间参数
@property (strong, nonatomic) NSMutableArray *roomArgNames;

/// 设备参数
@property (strong, nonatomic) NSMutableArray *deviceArgNames;

/// 当前的房间信息
@property (strong, nonatomic) SHRoomBaseInfomation *currentRoomInfo;

/// 选择的设备
@property (strong, nonatomic) SHRoomDevice *selectDevice;

/// 所有的设备
@property (strong, nonatomic) NSMutableArray *allDevices;

/// 设置类型
@property (assign, nonatomic) BOOL isSettingRoomInfo;

/// 保存按钮
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation SHSettingRoomInfoViewController


/// 点击保存
- (IBAction)saveButtonClick {
    
    // 更新房间信息
    [[SHSQLManager shareSHSQLManager] updateRoomInfo:self.currentRoomInfo];
    
    // 更新设备信息
    for (SHRoomDevice *device in self.allDevices) {
        
        [[SHSQLManager shareSHSQLManager] updateRoomDevice:device];
    }
    
    [SVProgressHUD showSuccessWithStatus:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Saved"]];
    
    /// 发出回到首页的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SHControlGoBackHomeControllerNotification object:nil];
}


// MARK: - 数据源和代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.deviceListView) {
        
        self.isSettingRoomInfo = !indexPath.row;
        
        if (indexPath.row) {
            
            self.selectDevice = self.allDevices[indexPath.row - 1];
        }
        
        [self.argsListView reloadData];
    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.deviceListView) {
        
        SHSettingDeiviceTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHSettingDeiviceTypeViewCell class]) forIndexPath:indexPath];
        
        cell.deviceName = self.typeNames[indexPath.row];
        
        return cell;
    
    } else {
    
        SHSettingDeviceArgsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHSettingDeviceArgsViewCell class]) forIndexPath:indexPath];
        
        cell.indexPath = indexPath;
        cell.selectDevice = nil;
        cell.currentRoomInfo = nil;  // 消除重用机制的影响
        
        if (self.isSettingRoomInfo) {
            
            cell.argName = self.roomArgNames[indexPath.row];
            cell.currentRoomInfo = self.currentRoomInfo;
        
        } else {
            
            cell.argName = self.deviceArgNames[indexPath.row];
            cell.selectDevice = self.selectDevice;
        }
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.deviceListView) {
        
        return self.typeNames.count;
    
    } else {
      
        return self.isSettingRoomInfo ? self.roomArgNames.count : self.deviceArgNames.count;
    }
    
    return 0;
}

// MARK: - UI设置

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.currentRoomInfo = [[[SHSQLManager shareSHSQLManager] getRoomBaseInformation] lastObject];
    
    self.allDevices = [[SHSQLManager shareSHSQLManager] getRoomDevice:self.currentRoomInfo];
    
    // 默认选择第一个
    [self.deviceListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self tableView:self.deviceListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"Settings"];
    
    [self.saveButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Save"] forState:UIControlStateNormal];
    
    [self.deviceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHSettingDeiviceTypeViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHSettingDeiviceTypeViewCell class])];
    self.deviceListView.rowHeight = [SHSettingDeiviceTypeViewCell rowHeightForDeviceTypeViewCell];
    
    [self.deviceListView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.argsListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHSettingDeviceArgsViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHSettingDeviceArgsViewCell class])];
    
    self.argsListView.rowHeight = [SHSettingDeviceArgsViewCell rowHeightForDeviceArgsViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - getter && setter

- (NSMutableArray *)typeNames {
    
    if (!_typeNames) {
        
        _typeNames = [NSMutableArray arrayWithObjects:
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"BasicSettings"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"DoorBell"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"CardHolder"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"ZoneBeast"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"Bedside"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"AUXPower"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"DDP"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"IR"],
                      nil];
    }
    
    return _typeNames;
}

- (NSMutableArray *)deviceArgNames {
    
    if (!_deviceArgNames) {
        
        _deviceArgNames = [NSMutableArray arrayWithObjects:
                       [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Subnet ID"],
                       [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Device ID"],
                       [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"Remark"],
                       
                       nil];
    }
    
    return _deviceArgNames;
}

- (NSMutableArray *)roomArgNames {
    
    if (!_roomArgNames) {
        
        _roomArgNames = [NSMutableArray arrayWithObjects:
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Building ID"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Floor ID"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Room NO."],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Room NO. Display"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"RoomAlias"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"HotelName"],
                     
                     nil];
    }
    
    return _roomArgNames;
}


@end
