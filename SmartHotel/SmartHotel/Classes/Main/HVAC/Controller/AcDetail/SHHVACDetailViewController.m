//
//  SHHVACDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHHVACDetailViewController.h"
#import "SHDeviceParametersDetailViewCell.h"

@interface SHHVACDetailViewController () <UITableViewDataSource, UITableViewDelegate>
    
    /**
     空调参数名称
     */
    @property (strong, nonatomic) NSArray *argsNames;
    
    
    /**
     值输入框
     */
    @property (weak, nonatomic) UITextField *valueTextField;
    
    /**
     空调参数值
     */
    @property (strong, nonatomic) NSArray *argsValues;
    
    /**
     空调设置参数
     */
    @property (weak, nonatomic) IBOutlet UITableView *listView;
    
    
    @end

@implementation SHHVACDetailViewController
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getAirConditionerNameAndValues];
    [self.listView reloadData];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"AirConditioner Detail";
    
    self.listView.rowHeight =
    [SHDeviceParametersDetailViewCell rowHeight];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDeviceParametersDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class])
     ];
}
    
    // MARK: - 参数值的获取与更新
    
    /**
     获得空调的参数与名称
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
        
        [self updateAirConditioner:self.valueTextField.text indexPath:indexPath
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
