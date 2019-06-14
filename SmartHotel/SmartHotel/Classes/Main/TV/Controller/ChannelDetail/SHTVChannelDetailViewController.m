//
//  SHTVChannelDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHTVChannelDetailViewController.h"

@interface SHTVChannelDetailViewController () <UITextFieldDelegate>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TV Channel Detail";
    
    [self.iconButton setImage:[UIImage imageNamed:self.channel.iconName]
                     forState:UIControlStateNormal
    ];
    
    self.nameTextField.text = self.channel.channelName;
}


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
    
    // 保存
    //    [UIImage writeImageToDocument:self.currentChannel.channelType imageName:[NSString stringWithFormat:@"%@", @(self.currentChannel.channelIconID)] image:sourceImage];
    
    //    [self.channelListView reloadData];
}

@end
