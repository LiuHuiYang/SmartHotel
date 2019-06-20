//
//  SHTVChannelDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHTVChannelDetailViewController.h"
#import "SHDeviceParametersDetailViewCell.h"

@interface SHTVChannelDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

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

/// 名称
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


/**
 图片按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

/// 列表 
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHTVChannelDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getChannelNameAndValues];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =
        @"TV Channel Detail";
    
    UIImage *image =
    [UIImage imageNamed:self.channel.iconName];
    
    if (image == nil) {
        
        SHIcon *icon =
        [SHSQLManager.shareSHSQLManager getIcon:self.channel.iconName];
        
        image =
        [UIImage imageWithData:icon.iconData];
        
        // 使用默认图片
        if (image == nil) {
            
            image =
                [UIImage imageNamed:@"channel_icon"];
        }
    }
    
    [self.iconButton setImage:image
                     forState:UIControlStateNormal
    ];
    
    self.nameTextField.text = self.channel.channelName;
    
    self.listView.rowHeight =
    [SHDeviceParametersDetailViewCell rowHeight];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHDeviceParametersDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHDeviceParametersDetailViewCell class])];
}

// MARK: - 设置值的获取与更新

- (void)getChannelNameAndValues {
    
    self.argsNames = @[
                       @"subnetID",
                       @"deviceID",
                       @"channel IRCode",
                       @"delayTime"
                       ];
    
    
    self.argsValues = @[
                        
                        [NSString stringWithFormat:@"%@", @(self.channel.subnetID)],
    
        [NSString stringWithFormat:@"%@", @(self.channel.deviceID)],
    
        [NSString stringWithFormat:@"%@", @(self.channel.channelIRCode)],
    
        [NSString stringWithFormat:@"%@", @(self.channel.delayTime)],
                        ];
}

/**
 更新频道的值
 
 @param value 值
 @param indexPath 位置
 */
- (void)updateChannel:(NSString *)value indexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.channel.subnetID = value.integerValue;
            break;
            
        case 1:
            self.channel.deviceID = value.integerValue;
            break;
            
        case 2:
            self.channel.channelIRCode = value.integerValue;
            break;
            
        case 3:
            self.channel.delayTime = value.integerValue;
            break;
            
        default:
            break;
    }
    
    [self getChannelNameAndValues];
    
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [SHSQLManager.shareSHSQLManager updateTVChannel:self.channel];
}



// MARK: - 图片处理


/**
 图标按钮点击
 */
- (IBAction)iconButtonClick {
    
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


// MARK: - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = UIColor.whiteColor;
    textField.textColor =
    [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = UIColor.clearColor;
    textField.textColor = UIColor.whiteColor;
    
    
    if (textField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"invalid name"];
        
        return;
    }
    
    self.channel.channelName = textField.text;
    
    [SHSQLManager.shareSHSQLManager updateTVChannel:self.channel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
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
    
    // 删除旧图片
    SHIcon *icon = [SHSQLManager.shareSHSQLManager getIcon:self.channel.channelName];
    
    if (icon != nil) {
        
        [SHSQLManager.shareSHSQLManager deleteIcon:icon];
    }
    
    // 增加新图片
    
    icon = [[SHIcon alloc] init];
    icon.iconID = [SHSQLManager.shareSHSQLManager getAvailableIconID];
    
    icon.iconName = [NSString stringWithFormat:@"icon_%zd", icon.iconID];
    
    icon.iconData =
        UIImagePNGRepresentation(sourceImage);
    
    self.channel.iconName = icon.iconName;
    
    [SHSQLManager.shareSHSQLManager insertIcon:icon];
    
    [SHSQLManager.shareSHSQLManager
        updateTVChannel:self.channel];
    
    [self.iconButton setImage:sourceImage
                     forState:UIControlStateNormal];
}

// MARK: - UITableViewDeletate 代理
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
        
        
        [self updateChannel:self.valueTextField.text
                 indexPath:indexPath
         ];
    }];
    
    [alertView addAction:cancelAction];
    [alertView addAction:saveAction];
    
    TYAlertController *alertController =
    [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    alertController.alertViewOriginY = navigationBarHeight + statusBarHeight;
    
    alertController.backgoundTapDismissEnable = YES;
    
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
    
    cell.argName = self.argsNames[indexPath.row];
    cell.argValue = self.argsValues[indexPath.row];
    
    return cell;
}
 

@end
