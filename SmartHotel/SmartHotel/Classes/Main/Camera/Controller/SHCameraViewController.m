//
//  SHCameraViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCameraViewController.h"
#import "SHCameraViewCell.h"
#import "SHCameraButton.h"

@interface SHCameraViewController () <UITableViewDelegate, UITableViewDataSource>

/// 摄像头列表
@property (weak, nonatomic) IBOutlet UITableView *cameraListView;

/// 摄像头名称
@property (strong, nonatomic) NSMutableArray *cameraNames;

/// 稍等
@property (weak, nonatomic) IBOutlet SHCameraButton *waitButton;

/// 请勿打扰
@property (weak, nonatomic) IBOutlet SHCameraButton *dndButton;

/// 对讲
@property (weak, nonatomic) IBOutlet SHCameraButton *talkButton;

/// 设置
@property (weak, nonatomic) IBOutlet SHCameraButton *settingButton;

@end

@implementation SHCameraViewController


// MARK: - tableView的数据库与代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cameraNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHCameraViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHCameraViewCell class]) forIndexPath:indexPath];
    
    cell.camereName = self.cameraNames[indexPath.row];
    
    return cell;
}

// MARK: - 视图加载

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Cameras"];
    
    [self.waitButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"PleaseWait"] forState:UIControlStateNormal];
    
    [self.dndButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"DND"] forState:UIControlStateNormal];
    
    [self.talkButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"CAMERA" withSubTitle:@"Talk"] forState:UIControlStateNormal];
    
    [self.settingButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"CAMERA" withSubTitle:@"Settings"] forState:UIControlStateNormal];
    
    [self.cameraListView registerNib:[UINib nibWithNibName:NSStringFromClass([SHCameraViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SHCameraViewCell class])];
    
    self.cameraListView.rowHeight = [SHCameraViewCell rowHeightForCameraViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - getter && setter

- (NSMutableArray *)cameraNames {
    
    if (!_cameraNames) {
        
        _cameraNames = [NSMutableArray arrayWithObjects:
                        @"Door", @"Lobby",@"Pool",@"WebCamera",@"CityCamera",@"HotelCamera",
                        
                        nil];
    }
    
    return _cameraNames;
}

@end
