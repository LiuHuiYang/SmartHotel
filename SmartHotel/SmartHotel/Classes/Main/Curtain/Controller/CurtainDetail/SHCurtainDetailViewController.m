//
//  SHCurtainDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHCurtainDetailViewController.h"
#import "SHCurtainDetailViewCell.h"
#import "SHCurtain.h"

@interface SHCurtainDetailViewController () <UITableViewDataSource, UITableViewDelegate>


/**
 窗帘参数名称
 */
@property (strong, nonatomic) NSArray *argsNames;


/**
 值输入框
 */
@property (weak, nonatomic) UITextField *valueTextField;

/**
 窗帘参数值
 */
@property (strong, nonatomic) NSArray *argsValues;

@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHCurtainDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getCurtainNameAndValues];
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Curtain Detail";
    
    self.listView.rowHeight =
        [SHCurtainDetailViewCell rowHeight];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHCurtainDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHCurtainDetailViewCell class])];
}

// MARK: - 参数值的获取与更新

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
        
        [self updateCurtain:self.valueTextField.text indexPath:indexPath
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
    
    SHCurtainDetailViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHCurtainDetailViewCell class]) forIndexPath:indexPath
        ];
    
    cell.argsName = self.argsNames[indexPath.row];
    cell.argValueText = self.argsValues[indexPath.row];
    
    return cell;
}


@end
