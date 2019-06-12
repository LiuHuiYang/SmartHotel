//
//  SHMacroSettingViewController.m
//  SmartHotel
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroSettingViewController.h"
#import "SHMacroSettingViewCell.h"

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
    
//    self.allMacros =
//        [SHSQLManager.shareSHSQLManager nil];
    
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
    
//    SHMacro *macro = [[SHMacro alloc] init];
    
//    macro.lightID = [SHSQLManager.shareSHSQLManager getAvailableLightID];
//
//    macro.lightName = @"light";
//
//    [SHSQLManager.shareSHSQLManager insertLight:light];
//
//    SHLightDetailViewController *detailController =
//    [[SHLightDetailViewController alloc] init];
//
//    detailController.macro = macro;
//
//    [self.navigationController pushViewController:detailController animated:YES];
}

// MARK: - 代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
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
