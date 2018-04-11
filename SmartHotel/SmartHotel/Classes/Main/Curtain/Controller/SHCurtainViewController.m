//
//  SHCurtainViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCurtainViewController.h"
#import "SHCurtainViewCell.h"

@interface SHCurtainViewController () <UITableViewDataSource>

/// 所有的窗帘
@property (strong, nonatomic) NSMutableArray *allCurtains;

/// 窗帘列表
@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

@implementation SHCurtainViewController


// MARK: - 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allCurtains.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHCurtainViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHCurtainViewCell class]) forIndexPath:indexPath];
    
    cell.curtain = self.allCurtains[indexPath.row];
    
    return cell;
}

// MARK: - 视图加载

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 查询所有的窗帘
    self.allCurtains = [[SHSQLManager shareSHSQLManager] getRoomCurtains];
    
    printLog(@"所有的窗帘: %@", self.allCurtains);

    [self.listView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Curtain"];
    
    self.listView.rowHeight = [SHCurtainViewCell rowHeightForCurtainViewCell];
    
    [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([SHCurtainViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHCurtainViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
