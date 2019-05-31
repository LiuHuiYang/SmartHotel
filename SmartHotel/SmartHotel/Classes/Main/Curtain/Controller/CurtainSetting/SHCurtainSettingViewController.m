//
//  SHCurtainSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHCurtainSettingViewController.h"
#import "SHCurtainSettingViewCell.h"
#import "SHCurtainDetailViewController.h"

@interface SHCurtainSettingViewController () <UITableViewDataSource, UITableViewDelegate>

/// 所有的窗帘
@property (strong, nonatomic) NSMutableArray *allCurtains;

/**
 窗帘列表
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;

@end

@implementation SHCurtainSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.allCurtains =
        [[SHSQLManager shareSHSQLManager] getCurtains];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Curtain Setting";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addCurtain)
                                         isLeft:false
     ];

    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHCurtainSettingViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHCurtainSettingViewCell class])];
      
    self.listView.rowHeight =
        [SHCurtainSettingViewCell rowHeight];
}

// MARK: - 设备的添加与删除

/// 增加窗帘
- (void)addCurtain {
    
    SHCurtain *curtain = [[SHCurtain alloc] init];
    curtain.curtainName = @"curtain";
    curtain.curtainID =
        [SHSQLManager.shareSHSQLManager getAvailableCurtainID];
 
    [SHSQLManager.shareSHSQLManager insertCurtain:curtain];
    
    SHCurtainDetailViewController *detailController =
        [[SHCurtainDetailViewController alloc] init];
    
    detailController.curtain = curtain;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHCurtainDetailViewController *detailController =
    [[SHCurtainDetailViewController alloc] init];
    
    detailController.curtain =
        self.allCurtains[indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHCurtain *curtain =
            self.allCurtains[indexPath.row];
        
        [self.allCurtains removeObject:curtain];
        
        [SHSQLManager.shareSHSQLManager deleteCurtain:curtain];
        
        [tableView reloadData];
    }];
    
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHCurtainDetailViewController *detailController =
        [[SHCurtainDetailViewController alloc] init];
        
        detailController.curtain =
        self.allCurtains[indexPath.row];
        
        [self.navigationController pushViewController:detailController animated:YES];
    }];
    
    
    return @[deleteAction, editAction];
}

// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allCurtains.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHCurtainSettingViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHCurtainSettingViewCell class]) forIndexPath:indexPath];
    
    cell.curtain = self.allCurtains[indexPath.row];
    
    
    return cell;
}

@end
