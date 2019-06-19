//
//  SHMacroSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroSettingViewController.h"
#import "SHMacroSettingViewCell.h"
#import "SHMacroDetailViewController.h"

@interface SHMacroSettingViewController () <UITableViewDataSource, UITableViewDelegate>

/// 所有的宏命令
@property (nonatomic, strong) NSMutableArray *allMacros;

/**
 宏显示列表
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHMacroSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:SHNavigationBarControllerPushHidderTabBarNotification object:@(YES)];
    
    self.allMacros =
        [SHSQLManager.shareSHSQLManager getMacros];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Scenes Setting";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addMacro)
                                         isLeft:false
     ];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroSettingViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHMacroSettingViewCell class])];
    
    self.listView.rowHeight =
        [SHMacroSettingViewCell rowHeight];
    
    
}

// MARK: - 设备的添加与删除

- (void)addMacro {
    
    SHMacro *macro = [[SHMacro alloc] init];
    
    macro.macroID =
        SHSQLManager.shareSHSQLManager.getAvailableMacroID;
    macro.macroName = @"macro";
    macro.macroIconName = @"Scene_1";
    
    [SHSQLManager.shareSHSQLManager insertMacro:macro];
  
    SHMacroDetailViewController *detailController =
    [[SHMacroDetailViewController alloc] init];

    detailController.macro = macro;

    [self.navigationController pushViewController:detailController animated:YES];
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMacroDetailViewController *detailController =
    [[SHMacroDetailViewController alloc] init];
    
    detailController.macro = self.allMacros[indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHMacro *macro = self.allMacros[indexPath.row];
        
        [self.allMacros removeObject:macro];
        
        [SHSQLManager.shareSHSQLManager deleteMacro:macro];
        
        [tableView reloadData];
    }];
    
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHMacroDetailViewController *detailController =
            [[SHMacroDetailViewController alloc] init];
        
        detailController.macro =
            self.allMacros[indexPath.row];
        
        [self.navigationController pushViewController:detailController animated:YES];
    }];
    
    
    return @[deleteAction, editAction];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allMacros.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMacroSettingViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHMacroSettingViewCell class]) forIndexPath:indexPath];
    
    cell.macro = self.allMacros[indexPath.row];
    
    return cell;
}

@end
