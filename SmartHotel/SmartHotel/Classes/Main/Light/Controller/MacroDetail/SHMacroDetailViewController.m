//
//  SHMacroDetailViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroDetailViewController.h"
#import "SHMacroDetailViewCell.h"
#import "SHMacroCommandDetailViewController.h"

@interface SHMacroDetailViewController () <
    UITableViewDataSource, UITableViewDelegate>


/**
 宏命令集合
 */
@property (strong, nonatomic) NSMutableArray *macroCommands;


/**
 命令集合
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHMacroDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.macroCommands = [SHSQLManager.shareSHSQLManager getMacroCommands:self.macro];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"Scene Detail";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addMacroCommand)
                                         isLeft:false
     ];
    
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHMacroDetailViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHMacroDetailViewCell class])];
    
    self.listView.rowHeight =
        SHMacroDetailViewCell.rowHeight;
    
}

// MARK: - 设备的添加与删除


/**
 添加宏命令
 */
- (void)addMacroCommand {
    
    SHMacroCommand *macroCommand =
        [[SHMacroCommand alloc] init];
    
    macroCommand.remark = @"scene command";
    macroCommand.macroID = self.macro.macroID;
    macroCommand.macroCommandID = [SHSQLManager.shareSHSQLManager getAvailableMacroCommandID:self.macro.macroID];
    
    [SHSQLManager.shareSHSQLManager insertMacroCommand:macroCommand];
    
    SHMacroCommandDetailViewController *detailController =
        [[SHMacroCommandDetailViewController alloc] init];
    
    detailController.macroCommand = macroCommand;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMacroCommandDetailViewController *detailController =
    [[SHMacroCommandDetailViewController alloc] init];
    
    detailController.macroCommand =
        self.macroCommands[indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHMacroCommand *macroCommand =
            self.macroCommands[indexPath.row];
        
        [self.macroCommands removeObject:macroCommand];
        
        [SHSQLManager.shareSHSQLManager deleteMacroCommand:macroCommand];
        
        [tableView reloadData];
    }];
    
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHMacroCommandDetailViewController *detailController =
        [[SHMacroCommandDetailViewController alloc] init];
        
        detailController.macroCommand =
        self.macroCommands[indexPath.row];
        
        [self.navigationController pushViewController:detailController animated:YES];
    }];
    
    
    return @[deleteAction, editAction];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.macroCommands.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHMacroDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHMacroDetailViewCell class]) forIndexPath:indexPath];
    
    cell.macroCommand = self.macroCommands[indexPath.row];
    
    return cell;
}

@end
