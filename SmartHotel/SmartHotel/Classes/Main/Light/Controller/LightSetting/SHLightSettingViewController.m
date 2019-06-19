//
//  SHLightSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHLightSettingViewController.h"
#import "SHLightSettingViewCell.h"

#import "SHDeviceParametersViewController.h"

@interface SHLightSettingViewController ()
    
/// 所有的灯光设备
@property (strong, nonatomic) NSMutableArray *allLights;

/**
 灯光设备列表
 */
@property (weak, nonatomic) IBOutlet UITableView *listView;

@end

@implementation SHLightSettingViewController
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.allLights =
        [[SHSQLManager shareSHSQLManager] getLights];
    
    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Light Setting";
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"addDevice_navigationbar"
                          hightlightedImageName:@"addDevice_navigationbar"
                                      addTarget:self
                                         action:@selector(addLight)
                                         isLeft:false
     ];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHLightSettingViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHLightSettingViewCell class])];
    
    self.listView.rowHeight =
        [SHLightSettingViewCell rowHeight];
}

 
// MARK: - 设备的添加与删除
    

/**
 增加灯光
 */
- (void)addLight {
    
    SHLight *light = [[SHLight alloc] init];
    
    light.lightID = [SHSQLManager.shareSHSQLManager getAvailableLightID];
    
    light.lightName = @"light";
    
    [SHSQLManager.shareSHSQLManager insertLight:light];
    
    SHDeviceParametersViewController *detailController =
    [[SHDeviceParametersViewController alloc] init];
    
    detailController.light = light;
    
    [self.navigationController pushViewController:detailController animated:YES];
}
    
// MARK: - 代理
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHDeviceParametersViewController *detailController =
        [[SHDeviceParametersViewController alloc] init];
    
    detailController.light =
        self.allLights[indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
}
    
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
    
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHLight *light =
        self.allLights[indexPath.row];
        
        [self.allLights removeObject:light];
        
        [SHSQLManager.shareSHSQLManager deleteLight:light];
        
        [tableView reloadData];
    }];
    
    
    // 编辑操作
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        SHDeviceParametersViewController *detailController =
        [[SHDeviceParametersViewController alloc] init];
        
        detailController.light =
            self.allLights[indexPath.row];
        
        [self.navigationController pushViewController:detailController animated:YES];
    }];
    
    
    return @[deleteAction, editAction];
}
    
// MARK: - 数据源
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allLights.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHLightSettingViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHLightSettingViewCell class]) forIndexPath:indexPath];
    
    cell.light = self.allLights[indexPath.row];
    
    return cell;
}

@end
