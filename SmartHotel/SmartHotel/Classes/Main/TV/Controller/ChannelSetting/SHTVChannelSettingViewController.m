
//
//  SHTVChannelSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHTVChannelSettingViewController.h"
#import "SHTVChannelSettingCell.h"
#import "SHTVChannelDetailViewController.h"

@interface SHTVChannelSettingViewController () <UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listView;


/**
 分组名称
 */
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;


@end

@implementation SHTVChannelSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:SHNavigationBarControllerPushHidderTabBarNotification object:@(YES)];
    
    self.channelGroup.channels = [SHSQLManager.shareSHSQLManager getTVChannels:self.channelGroup];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Channel Setting";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addChannel)
                                         isLeft:false
     ];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHTVChannelSettingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHTVChannelSettingCell class])];
    
    self.listView.rowHeight =
    [SHTVChannelSettingCell rowHeight];
    
    self.groupNameTextField.text = self.channelGroup.groupName;
}

// MARK: - 设备的添加与删除

/// 添加新的分组
- (void)addChannel {
    
    SHChannel *channel = [[SHChannel alloc] init];
    channel.tvID = self.channelGroup.tvID;
    channel.groupID = self.channelGroup.groupID;
    channel.channelName = @"channel";
    channel.iconName = @"channel_icon";
    channel.channelID = [SHSQLManager.shareSHSQLManager getAvailableTVChannelID:channel];
    
    [SHSQLManager.shareSHSQLManager insertTVChannel:channel];
    
    SHTVChannelDetailViewController *detailController =
        [[SHTVChannelDetailViewController alloc] init];
    
    detailController.channel = channel;
    
    [self.navigationController pushViewController:detailController animated:YES];
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
    
    self.channelGroup.groupName = textField.text;
    
    [SHSQLManager.shareSHSQLManager updateTVChannelGroup:self.channelGroup];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
     
    [textField resignFirstResponder];
    
    return YES;
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHTVChannelDetailViewController *detailController =
    [[SHTVChannelDetailViewController alloc] init];
    
    detailController.channel =
    self.channelGroup.channels[indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHChannel *channel =
        self.channelGroup.channels[indexPath.row];
        
        [self.channelGroup.channels removeObject:channel];
        
        [SHSQLManager.shareSHSQLManager deleteTVChannel:channel];
        
        [tableView reloadData];
    }];
    
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHTVChannelDetailViewController *detailController =
        [[SHTVChannelDetailViewController alloc] init];
        
        detailController.channel =
        self.channelGroup.channels[indexPath.row];
        
        [self.navigationController pushViewController:detailController animated:YES];
    }];
    
    
    return @[deleteAction, editAction];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.channelGroup.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHTVChannelSettingCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHTVChannelSettingCell class]) forIndexPath:indexPath];
    
    cell.channel = self.channelGroup.channels[indexPath.row];
    
    return cell;
}


@end
