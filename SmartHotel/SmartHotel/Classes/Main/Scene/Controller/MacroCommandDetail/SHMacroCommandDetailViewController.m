//
//  SHMacroCommandDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroCommandDetailViewController.h"
#import "SHDeviceParametersDetailViewCell.h"

@interface SHMacroCommandDetailViewController ()

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

@implementation SHMacroCommandDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getMacroCommandNameAndValues];
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Scene Command Detail";
    
    self.listView.rowHeight =
    [SHDeviceParametersDetailViewCell rowHeight];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDeviceParametersDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class])];
}

// MARK: - 参数值的获取与更新


/**
 获得参数与名称
 */
- (void)getMacroCommandNameAndValues {
    
    self.argsNames = @[
                       @"command name",
                       @"command type",
                       
                       @"subnetID",
                       @"deviceID",
                       
                       @"parameter1",
                       @"parameter2",
                       @"parameter3",
                       @"parameter4",
                       @"parameter5",
                       @"parameter6",
                       @"parameter7",
                       @"parameter8",
                       
                       @"delayTime"
                       
                       ];
    
    self.argsValues = @[ self.macroCommand.remark,
                       
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.commandType)],
                       
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.subnetID)],
                       
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.deviceID)],
                       
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter1)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter2)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter3)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter4)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter5)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter6)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter7)],
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.parameter8)],
                       
                       [NSString stringWithFormat:@"%@",
                        @(self.macroCommand.delayTime)]
             
    ];
}

/**
 更新MacroCommand的值
 
 @param value 值
 @param indexPath 位置
 */
- (void)updateMacroCommand:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.macroCommand.remark = value;
            break;
            
        case 1:
            self.macroCommand.commandType = value.integerValue;
            break;
            
        case 2:
            self.macroCommand.subnetID = value.integerValue;
            break;
            
        case 3:
            self.macroCommand.deviceID = value.integerValue;
            break;
            
        case 4:
            self.macroCommand.parameter1 = value.integerValue;
            break;
            
        case 5:
            self.macroCommand.parameter2 = value.integerValue;
            break;
            
        case 6:
            self.macroCommand.parameter3 = value.integerValue;
            break;
            
        case 7:
            self.macroCommand.parameter4 = value.integerValue;
            break;
            
        case 8:
            self.macroCommand.parameter5 = value.integerValue;
            break;
            
        case 9:
            self.macroCommand.parameter6 = value.integerValue;
            break;
            
        case 10:
            self.macroCommand.parameter7 = value.integerValue;
            break;
            
        case 11:
            self.macroCommand.parameter8 = value.integerValue;
            break;
            
        case 12:
            self.macroCommand.delayTime = value.integerValue;
            break;
            
        default:
            break;
    }
    
    [self getMacroCommandNameAndValues];
    
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [SHSQLManager.shareSHSQLManager updateMacroCommand:self.macroCommand];
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
        
        [self updateMacroCommand:self.valueTextField.text
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
