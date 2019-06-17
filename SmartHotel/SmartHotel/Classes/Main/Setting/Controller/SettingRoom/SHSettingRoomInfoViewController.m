//
//  SHSettingRoomInfoViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSettingRoomInfoViewController.h"
#import "SHSettingDeiviceTypeViewCell.h"
#import "SHDeviceParametersDetailViewCell.h"


@interface SHSettingRoomInfoViewController () <UITableViewDelegate, UITableViewDataSource>

/// 设备列表
@property (weak, nonatomic) IBOutlet UITableView *deviceListView;

/// 参数列表
@property (weak, nonatomic) IBOutlet UITableView *argsListView;

/// 设置种类名称
@property (strong, nonatomic) NSMutableArray *typeNames;

/// 房间参数名称
@property (strong, nonatomic) NSMutableArray *roomArgNames;

/// 房间参数值
@property (strong, nonatomic) NSMutableArray *roomArgValues;

/// 设备参数名称
@property (strong, nonatomic) NSMutableArray *deviceArgNames;

/// 设备参数值
@property (strong, nonatomic) NSMutableArray *deviceArgValues;

/// 当前的房间信息
@property (strong, nonatomic) SHRoomBaseInfomation *currentRoomInfo;

/// 选择的设备
@property (strong, nonatomic) SHRoomDevice *selectDevice;

/// 所有的设备
@property (strong, nonatomic) NSMutableArray *allDevices;

/// 设置类型
@property (assign, nonatomic) BOOL isSettingRoomInfo;

/// 值输入框
@property (nonatomic, strong) UITextField *valueTextField;

/// 选择的索引
@property (nonatomic, assign) NSUInteger selectIndex;

@end

@implementation SHSettingRoomInfoViewController

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.deviceListView) {
        
        self.isSettingRoomInfo = !indexPath.row;
        self.selectDevice = nil;
        self.selectIndex = indexPath.row;
        
        if (indexPath.row) {
            
            self.selectDevice = self.allDevices[indexPath.row - 1];
            
            self.deviceArgValues = [NSMutableArray arrayWithObjects:
                                    
                                    [NSString stringWithFormat:@"%@",
                                     @(self.selectDevice.subnetID)],
                                    
                                    [NSString stringWithFormat:@"%@",
                                     @(self.selectDevice.deviceID)],
                                    
                                    [NSString stringWithFormat:@"%@",
                                     (self.selectDevice.deviceRemark)],
                                    
                                    nil];
            
        }
        
        [self.argsListView reloadData];
        
    } else {
        
        (!self.isSettingRoomInfo && self.selectDevice) ?
            [self settingDeviceArgValues:indexPath] :
            [self settingRoomInfoArgValues:indexPath];
    }
}


/// 设置房间参数
- (void)settingRoomInfoArgValues:(NSIndexPath *)indexPath {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:self.roomArgNames[indexPath.row]
                                message:nil isCustom:YES];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [textField becomeFirstResponder];
        
        // 房间信息的前四个参数是整数
        textField.keyboardType = ((indexPath.row > 3)) ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        
        textField.text = self.roomArgValues[indexPath.row];
        
        self.valueTextField = textField;
    }];
    
    [alertView addAction:[TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Cancel"] style:TYAlertActionStyleCancel handler: nil]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Save"] style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        if (![self.valueTextField.text isEqualToString:@""] && self.valueTextField.text.length) {
            
            [self updateAndSaveRoomInfo:self.valueTextField.text index:indexPath.row];
        }
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    alertController.alertViewOriginY = navigationBarHeight + statusBarHeight;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 设置房间中的设备参数值
- (void)settingDeviceArgValues:(NSIndexPath *)indexPath {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:self.deviceArgNames[indexPath.row]
                                    message:nil isCustom:YES];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [textField becomeFirstResponder];
        
        textField.keyboardType = (([[self.deviceArgNames[indexPath.row] lowercaseString] containsString:[@"Name" lowercaseString]]) || ([[self.deviceArgNames[indexPath.row] lowercaseString] containsString:[@"Remark" lowercaseString]])) ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
        
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        
        textField.text = self.deviceArgValues[indexPath.row];
        
        self.valueTextField = textField;
    }];
    
    [alertView addAction:[TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Cancel"] style:TYAlertActionStyleCancel handler: nil]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Save"] style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        if (![self.valueTextField.text isEqualToString:@""] && self.valueTextField.text.length) {
            
            [self updateAndSaveDevice:self.valueTextField.text index:indexPath.row];
        }
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    alertController.alertViewOriginY = navigationBarHeight + statusBarHeight;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 更新房间信息
- (void)updateAndSaveRoomInfo:(NSString *)value index:(NSUInteger)index {
    
    switch (index) {
        
        case 0: {
            
            self.roomInfo.buildID = [value integerValue];
        }
            break;
            
        case 1: {
            
            self.roomInfo.floorID = [value integerValue];
        }
            break;
            
        case 2: {
            
            self.roomInfo.roomNumber = [value integerValue];
        }
            break;
            
        case 3: {
            
            self.roomInfo.roomNumberDisplay = [value integerValue];
        }
            break;
            
        case 4: {
            
            self.roomInfo.roomAlias = value;
        }
            break;
            
        case 5: {
            
            self.roomInfo.hotelName = value;
        }
            break;
            
        default:
            break;
    }
    
    [[SHSQLManager shareSHSQLManager] updateRoomInfo:self.roomInfo];
    
    [self refreshListView];
}

/// 更新设备
- (void)updateAndSaveDevice:(NSString *)value index:(NSUInteger)index {
    
    switch (index) {
        
        case 0: {
            
            self.selectDevice.subnetID = [value integerValue];
        }
            break;
            
        case 1: {
            
            self.selectDevice.deviceID = [value integerValue];
        }
            break;
            
        case 2: {
            
            self.selectDevice.deviceRemark = value;
        }
            break;
            
        default:
            break;
    }
    
    [[SHSQLManager shareSHSQLManager] updateRoomDevice:self.selectDevice];
    
    [self refreshListView];
}
    

// MARK: - 数据源

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.deviceListView) {
        
        SHSettingDeiviceTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHSettingDeiviceTypeViewCell class]) forIndexPath:indexPath];
        
        cell.deviceName = self.typeNames[indexPath.row];
        
        return cell;
        
    } else {
        
        SHDeviceParametersDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class]) forIndexPath:indexPath];
        
        if (self.isSettingRoomInfo) {
            
            cell.argName = self.roomArgNames[indexPath.row];
            cell.argValue = self.roomArgValues[indexPath.row];
            
        } else {
            
            cell.argName = self.deviceArgNames[indexPath.row];
            cell.argValue = self.deviceArgValues[indexPath.row];
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
    
    [self refreshListView];
    
}

/// 刷新列表
- (void)refreshListView {
    
    self.currentRoomInfo = [[[SHSQLManager shareSHSQLManager] getRoomBaseInformation] lastObject];
    self.allDevices = [[SHSQLManager shareSHSQLManager] getRoomDevice:self.currentRoomInfo];
    
    // 获得每个cell中的值
    self.roomArgValues = [NSMutableArray arrayWithObjects:
                          
                          [NSString stringWithFormat:@"%@", @(self.roomInfo.buildID)],
                          [NSString stringWithFormat:@"%@", @(self.roomInfo.floorID)],
                          [NSString stringWithFormat:@"%@", @(self.roomInfo.roomNumber)],
                          [NSString stringWithFormat:@"%@", @(self.roomInfo.roomNumberDisplay)],
                          [NSString stringWithFormat:@"%@", (self.roomInfo.roomAlias)],
                          [NSString stringWithFormat:@"%@", (self.roomInfo.hotelName)],
                          
                          nil];
    
//    [self.argsListView reloadData];
//    [self.deviceListView reloadData];
     
    [self.deviceListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self tableView:self.deviceListView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"Settings"];
    
    [self.deviceListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHSettingDeiviceTypeViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHSettingDeiviceTypeViewCell class])];
    self.deviceListView.rowHeight = [SHSettingDeiviceTypeViewCell rowHeightForDeviceTypeViewCell];
    
    [self.deviceListView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.argsListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDeviceParametersDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class])];
    
    self.argsListView.rowHeight = [SHDeviceParametersDetailViewCell rowHeight];
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
                      
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"Bedside"],
                       
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
