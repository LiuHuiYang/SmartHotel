//
//  SHLightDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHLightDetailViewController.h"
#import "SHLightDetailViewCell.h"

@interface SHLightDetailViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 灯光设备参数名称
 */
@property (strong, nonatomic) NSArray *argsNames;


/**
 值输入框
 */
@property (weak, nonatomic) UITextField *valueTextField;

/**
 灯光设备参数值
 */
@property (strong, nonatomic) NSArray *argsValues;


/**
 参数列表
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHLightDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getLightNameAndValues];
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Light Detail";
    
    self.listView.rowHeight =
    [SHLightDetailViewCell rowHeight];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHLightDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHLightDetailViewCell class])];
    
}

// MARK: - 参数值的获取与更新

/**
 获得窗帘的参数与名称
 */
- (void)getLightNameAndValues {
    
    self.argsNames = @[
                       @"light Name",
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
        
        [self updateLight:self.valueTextField.text
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
    
    SHLightDetailViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHLightDetailViewCell class]) forIndexPath:indexPath
     ];
    
    cell.argsName = self.argsNames[indexPath.row];
    cell.argValueText = self.argsValues[indexPath.row];
    
    return cell;
}
 

@end
