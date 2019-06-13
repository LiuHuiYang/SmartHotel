//
//  SHTVSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHTVSettingViewController.h"
#import "SHTVSettingViewCell.h"

@interface SHTVSettingViewController ()


/**
 当前设置的tv
 */
@property (nonatomic, strong) SHTV *tv;


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
    
    self.tv = [[SHSQLManager.shareSHSQLManager getTV] lastObject];
    
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
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:@"Add Channel Group" message:nil isCustom:YES];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
       
        [textField becomeFirstResponder];
        textField.clearButtonMode =
        UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"channel group name";
        
        self.valueTextField = textField;
    }];
    
    TYAlertAction *cancelAction =
        [TYAlertAction actionWithTitle:@"cancel" style:TYAlertActionStyleCancel handler:nil];
    
    [alertView addAction:cancelAction];
    
    TYAlertAction *saveAction = [TYAlertAction actionWithTitle:@"save" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        NSString *groupName = self.valueTextField.text;
        
        if (groupName.length == 0) {
            
            [SVProgressHUD showInfoWithStatus:
             @"The value should not be empty!"
             ];
            
            return ;
        }
        
        // 创建新的分组
        SHChannelGroup *group =
            [[SHChannelGroup alloc] init];
        
        group.tvID = self.tv.tvID;
        group.groupName = groupName;
        
        group.groupID = [SHSQLManager.shareSHSQLManager getAvailableTVChannelGroupID:group];
        
        // 保存到新的分组
        [SHSQLManager.shareSHSQLManager insertTVChannelGroup:group];
        
        [self.tv.channelGroups addObject:group];
        
        [self.groupListView reloadData];
    }];
    
    [alertView addAction:saveAction];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];

    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil
    ];
}

// MARK: - 代理

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
        
        TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:@"Update" message:nil isCustom:YES];
        
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            [textField becomeFirstResponder];
            textField.clearButtonMode =
            UITextFieldViewModeWhileEditing;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.placeholder = channelGroup.groupName;
            
            self.valueTextField = textField;
        }];
        
        TYAlertAction *cancelAction =
        [TYAlertAction actionWithTitle:@"cancel" style:TYAlertActionStyleCancel handler:nil];
        
        [alertView addAction:cancelAction];
        
        TYAlertAction *saveAction = [TYAlertAction actionWithTitle:@"save" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            
            NSString *groupName = self.valueTextField.text;
            
            if (groupName.length == 0) {
                
                [SVProgressHUD showInfoWithStatus:
                 @"The value should not be empty!"
                 ];
                
                return ;
            }
            
            
            channelGroup.groupName = groupName;
            
            [SHSQLManager.shareSHSQLManager updateTVChannelGroup:channelGroup];
            
            [self.groupListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            
        }];
        
        [alertView addAction:saveAction];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
        
        alertController.backgoundTapDismissEnable = YES;
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil
         ];
 
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
