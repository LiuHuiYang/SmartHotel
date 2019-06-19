//
//  SHTVSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHTVSettingViewController.h"
#import "SHTVSettingViewCell.h"
#import "SHTVChannelSettingViewController.h"

@interface SHTVSettingViewController () <UITableViewDelegate, UITableViewDataSource>
 

/**
 值输入框
 */
@property (weak, nonatomic) UITextField *valueTextField;

/**
 频道分组列表
 */
@property (weak, nonatomic) IBOutlet UITableView *groupListView;


@end

@implementation SHTVSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:SHNavigationBarControllerPushHidderTabBarNotification object:@(YES)];
    
    self.tv.channelGroups = [SHSQLManager.shareSHSQLManager getTVChannelGroups:self.tv];
    
    [self.groupListView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TV Setting";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addChannleGroup)
                                         isLeft:false
     ];
    
    [self.groupListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHTVSettingViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHTVSettingViewCell class])];
    
    self.groupListView.rowHeight =
        [SHTVSettingViewCell rowHeight];
    
}

// MARK: - 设备的添加与删除

/// 添加新的分组
- (void)addChannleGroup {
    
    SHChannelGroup *channelGroup = [[SHChannelGroup alloc] init];
    
    channelGroup.groupName = @"new group";
    channelGroup.tvID = self.tv.tvID;
    channelGroup.groupID = [SHSQLManager.shareSHSQLManager getAvailableTVChannelGroupID:channelGroup];
    
    [SHSQLManager.shareSHSQLManager insertTVChannelGroup:channelGroup];
    
    SHTVChannelSettingViewController *channelSettingController = [[SHTVChannelSettingViewController alloc] init];
    
    channelSettingController.channelGroup = channelGroup;
    
    [self.navigationController pushViewController:channelSettingController animated:YES];
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHTVChannelSettingViewController *channelSettingController = [[SHTVChannelSettingViewController alloc] init];
    
    channelSettingController.channelGroup = self.tv.channelGroups[indexPath.row];
    
    [self.navigationController pushViewController:channelSettingController animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHChannelGroup *channelGroup =
        self.tv.channelGroups[indexPath.row];
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
         
        [self.tv.channelGroups removeObject:channelGroup];
        
        [SHSQLManager.shareSHSQLManager deleteTVChannelGroup:channelGroup];
        
        [tableView reloadData];
    }];
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHTVChannelSettingViewController *channelSettingController = [[SHTVChannelSettingViewController alloc] init];
        
        channelSettingController.channelGroup = self.tv.channelGroups[indexPath.row];
        
        [self.navigationController pushViewController:channelSettingController animated:YES];
 
    }];
    
    
    return @[deleteAction, editAction];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tv.channelGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHTVSettingViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHTVSettingViewCell class]) forIndexPath:indexPath];
    
    cell.channelGroup = self.tv.channelGroups[indexPath.row];
    
    return cell;
}

@end
