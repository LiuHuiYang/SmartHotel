//
//  SHDeviceParametersViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHDeviceParametersViewController.h"
#import "SHDeviceParametersDetailViewCell.h"

@interface SHDeviceParametersViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 设备参数名称
 */
@property (strong, nonatomic) NSArray *argsNames;


/**
 值输入框
 */
@property (weak, nonatomic) UITextField *valueTextField;

/**
 设备参数值
 */
@property (strong, nonatomic) NSArray *argsValues;


/**
 参数列表
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHDeviceParametersViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getDeiceParameters];
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Device Parameters";
    
    self.listView.rowHeight =
    [SHDeviceParametersDetailViewCell rowHeight];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDeviceParametersDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class])];
    
}

// MARK: - 获取具体的设备参数

- (void)getDeiceParameters {
    
    if (self.light != nil) {
        
        [self getLightNameAndValues];
        
    } else if (self.ac != nil) {
        
        [self getAirConditionerNameAndValues];
    
    } else if (self.curtain != nil) {
    
        [self getCurtainNameAndValues];
    }
}

/**
 获得窗帘的参数与名称
 */
- (void)getCurtainNameAndValues {
    
    self.argsNames = @[
                       
                       @"curtain Name",
                       @"curtain Type",
                       
                       @"subnetID",
                       @"deviceID",
                       
                       @"open Channel",
                       @"close Channel",
                       @"stop Channel",
                       
                       @"switchIDforOpen",
                       @"switchIDforClose",
                       @"switchIDforStop",
                       ];
    
    
    self.argsValues = @[
                        
                        self.curtain.curtainName,
                        [NSString stringWithFormat:@"%zd", self.curtain.curtainType],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.subnetID],
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.deviceID],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.openChannel],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.closeChannel],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.stopChannel],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.switchIDforOpen],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.switchIDforClose],
                        
                        [NSString stringWithFormat:@"%zd",
                         self.curtain.switchIDforStop]
                        ];
}

/**
 获得空调的参数信息
 */
- (void)getAirConditionerNameAndValues {
    
    self.argsNames = @[
                       @"ac Name",
                       
                       @"ac Type",
                       @"acNumber",
                       
                       @"subnetID",
                       @"deviceID",
                       @"channelNo"
                       
                       ];
    
    self.argsValues = @[
                        self.ac.acName,
                        
                        [NSString stringWithFormat:@"%@", @(self.ac.acType)],
                        [NSString stringWithFormat:@"%@", @(self.ac.acNumber)],
                        
                        [NSString stringWithFormat:@"%@", @(self.ac.subnetID)],
                        [NSString stringWithFormat:@"%@", @(self.ac.deviceID)],
                        [NSString stringWithFormat:@"%@", @(self.ac.channelNo)]
                        ];
}

/**
 获得参数与名称
 */
- (void)getLightNameAndValues {
    
    self.argsNames = @[
                       @"light name",
                       @"light type",
                       
                       @"subnetID",
                       @"deviceID",
                       @"channelNo"
                    ];
    
    self.argsValues = @[
                        self.light.lightName,
                        [NSString stringWithFormat:@"%zd", self.light.lightType],
                        
                         [NSString stringWithFormat:@"%zd", self.light.subnetID],
                         [NSString stringWithFormat:@"%zd", self.light.deviceID],
                         [NSString stringWithFormat:@"%zd", self.light.channelNo],
                        
                        ];
}

// MARK: - 更新参数值


/**
 更新设备参数值

 @param value 值
 @param indexPath 位置
 */
- (void)updateDevice:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    
    if (self.light != nil) {
        
        [self updateLight:value
                indexPath:indexPath
        ];
    
    } else if (self.ac != nil) {
        
        [self updateAirConditioner:value
                         indexPath:indexPath
        ];
    
    } else if (self.curtain != nil) {
        
        [self updateCurtain:value
                  indexPath:indexPath
        ];
    }
}

/**
 更新窗帘的值
 
 @param value 值
 @param indexPath 位置
 */
- (void)updateCurtain:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            self.curtain.curtainName = value;
            break;
            
        case 1:
            self.curtain.curtainType = value.integerValue;
            break;
            
        case 2:
            self.curtain.subnetID = value.integerValue;
            break;
            
        case 3:
            self.curtain.deviceID = value.integerValue;
            break;
            
        case 4:
            self.curtain.openChannel = value.integerValue;
            break;
            
        case 5:
            self.curtain.closeChannel = value.integerValue;
            break;
            
        case 6:
            self.curtain.stopChannel = value.integerValue;
            break;
            
        case 7:
            self.curtain.switchIDforOpen = value.integerValue;
            break;
            
        case 8:
            self.curtain.switchIDforClose = value.integerValue;
            break;
            
        case 9:
            self.curtain.switchIDforStop = value.integerValue;
            break;
            
        default:
            break;
    }
    
    // 重新获得值
    [self getCurtainNameAndValues];
    
    // 刷新列表
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [SHSQLManager.shareSHSQLManager updateCurtain:self.curtain];
}

/**
 更新空调的值
 
 @param value 值
 @param indexPath 位置
 */
- (void)updateAirConditioner:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            self.ac.acName = value;
            break;
            
        case 1:
            self.ac.acType = value.integerValue;
            break;
            
        case 2:
            self.ac.acNumber = value.integerValue;
            break;
            
        case 3:
            self.ac.subnetID = value.integerValue;
            break;
            
        case 4:
            self.ac.deviceID = value.integerValue;
            break;
            
        case 5:
            self.ac.channelNo = value.integerValue;
            break;
            
        default:
            break;
    }
    
    // 重新获得值
    [self getAirConditionerNameAndValues];
    
    // 刷新列表
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [SHSQLManager.shareSHSQLManager updateAirConditioner:self.ac];
}

/**
 更新Light的值
 
 @param value 值
 @param indexPath 位置
 */
- (void)updateLight:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.light.lightName = value;
            break;
            
        case 1:
            self.light.lightType = value.integerValue;
            break;
            
        case 2:
            self.light.subnetID = value.integerValue;
            break;
            
        case 3:
            self.light.deviceID = value.integerValue;
            break;
            
        case 4:
            self.light.channelNo = value.integerValue;
            break;
            
        default:
            break;
    }
    
    // 重新获得值
    [self getLightNameAndValues];
    
    // 刷新列表
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [SHSQLManager.shareSHSQLManager updateLight:self.light];
}


// MARK: - 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *argName = self.argsNames[indexPath.row];
    
    TYCustomAlertView *alertView =
    [TYCustomAlertView alertViewWithTitle:argName message:nil isCustom:YES];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [textField becomeFirstResponder];
        textField.clearButtonMode =
        UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = self.argsValues[indexPath.row];
        
        self.valueTextField = textField;
    }];
    
    TYAlertAction *cancelAction =
    [TYAlertAction actionWithTitle:@"cancel"
                             style:TYAlertActionStyleCancel
                           handler:nil
     ];
    
    TYAlertAction *saveAction = [TYAlertAction actionWithTitle:@"save" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        if (self.valueTextField.text.length == 0) {
            
            [SVProgressHUD showInfoWithStatus:
             @"The value should not be empty!"
             ];
            
            return ;
        }
        
       
        [self updateDevice:self.valueTextField.text
                 indexPath:indexPath
        ];
    }];
    
    [alertView addAction:cancelAction];
    [alertView addAction:saveAction];
    
    TYAlertController *alertController =
    [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.argsNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHDeviceParametersDetailViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class]) forIndexPath:indexPath
     ];
    
    cell.argsName = self.argsNames[indexPath.row];
    cell.argValueText = self.argsValues[indexPath.row];
    
    return cell;
}
 

@end
